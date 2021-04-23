--单位死亡处理，主要是物品掉落，任务处理等
--死亡监听事件的优先级【低于】物品和技能中的OnOwnerDied事件的优先级

local m = {}
---存储特定敌方单位死亡时的处理器。每一个元素的key是单位名称，value是一个table。
--table的key是一个唯一字符串
--value代表一个处理器，其中包括两个元素{num（死亡总数）,handler}
m.nameHandlers = {}
---存储任意敌方单位死亡时的处理器
--元素有一个唯一的key，value是处理函数
m.handlers = {}
--储存宝箱的位置
m.zbbx = {}
m.zbbx_dbl= {}
m.zbbx_dbpz= {}
m.zbbx_lv= {}
--第几个宝箱
m.zbbx_time = 0

m.fhd={
	"player1";
	"player2";
	"player3";
	"player4";
}

--createunit("yg1") 建造单位
--单位被击杀时的处理，只保证流程，具体的处理操作，在对应的函数中进行
function m:OnEntityKilled( keys )
	local unitID = keys.entindex_killed;
	local killerID = keys.entindex_attacker
	--被杀单位
	local unit = EntityHelper.findEntityByIndex(unitID)
	local killer = EntityHelper.findEntityByIndex(killerID)
	
	--被视作英雄的单位（BOSS、精英怪等）、幻象死亡时，移除自定义血条数据
	if unit._CreatedHealthBar and (not unit:IsHero() or unit:IsIllusion()) then
		UnitCs.RemoveHealthBar(unitID)
	end
	

	if unit:GetTeamNumber() ~= TEAM_PLAYER then --敌方单位死亡
		--同步往服务器发怪物目前的数量
		m.SyncEnemyCount(unit)

		if unit.kaer then--boss卡尔的召唤物
			for k,v in pairs(Stage.kezhw) do
				if v==unit:GetEntityIndex() then
					table.remove(Stage.kezhw,k)
					local nowchs = #Stage.kezhw
					for _, PlayerID in pairs(Stage.playeronline) do
						nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
					end
					CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})
				end
			end
		end
		
		if killer == unit and unit:GetPlayerOwnerID() > -1 then
			return;
		end
		
		--记录玩家的杀敌数和给予金钱
		if killer then
			m.RecordKills(killer,unit)
		end
		
		
		local unitName = unit:GetUnitName()
		if unitName == "wq_BOSS_1" then
			--能量之心boss
			m.UpgradeEnergyCore(unit)
		elseif unitName == "BOSS_jb" then
			--金币boss
			m.GoldBoss(killer,unit)
		else --其他怪物，执行物品掉落逻辑
		--	local pid = killer:GetPlayerOwnerID() 
		--	local hero = PlayerUtil.GetHero(pid)
			m.DropItem(killer,unit)
		end
	else --玩家单位死亡
		if unit:IsRealHero() then--英雄死亡
			NotifyUtil.ShowKillHeroMsg(unit,killer)
			--记录死亡次数
			PlayerResource:IncrementDeaths(PlayerUtil.GetOwnerID(unit),killerID)
			if not unit.leave then
				m.RespawnHero(unit);
			end
			local ms = GetGameDifficultyModel()  --难度模式
			if ms == 6 then 	--如果是赏金模式，死亡则会掉落全部的金币
				local playerID = unit:GetPlayerOwnerID()
				local xj = PlagueLand:GetNowGold(playerID)* -1
				PlagueLand:ModifyCustomGold(playerID, xj)
			end
		else
			--召唤单位
			m.SummonedUnit(unit);
		end
	end
end

function m.SyncEnemyCount(unit)
	if unit.playchs then
		local s = unit.playchs
		local sl = unit.playchsl
		Stage.chs["chs"..s] = Stage.chs["chs"..s] - sl
		for k,v in pairs(Stage["player"..s-1]) do
			if v == unit:GetEntityIndex() then
				table.remove(Stage["player"..s-1],k)
			end		
		end
		local nowchs = #Stage.kezhw
		for _, PlayerID in pairs(Stage.playeronline) do
			nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
		end
		CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})
	end
