--从技能库选出不重样的BOSS技能
function random_table(t, num,name)
	local tmp ={}
	local tmp2={}
	local x =1
	for i,v in pairs(t) do
		if t[i] ~= name then
    	   tmp[x]=t[i]
    	   x = x+1
  		end
    end
  
    
    for i=1,num do
    local r = RandomInt(1,#tmp)
   	  tmp2[i]= tmp[r]
   	  table.remove(tmp,r)
    end
    return tmp2

end



--召唤个人BOSS
function CallGrBoss(caster,x,playerID)
		local hero = PlayerUtil.GetHero(playerID)
		local spawner=Entities:FindByName(nil,shuaguai.sgd[playerID+1])
		local p = spawner:GetAbsOrigin()
		local r  = #Tzboss.sjboss
		local r2  = RandomInt(1,r)
		local unitname = Tzboss.sjboss[r2]
		local unit = CreateUnitByName(unitname, p, false, nil, hero, TEAM_ENEMY)
	
		local difficulty =   GetGameDifficulty()
		--设置随机BOSS的品质  --1是个人BOSS
		unit:SetContextNum("sjboss",1,0)
		unit.zhz = playerID--召唤者的ID
		local name2 = unit:GetAbilityByIndex(0):GetAbilityName()
		--暂时不设置	

		local level = hero:GetLevel()
		local wave = math.ceil(level /30)
		if wave > 6 then
			wave = 6
		end
		level = wave * 30
		local hp = ma.bosshp[wave] * ma.bosshpxs[unitname] 	--设置怪物的动态血量
		local maxhp = hp * sjbossHp[x]  * ma.nd_hp[difficulty] 
		if maxhp > 200000000 then   --如果boss血量超过5亿，就给加减伤
			unit.shjs = string.format("%.2f",maxhp / 200000000)
			maxhp = 200000000
		end
		unit:SetBaseMaxHealth(maxhp) 
--
		local armor = ma.bossarmor[wave] * ma.bossarmorxs[unitname]	--设置怪物的动态护甲
		local maxarmor = armor *sjbossArmor[x]* ma.nd_hj[difficulty]
		unit:SetPhysicalArmorBaseValue(maxarmor)
--		
		local mk = maxarmor*0.06/(1+maxarmor*0.06)*100    	--设置BOSS的魔抗

			unit:SetBaseMagicalResistanceValue(mk)
		local attack = ma.bossdamage[wave] * ma.bossdamagexs[unitname]	--设置怪物的动态攻击
		local maxattack = attack *sjbossDamage[x]  * ma.nd_gj[difficulty]
		if maxattack > 100000000 then
			unit.shzj = string.format("%.2f",maxattack / 100000000)
			maxattack = 100000000
		end
		unit:SetBaseDamageMax(maxattack)

		unit:CreatureLevelUp(level)
			

		--设置该单位会有多少个技能
		local num = sjbossAbilityNum[x]
		local ab = random_table(bossAbility,num,name2)
		for _, name in ipairs(ab) do
      	 unit:AddAbility(name)
       	  unit:FindAbilityByName(name):SetLevel(1)
    	end



		--BOSS的掉落率
		unit.isboss = 1
		unit.dbl = sjbossbl[x]
		unit.bosspoint = sjbosspoint[x]
		unit.dbpz =  sjbossdbpz[x]
		unit.getsds =x*x*10 --杀敌数为10倍


		--标记为玩家几的存活怪
		local id = playerID +1
		unit.playchs = id;
		--一个怪代表一个存活，boss另算
		unit.playchsl = 5;
		--对应的玩家怪物数量+5
		Stage.chs["chs"..id] = Stage.chs["chs"..id] + unit.playchsl
		--同步往服务器发怪物目前的数量
		local  nowchs = #Stage.kezhw
		for _, PlayerID in pairs(Stage.playeronline) do
			nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
		end
		table.insert(Stage["player"..id-1],unit:GetEntityIndex())
		CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})

		--当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
		unit:AddNewModifier(nil, nil, "modifier_phased", {duration=60})
		unit:AddNewModifier(unit, nil, "modifier_kill", { duration = 60 })
		NotifyUtil.ShowSysMsg2(nil,"#call_grboss",{name=unitname,hero=caster:GetUnitName()})
	
	return unit;
end