end

function m.RecordKills(killer,diedUnit)
	local pid = killer:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(pid)
	if hero ~= nil then	
		--记录dota自带的杀敌数量，仅仅记录数量，跟上边的杀敌数没有关系
		PlayerResource:IncrementKills(pid,diedUnit:entindex())
		if diedUnit.playchs then
			local playerID = diedUnit.playchs -1
			local caster = PlayerUtil.GetHero(playerID)
			if caster then
				if pid ~= playerID or GetGameDifficulty() < 29 then
					local sds = 1 --如果单位有杀敌数，则加上赋予的
					if diedUnit.getsds then
						sds= (diedUnit.getsds + caster.cas_table.itemsdssl) * caster.cas_table.itemsdsbs
					end
					local unitKey = tostring(EntityHelper.getEntityIndex(hero))
					local netTable = hero.cas_table
					netTable["sds"] = netTable["sds"] + sds
					SetNetTableValue("UnitAttributes",unitKey,netTable)
					local gold = diedUnit:GetMinimumGoldBounty()
					local jy = diedUnit:GetDeathXP()
					if caster.cas_table.jqjc and gold > 0  then
						gold = (gold + caster.cas_table.sgzjjb)* (1+caster.cas_table.jqjc/100) 
					end
					if caster.cas_table.jyjc then
						jy = jy * (1+caster.cas_table.jyjc/100)
					end
					caster:AddExperience(jy,DOTA_ModifyXP_Unspecified,  false, false)
					SendOverheadEventMessage( nil, 0, caster, gold, nil )
					PlayerUtil.ModifyGold(caster,gold)
				else
					local sds = 1 --如果单位有杀敌数，则加上赋予的
					if diedUnit.getsds then
						sds= (diedUnit.getsds + caster.cas_table.itemsdssl) * caster.cas_table.itemsdsbs
					end
					local unitKey = tostring(EntityHelper.getEntityIndex(caster))
					local netTable = caster.cas_table
					netTable["sds"] = netTable["sds"] + sds
					SetNetTableValue("UnitAttributes",unitKey,netTable)
					local gold = diedUnit:GetMinimumGoldBounty()
					local jy = diedUnit:GetDeathXP()
					local gold2 = 0
					local jy2 = 0
					
					local ratioOwner = 0.95
					local ratioKiller = 1 - ratioOwner
					
					if caster.cas_table.jqjc and gold > 0  then
						gold2 = (gold + caster.cas_table.sgzjjb)* (1+caster.cas_table.jqjc/100) *ratioOwner
					end
					if caster.cas_table.jyjc then
						jy2 = jy * (1+caster.cas_table.jyjc/100)*ratioOwner
					end
					caster:AddExperience(jy2,DOTA_ModifyXP_Unspecified,  false, false)
					SendOverheadEventMessage( nil, 0, caster, gold2, nil )
					PlayerUtil.ModifyGold(caster,gold2)
					if hero.cas_table.jqjc and gold > 0  then
						gold2 = (gold + hero.cas_table.sgzjjb)* (1+hero.cas_table.jqjc/100) *ratioKiller
					end
					if hero.cas_table.jyjc then
						jy2 = jy * (1+hero.cas_table.jyjc/100)*ratioKiller
					end
					hero:AddExperience(jy2,DOTA_ModifyXP_Unspecified,  false, false)
					SendOverheadEventMessage( nil, 0, hero, gold2, nil )
					PlayerUtil.ModifyGold(hero,gold2)
				end
			end
		end
	end
end