--召唤团队BOSS
function CallTeamBoss(caster,x,playerID)
		local hero = PlayerUtil.GetHero(playerID)
		--BOSS直接在中间刷新
		local spawner=Entities:FindByName(nil,"fyd1")
		local p = spawner:GetAbsOrigin()
		p.z=p.z-200
		local r  = #Tzboss.sjboss
		local r2  = RandomInt(1,r)
		local unitname = Tzboss.sjboss[r2]
		local unit = CreateUnitByName(unitname, p, false, nil, hero, TEAM_ENEMY)
		local difficulty =   GetGameDifficulty()
		local playernum = Stage.playernum

		--设置随机BOSS的品质  --2是团队BOSS
		unit:SetContextNum("sjboss",2,0)
		local name2 = unit:GetAbilityByIndex(0):GetAbilityName()
		--暂时不设置
	

		
		local level = hero:GetLevel()
		local wave = math.ceil(level /30)
		if wave > 6 then
			wave = 6
		end
		level = wave * 30
			local hp = ma.bosshp[wave] * ma.bosshpxs[unitname] 	--设置怪物的动态血量
			local maxhp = hp * sjbossHp[x]  * ma.nd_hp[difficulty] * ma.rs_hp[playernum]--
			if maxhp > 200000000 then   --如果boss血量超过5亿，就给加减伤
				unit.shjs = string.format("%.2f",maxhp / 200000000)
				maxhp = 200000000
			end
			unit:SetBaseMaxHealth(maxhp) 
--
			local armor = ma.bossarmor[wave] * ma.bossarmorxs[unitname]	--设置怪物的动态护甲
			local maxarmor = armor *sjbossArmor[x] * ma.nd_hj[difficulty] * ma.rs_hj[playernum]
			unit:SetPhysicalArmorBaseValue(maxarmor)
--
			local mk = maxarmor*0.06/(1+maxarmor*0.06)*100    	--设置BOSS的魔抗

			unit:SetBaseMagicalResistanceValue(mk)

			local attack = ma.bossdamage[wave] * ma.bossdamagexs[unitname]	--设置怪物的动态攻击
			local maxattack = attack *sjbossDamage[x] * ma.rs_gj[playernum] --
			if maxattack > 100000000 then
				unit.shzj = string.format("%.2f",maxattack / 100000000)
				maxattack = 100000000
			end
			unit:SetBaseDamageMin(maxattack)
			unit:SetBaseDamageMax(maxattack)

			unit:CreatureLevelUp(level)


		--设置该单位会有多少个技能
		local num = sjbossAbilityNum[x]
		local ab = random_table(bossAbility,num,name2)
		for _, name in ipairs(ab) do
      	  unit:AddAbility(name)
       	  unit:FindAbilityByName(name):SetLevel(1)
    	end
		--BOSS的掉落率
		unit.isboss = 1
		unit.dbl = sjbossbl[x]
		unit.dbpz =  sjbossdbpz[x]
		unit.getsds =x*x*10 --杀敌数为10倍
		unit.bosspoint = sjbosspoint[x]

		--标记为玩家几的存活怪
		local id = playerID +1
		unit.playchs = id;
		--一个怪代表一个存活，boss另算
		unit.playchsl = 5;
		--对应的玩家怪物数量+5
		Stage.chs["chs"..id] = Stage.chs["chs"..id] + unit.playchsl
		--同步往服务器发怪物目前的数量
		local  nowchs = #Stage.kezhw
		for _, PlayerID in pairs(Stage.playeronline) do
			nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
		end
		table.insert(Stage["player"..id-1],unit:GetEntityIndex())
		CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})


		--当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
		unit:AddNewModifier(nil, nil, "modifier_phased", {duration=60})
		unit:AddNewModifier(unit, nil, "modifier_kill", { duration = 60 })
		NotifyUtil.ShowSysMsg2(nil,"#call_teamboss",{name=unitname,hero=caster:GetUnitName()})
		
		return unit;
end

--召唤套装BOSS
--@param #int pz 	召唤符的掉宝品质
--@param #int x 	召唤符的品质
--@param #int p 	召唤BOSS的地点
function CallTzBoss(caster,pz,x,bosspoint,playerID)
		local hero = PlayerUtil.GetHero(playerID)
		local spawner=Entities:FindByName(nil,shuaguai.sgd[playerID+1])
		local p = spawner:GetAbsOrigin()
		local p = FindRandomPoint(p,900)
		local tzname = Tzboss.tzboss[pz]
		local r  = #Tzboss.tzbossname[tzname]
		local r2  = RandomInt(1,r)
		local unitname = Tzboss.tzbossname[tzname][r2]
		local unit = CreateUnitByName(unitname, p, false, nil, hero, TEAM_ENEMY)
		local difficulty =   GetGameDifficulty()
		--设置套装BOSS的品质
		unit:SetContextNum("ywboss",pz,0)
		--设置套装BOSS的掉落权  
		--暂时不设置
		--unit:SetContextNum("ywboss",pz,0)
		local wave = Stage.wave 
		if  wave ==nil then
			wave = 1
		end
			local hp = unit:GetMaxHealth()	--设置怪物的动态血量
			local maxhp = hp * bossHp[x]  * (0.9+wave*0.1)   * ma.nd_hp[difficulty]
			if maxhp > 200000000 then   --如果boss血量超过5亿，就给加减伤
				unit.shjs = string.format("%.2f",maxhp / 200000000)
				maxhp = 200000000
			end
			unit:SetBaseMaxHealth(maxhp)