function m.UpgradeEnergyCore(unit)
	local lv = unit:GetContext("zbboss")
	local playerID = unit:GetContext("player")
	local caster = PlayerUtil.GetHero(playerID)

	--如果BOSS被杀死，要被升级的物品不管在哪里，都要被销毁
	--如果后面加入宝石镶嵌系统还要再读取一下宝石数据
	if caster.wqzb then
		local wq = caster.wqzb
		UTIL_Remove(wq)
	end
	local itemname = "item_zswq_"..tostring(lv+1)
	local item = CreateItem(itemname, caster, caster)
	caster.wqzb = item
	caster:AddItem(item)
	caster.wq=1
end

function m.GoldBoss(killer,unit)
	if killer == unit  then	--如果不是玩家杀死的，而是时间到了，则就不给予金币
		return
	end
	local max = 30
	local pid = unit.zhz
	local hero = PlayerUtil.GetHero(pid)
	hero.jbboss = hero.jbboss + 1	--每次击杀都会增强
	local caster_point = hero:GetAbsOrigin()
	local point = FindReachablePoint(caster_point,100,300)
	local target =  CreateUnitByName("jbbx_1", point, false, nil, nil, DOTA_TEAM_GOODGUYS)
	target:AddNewModifier(target, nil, "modifier_kill", {duration=0.1})
	TimerUtil.createTimerWithDelay(0.5,function()
		if max > 0  then
			CreateItemOnGround("item_xhp_xjb",nil,point,300)
			max = max-1
			return 0.03
		end
	end)
end

function m.DropItem(killer,unit)
	--随机BOSS掉落物品
	local lab = unit:GetContext("sjboss")
	if lab then
		--如果是个人BOSS，则给召唤者的脚下掉落一个宝箱
		if lab ==1 then
			m.SummonedBoss_Personal(unit)
		end

		--如果是团队BOSS，则给所有的玩家的英雄单位脚下掉落一个装备宝箱
		if lab ==2 then
			m.SummonedBoss_Team(unit)
		end
	else
		local pid = killer:GetPlayerOwnerID() 
		killer = PlayerUtil.GetHero(pid)
		itemdrop(killer,unit)

		--套装BOSS掉落物品
		local lab = unit:GetContext("ywboss")
		if lab then
			m.SuitBoss(unit,lab)
		elseif unit.isAttackBoss then
			--生存boss
			m.AttackBoss(killer,unit)

		elseif unit.tyboss then
			m.tybossshenqi(unit)
		elseif unit.ymboss then
			m.ymbossshenqi(unit)
		else
			--掉落消耗品、技能书等等
			m.AttackUnits(killer,unit)
		end
	end
end

function m.SuitBoss(unit,lab)
	local dbl = unit.dbl
	local playerID = unit.zhz
	local hero = PlayerUtil.GetHero(playerID)
	local attributes = {}
	local sgzjjb = TZ.tzjjb[lab][dbl]
	attributes["sgzjjb"] = sgzjjb
	AttributesSet(hero,attributes)
	local baseStr = hero:GetBaseStrength()
	local baseAgi = hero:GetBaseAgility()
	local baseInt = hero:GetBaseIntellect()
	local add = TZ.tzjsx[lab][dbl]
	NotifyUtil.ShowSysMsg2(playerID,"tz_die",{value=sgzjjb,qsx=add})
	addStr = baseStr + add
	hero:SetBaseStrength(addStr)
	addAgi = baseAgi + add
	hero:SetBaseAgility(addAgi)
	addInt = baseInt + add
	hero:SetBaseIntellect(addInt)
	if dbl == 1 then
		local tzname = TZ.tz[lab]
		local r  = #TZ.tzname[tzname]
		local r2  = RandomInt(1,r)
		local tz = TZ.tzname[tzname][r2]
		ZbRoll(unit,tz)
	elseif dbl == 2 then
		for i=1,2 do
			local tzname = TZ.tz[lab]
			local r  = #TZ.tzname[tzname]
			local r2  = RandomInt(1,r)
			local tz = TZ.tzname[tzname][r2]
			ZbRoll(unit,tz)
		end
	elseif dbl == 3 then
		local tzname = TZ.tz[lab]
		local r  = #TZ.tzname[tzname]
		local r2  = RandomInt(1,r)
		local tz = TZ.tzname[tzname][r2]
		ZbAll(unit,tz)
		--首杀X5  BOSS，给与一件宝物
		if not hero["tz"..lab] then
			hero["tz"..lab] = true
			local item = CreateItem("item_bw_1", hero, hero)
			hero:AddItem(item)
			if lab ==3 then
				NotifyUtil.ShowSysMsg(playerID,"jstzboss_1",nil,"item_bw_1",{value=1})
			elseif	lab ==4 then
				NotifyUtil.ShowSysMsg(playerID,"jstzboss_2",nil,"item_bw_1",{value=1})
			elseif	lab ==5 then
				NotifyUtil.ShowSysMsg(playerID,"jstzboss_3",nil,"item_bw_1",{value=1})
			elseif	lab ==6 then
				NotifyUtil.ShowSysMsg(playerID,"jstzboss_4",nil,"item_bw_1",{value=1})
			end
		end

	end

	--记录玩家的BOSS点数
	if hero then
		m.UpdatePlayerBossPoint(playerID,hero,unit.bosspoint)
	end
end

function m.SummonedBoss_Personal(unit)
	local playerID = unit.zhz
	local hero = PlayerUtil.GetHero(playerID)
	--的开宝箱，后面要改掉

	NotifyUtil.ShowSysMsg(playerID,"#individualBoss_item_box")

	local target =  CreateUnitByName("zbbx_1", hero:GetAbsOrigin(), false, nil, nil, TEAM_ENEMY)
	target.dbl = unit.dbl
	target.dbpz = unit.dbpz
	target:CreatureLevelUp(unit:GetLevel())
	LetUnitDoAction(target,3,1)
	AddLuaModifier(target,target,"modifier_kill",{duration=0.1},nil)

	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
	local netTable = hero.cas_table
	netTable["sds"] = netTable["sds"] + unit.getsds 
	SetNetTableValue("UnitAttributes",unitKey,netTable)
	m.UpdatePlayerBossPoint(playerID,hero,unit.bosspoint)
end

function m.SummonedBoss_Team(unit)
	for playerID=0,3 do
		local hero = PlayerUtil.GetHero(playerID)
		if hero then
			--用小金币模拟的开宝箱，后面要改掉
			local target =  CreateUnitByName("zbbx_1", hero:GetAbsOrigin(), false, nil, nil, TEAM_ENEMY)
			target.dbl = unit.dbl
			target.dbpz = unit.dbpz
			target:CreatureLevelUp(unit:GetLevel())
			LetUnitDoAction(target,3,1)
			AddLuaModifier(target,target,"modifier_kill",{duration=0.1},nil)

			local unitKey = tostring(EntityHelper.getEntityIndex(hero))
			local netTable = hero.cas_table
			netTable["sds"] = netTable["sds"] + unit.getsds 
			SetNetTableValue("UnitAttributes",unitKey,netTable)
			NotifyUtil.ShowSysMsg2(playerID,"teamBoss_item_box",{value=unit.getsds})

			m.UpdatePlayerBossPoint(playerID,hero,unit.bosspoint)
		end
	end
end

function m.UpdatePlayerBossPoint(PlayerID,hero,bossPoint)
	if bossPoint then
		--更新随机任务
		MisSion:SetBossPoint(PlayerID,bossPoint)  --任务获取BOSS点数

		--更新总数
		hero.bosspoint = (hero.bosspoint or 0) + bossPoint
		local unitKey = tostring(EntityHelper.getEntityIndex(hero))
		local netTable = hero.cas_table
		netTable["bosspoint"] = hero.bosspoint
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end