--
			local armor = unit:GetPhysicalArmorBaseValue()	--设置怪物的动态护甲
			local maxarmor = armor *bossArmor[x]  * ma.nd_hj[difficulty]
			unit:SetPhysicalArmorBaseValue(maxarmor)
--
			local mk = maxarmor*0.06/(1+maxarmor*0.06)*100    	--设置BOSS的魔抗
			unit:SetBaseMagicalResistanceValue(mk)

			local attack = unit:GetBaseDamageMin()	--设置怪物的动态攻击
			local maxattack = attack *bossDamage[x]  *1.6* (0.9+wave*0.1)  * ma.nd_gj[difficulty]
			if maxattack > 100000000 then
				unit.shzj = string.format("%.2f",maxattack / 100000000)
				maxattack = 100000000
			end
			unit:SetBaseDamageMin(maxattack)
			unit:SetBaseDamageMax(maxattack)

		local maxexp = unit:GetDeathXP() * x
		unit:SetDeathXP(maxexp)

		--BOSS的掉落率
		unit.isboss = 1
		unit.dbl = x 
		unit.zhz = playerID
		unit.bosspoint = bosspoint
		unit.getsds =x*pz*5 --杀敌数为5倍

		--标记为玩家几的存活怪
		local id = playerID +1
		unit.playchs = id;
		--一个怪代表一个存活，boss另算
		unit.playchsl = 3;
		--对应的玩家怪物数量+1
		Stage.chs["chs"..id] = Stage.chs["chs"..id] + unit.playchsl
		--同步往服务器发怪物目前的数量
		local  nowchs = #Stage.kezhw
		for _, PlayerID in pairs(Stage.playeronline) do
			nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
		end
		table.insert(Stage["player"..id-1],unit:GetEntityIndex())
		CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})
		--当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
		unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		NotifyUtil.ShowSysMsg2(nil,"#call_tzboss",{name=unitname,hero=caster:GetUnitName()})
		--小地图显示
		--EntityHelper.ShowOnMiniMap(boss)
		
		return unit;
end

--召唤贪欲BOSS
--@param #int pz 	召唤符的掉宝品质
--@param #int x 	召唤符的品质
--@param #int p 	召唤BOSS的地点
function CallTyBoss2(caster,playerID)
		if not caster.tybosstime or caster.tybosstime >10 then
			return nil
		end
		local s = playerID +1
		Stage["gj"..s] = Stage["gj"..s]  +0.3
		Stage["xl"..s] = Stage["xl"..s]  +0.3
		Stage["fy"..s] = Stage["fy"..s]  +0.3
		Stage["jq"..s] = Stage["jq"..s]  +0.15
		Stage["jy"..s] = Stage["jy"..s]  +0.15
		local lv = Weightsgetvalue_one(tyboss_smbw) 
		local item = CreateItem("item_smbw_"..lv, caster, caster)
		caster:AddItem(item)
		local item2 = CreateItem("item_bw_1", caster, caster)
		caster:AddItem(item2)

		local spawner=Entities:FindByName(nil,shuaguai.sgd[playerID+1])
		local p = spawner:GetAbsOrigin()
		local unit = CreateUnitByName("tl_BOSS_1", p, false, nil, caster, TEAM_ENEMY)
		local difficulty =   GetGameDifficulty()
		local wave = caster.tybosstime
		local hp = ma.tybosshp[wave]	--设置怪物的动态血量
		local maxhp = hp  * ma.nd_hp[difficulty]
		if maxhp > 200000000 then   --如果boss血量超过5亿，就给加减伤
			unit.shjs = string.format("%.2f",maxhp / 200000000)
			maxhp = 200000000
		end
		unit:SetBaseMaxHealth(maxhp)