function m.AttackBoss(killer,unit)
	if killer == nil or killer == unit then
		return;
	end
	CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_boss_die",{id=unit:entindex(),name=unit:GetUnitName(),die=1,dps=SurvivalBossDPS.BossDie(unit)})
	Stage.bossdienum = Stage.bossdienum + 1
	--记录boss的死亡时间
	for i=3,0,-1 do
		if PlayerUtil.GetHero(i) ~=nil then  --boss死亡也会给与玩家一个宝物书
			local hero = PlayerUtil.GetHero(i)
			if hero:HasModifier("modifiy_shopmall_cmzc_1") then  --如果拥有超魔专长宝物猎人，则额外给予一个宝物书
				local item = CreateItem("item_bw_1", hero, hero)
				hero:AddItem(item)
			end
			local item = CreateItem("item_bw_1", hero, hero)
			hero:AddItem(item)
			NotifyUtil.ShowSysMsg(i,"#boss_death",nil,"item_bw_1")
			--每个BOSS有30%的概率掉落存档装备，每次不爆+10 的爆率
				local xyz = hero.cas_table.xyz
				if xyz>100 then
					xyz =100
				end
				if RollPercent(xyz) then
					NetItemDrop(hero)
					--NotifyUtil.ShowSysMsg(i,"#net_item")  -- 现在是游戏结算统一给，就不用发消息了				
				end
			
		end
	end
end

function m.tybossshenqi(unit)
	local playerID = unit.zhz
	local hero = PlayerUtil.GetHero(playerID)
	itemgivesq(hero)
end

function m.ymbossshenqi(unit)
	local playerID = unit.zhz
	local hero = PlayerUtil.GetHero(playerID)
	local sds = unit.ymcs * 1000
	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
	local netTable = hero.cas_table
	netTable["sds"] = netTable["sds"] + sds
	SetNetTableValue("UnitAttributes",unitKey,netTable)
	NotifyUtil.ShowSysMsg2(playerID,"ym_die",{value=unit.ymcs,sds=sds})
end

function m.AttackUnits(killer,unit)
	for key, ygmz in pairs(Ygmz.attackUnits) do
		if unit:GetUnitName() == ygmz then
			--野怪掉落物品，主要是消耗品掉落
			m.ygdlwp(killer,unit)
			
			local pid = killer:GetPlayerOwnerID()
			--技能书点数
			local jnsds = PlayerUtil.getAttrByPlayer(pid,"jnsds")
			if jnsds and jnsds >= 1 then
				local x = RandomInt(1,30)	 --30分之一的概率掉落技能书
				if x == 30 or killer.firstjns == nil then  --如果是第一次掉技能书就秒掉
					killer.firstjns = true
					jnsds = jnsds - 1
					PlayerUtil.setAttrByPlayer(pid,"jnsds",jnsds)
					--野怪掉落技能书
					m.ygdljns(killer,unit)
				end
			end
			break;
		end
	end
end

function m.SummonedUnit(unit)
	if unit:GetUnitName() == "diyuh" then
		local pid = unit:GetPlayerOwnerID()
		local caster = PlayerUtil.GetHero(pid)
		local units = caster.dyhunits;
		if units then
			for i=1,#units do
				if units[i] ==unit then
					table.remove(units,i)
					return nil
				end
			end
		end
	end
end


function m.ygdlwp(hero,unit)
	local x = RandomInt(1,100)
	--  local xyz = wjxyz  获取玩家的幸运值加成
	--	x = x + xyz
	if x>=95 then --百分之五的概率掉落物品	--暂改
		local y = RandomInt(1,10)
		if y>=1 and y<=3 then  --百分之五十的概率掉落能量晶石
			CreateItemOnGround("item_xhp_nljs",unit,unit:GetAbsOrigin(),150)
		end
		if y>=4 and y<=8 then --百分之五十的概率掉落小金币

			--用小金币模拟的开宝箱，后面要改掉
			CreateItemOnGround("item_xhp_xjb",unit,unit:GetAbsOrigin(),150)
		end
		if y>=9 and y<=10 then  --先调高物品爆率，设置BOSS掉落 到时候通过权重一起设置
			local r = RandomInt(1,10)
			if r == 8 then
				CreateItemOnGround("item_xhp_mys_4",unit,unit:GetAbsOrigin())
			else
				CreateItemOnGround("item_xhp_mys_3",unit,unit:GetAbsOrigin())
			end

		end
	end
end

function m.ygdljns(hero,unit)	--技能掉落
	local x = RandomInt(1,3)
	if x ~= 4   then	 --三分之一的机会获得通用技能，三分之二的概率获得主属性技能  --暂时不掉落通用技能
		if EntityHelper.IsStrengthHero(hero) then
			local zz = #Itemjndl.lljn1
			local z = RandomInt(1,zz)
			local y2 = Itemjndl.lljn1[z]

			CreateItemOnGround(y2,unit,unit:GetAbsOrigin())
	else
		if EntityHelper.IsAgilityHero(hero)then
			local zz = #Itemjndl.mjjn1
			local z = RandomInt(1,zz)
			local y2 = Itemjndl.mjjn1[z]

			CreateItemOnGround(y2,unit,unit:GetAbsOrigin())
		else
			local zz = #Itemjndl.zljn1
			local z = RandomInt(1,zz)
			local y2 = Itemjndl.zljn1[z]

			CreateItemOnGround(y2,unit,unit:GetAbsOrigin())
		end
	end
	else
		local zz = #Itemjndl.tyjn1
		local z = RandomInt(1,zz)
		local y2 = Itemjndl.tyjn1[z]

		CreateItemOnGround(y2,unit,unit:GetAbsOrigin())
	end

end

--英雄重生
--@param #table diedHero 死亡的英雄
function m.RespawnHero(diedHero)
	if diedHero:HasModifier("modifier_bw_all_48") then  --如果拥有死亡回溯  有30%的概率满血复活
		if RollPercent(30) then
			TimerUtil.createTimerWithDelay(0.1,function()
				if diedHero:IsAlive() then
					return
				end
				local point = diedHero:GetAbsOrigin()
				diedHero:RespawnHero(false, false) --复活
				Teleport(diedHero,point)
				local ability = diedHero:FindAbilityByName("ability_hero_2")
				if ability then
					ability:ApplyDataDrivenModifier(diedHero, diedHero, "modifier_ability_hero_2_2", {duration =1})
				end
				return nil
			end)
		end	
	end
	if diedHero:IsAlive() then
		return
	end

	local pid = diedHero:GetPlayerOwnerID()
	local pointname=m.fhd[pid+1]
	local point= Entities:FindByName(nil,pointname):GetAbsOrigin()
	local timeToRespwan = diedHero.cas_table["swfhsj"] --复活时间
	if timeToRespwan < 1 then
		timeToRespwan = 1
	end
	--复活时间计时器
	TimerUtil.createTimer(function ()
			if diedHero:IsAlive() then
				return nil 
			end
			--计时结束英雄还没有复活，就复活英雄。 有些时候timeToRespwan会变成nil，这里一样认为可以复活
			if (timeToRespwan == nil  or timeToRespwan <= 0) and not diedHero:IsAlive() then
				m.doRespawn(diedHero,point);
				return ;
			end
			diedHero:SetTimeUntilRespawn(timeToRespwan)
			timeToRespwan = timeToRespwan - 1
			return 1;  --函数1秒执行一次
	end)
end

---复活英雄，血量为60%，蓝量为50%
--@param #table diedHero 复活后的英雄
--@param #Vector point 复活地点
function m.doRespawn(diedHero,point)
	if Stage.playernum >= 2 then
		Stage.herodie = Stage.herodie + 1
	end
	diedHero:RespawnHero(false, false) --复活
	diedHero:SetHealth(diedHero:GetMaxHealth() * 1)
	diedHero:SetMana(diedHero:GetMaxMana() * 1)
	Teleport(diedHero,point)

	local ability = diedHero:FindAbilityByName("ability_hero_2")
	if ability then
		ability:ApplyDataDrivenModifier(diedHero, diedHero, "modifier_ability_hero_2_2", {duration =3})
	end
end


return m















		