--
		local armor = ma.tybossfy[wave]	--设置怪物的动态护甲
		local maxarmor = armor	 * ma.nd_hj[difficulty]
		unit:SetPhysicalArmorBaseValue(maxarmor)
 		unit:AddAbility("ty_boss_4"):SetLevel(wave)
 		unit:AddAbility("ty_boss_3"):SetLevel(wave)
		local mk = maxarmor*0.06/(1+maxarmor*0.06)*100    	--设置BOSS的魔抗
		unit:SetBaseMagicalResistanceValue(mk)

		local attack =  ma.tybossgj[wave]	--设置怪物的动态攻击
		local maxattack = attack * ma.nd_gj[difficulty]
		if maxattack > 100000000 then
			unit.shzj = string.format("%.2f",maxattack / 100000000)
			maxattack = 100000000
		end
		unit:SetBaseDamageMin(maxattack)
		unit:SetBaseDamageMax(maxattack)
		--BOSS的掉落率
		unit.isboss = 1
		unit.zhz = playerID
		unit.tyboss = 1
		--标记为玩家几的存活怪
		local id = playerID +1
		unit.playchs = id;
		--一个怪代表一个存活，boss另算
		unit.playchsl = 5;
		--对应的玩家怪物数量+1
		Stage.chs["chs"..id] = Stage.chs["chs"..id] + unit.playchsl
		--同步往服务器发怪物目前的数量
		local  nowchs = #Stage.kezhw
		for _, PlayerID in pairs(Stage.playeronline) do
			nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
		end
		table.insert(Stage["player"..id-1],unit:GetEntityIndex())
		CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})
		--当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
		unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		NotifyUtil.ShowSysMsg2(nil,"#call_tyboss",{name="tl_BOSS_1",hero=caster:GetUnitName()})
		--小地图显示
		--EntityHelper.ShowOnMiniMap(boss)
		caster.tybosstime= caster.tybosstime +1
		return unit;
end

--召唤冤魔
--@param #int pz 	召唤符的掉宝品质
--@param #int x 	召唤符的品质
--@param #int p 	召唤BOSS的地点
function CallYmBoss(caster,playerID)
		
		
		local spawner=Entities:FindByName(nil,shuaguai.sgd[playerID+1])
		local p = spawner:GetAbsOrigin()
		local unit = CreateUnitByName("ym_BOSS_1", p, false, nil, caster, TEAM_ENEMY)
		local difficulty =   GetGameDifficulty()
		local wave = caster.zh_ym
		local hp = ma.tybosshp[wave]	--设置怪物的动态血量
		local maxhp = hp  * ma.nd_hp[difficulty]
		if maxhp > 200000000 then   --如果boss血量超过5亿，就给加减伤
			unit.shjs = string.format("%.2f",maxhp / 200000000)
			maxhp = 200000000
		end
		unit:SetBaseMaxHealth(maxhp)
--
		local armor = ma.tybossfy[wave]	--设置怪物的动态护甲
		local maxarmor = armor	 * ma.nd_hj[difficulty]
		unit:SetPhysicalArmorBaseValue(maxarmor)

		local mk = maxarmor*0.06/(1+maxarmor*0.06)*100    	--设置BOSS的魔抗
		unit:SetBaseMagicalResistanceValue(mk)

		local attack =  ma.tybossgj[wave]	--设置怪物的动态攻击
		local maxattack = attack * ma.nd_gj[difficulty]
		if maxattack > 100000000 then
			unit.shzj = string.format("%.2f",maxattack / 100000000)
			maxattack = 100000000
		end
		unit:SetBaseDamageMin(maxattack)
		unit:SetBaseDamageMax(maxattack)
		--BOSS的掉落率
		unit.isboss = 1
		unit.zhz = playerID
		unit.ymboss = 1
		unit.ymcs = caster.zh_ym
		--标记为玩家几的存活怪
		local id = playerID +1
		unit.playchs = id;
		--一个怪代表一个存活，boss另算
		unit.playchsl = 3;
		--对应的玩家怪物数量+1
		Stage.chs["chs"..id] = Stage.chs["chs"..id] + unit.playchsl
		--同步往服务器发怪物目前的数量
		local  nowchs = #Stage.kezhw
		for _, PlayerID in pairs(Stage.playeronline) do
			nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
		end
		table.insert(Stage["player"..id-1],unit:GetEntityIndex())
		CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})
		--当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
		unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
		NotifyUtil.ShowSysMsg2(nil,"#call_ymboss",{name="ym_BOSS_1",hero=caster:GetUnitName()})
		--小地图显示
		--EntityHelper.ShowOnMiniMap(boss)
		return unit;
end