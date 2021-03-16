
-- 召唤BOSS
function CallBoss(keys)
	if Stage.gameFinished then
		return
	end

	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local x =  ability:GetLevelSpecialValueFor("x", level)	--获取召唤符的掉宝品质
	local pz =  ability:GetLevelSpecialValueFor("pz", level)	--获取召唤符的品质
	local level2 =  ability:GetLevelSpecialValueFor("level", level)	--获取英雄的等级
	local bosspoint =  ability:GetLevelSpecialValueFor("bosspoint", level)	--获取英雄的等级
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(playerID)
	local level3 = hero:GetLevel()

	if level3 < level2 then
		NotifyUtil.ShowError(playerID,"#level_not")
		return nil
	end


	local charges = ability:GetCurrentCharges()
	--ability:StartCooldown(cooldown)
		if charges > 1 then
			ability:SetCurrentCharges(charges - 1)
		else
		--	if ability then
			UTIL_RemoveImmediate(ability)
		--	end
		end

	CallTzBoss(caster,pz,x,bosspoint,playerID)
end
-- 召唤BOSS
function CallTyBoss(keys)
	if Stage.gameFinished then
		return
	end

	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local level2 =  ability:GetLevelSpecialValueFor("level", level)	--获取英雄的等级
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(playerID)
	local level3 = hero:GetLevel()
	if not caster.tybosstime or caster.tybosstime >10 then
		NotifyUtil.ShowError(playerID,"ym_cc")
		return nil
	end
	if level3 < level2 then
		ability:EndCooldown()
		NotifyUtil.ShowError(playerID,"#level_not")
		return nil
	end
	local charges = ability:GetCurrentCharges()
	if charges > 1 then
		ability:SetCurrentCharges(charges - 1)
	else
	--	if ability then
		UTIL_RemoveImmediate(ability)
	--	end
	end

	CallTyBoss2(caster,playerID)
end

-- 召唤个人或者团队BOSS
function CallSjBoss(keys)
	if Stage.gameFinished then
		return
	end

	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local x =  ability:GetLevelSpecialValueFor("x", level)	--获取BOSS的等阶
	local pz =  ability:GetLevelSpecialValueFor("pz", level)	--获取是个人还是团队BOSS 1是个人 2是团队
	local level2 =  ability:GetLevelSpecialValueFor("level", level)	--获取英雄的等级
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(playerID)
	local level3 = hero:GetLevel()



	if level3 < level2 then
		NotifyUtil.ShowError(playerID,"#level_not")
		return nil
	end


	local charges = ability:GetCurrentCharges()
	
		if charges > 1 then
			ability:SetCurrentCharges(charges - 1)
		else
		--	if ability then
			UTIL_RemoveImmediate(ability)
		--	end
		end
	--local p1 = ParticleManager:CreateParticle("particles/econ/items/tinker/boots_of_travel/teleport_end_bots.vpcf", PATTACH_ABSORIGIN, caster)
	--ParticleManager:SetParticleControl(p1, 0, p) -- Origin
	--ParticleManager:SetParticleControl(p1, 1, p) -- Origin

	local spawner=Entities:FindByName(nil,"fyd1")
	if pz == 1 then
		spawner=Entities:FindByName(nil,shuaguai.sgd[playerID+1])
	end
	local p = spawner:GetAbsOrigin()
	p.z=p.z-200
	
	 local vDirection =  (p+RandomVector(800)+Vector(0,0,1000))-p 
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()
	EmitSoundOnLocationWithCaster( spawner:GetAbsOrigin(), "Hero_Invoker.ChaosMeteor.Cast", nil )
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, p+vDirection*50+Vector(0,0,1200) )
	 ParticleManager:SetParticleControl( nFXIndex, 1, p+Vector(0,0,-100) )
	 ParticleManager:ReleaseParticleIndex(nFXIndex)
	

	TimerUtil.createTimerWithDelay(1.1,function()
		--	UTIL_Remove(dummy)
		--	ParticleManager:DestroyParticle(p1,false)
		EmitSoundOnLocationWithCaster( spawner:GetAbsOrigin(), "Hero_Invoker.ChaosMeteor.Impact", hero )
		local particleID2 = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf",PATTACH_WORLDORIGIN,nil)--
		ParticleManager:SetParticleControl(particleID2,0,p)
		 
			if pz==1 then
				CallGrBoss(caster,x,playerID)
			end

			if pz==2 then
				CallTeamBoss(caster,x,playerID)
			end
		end
	)	
	
	
end




-- 召唤金币BOSS
function CalljbBoss(keys)
	if Stage.gameFinished then
		return
	end

	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	
	local difficulty =   GetGameDifficulty()
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(playerID)
	local level3 = hero:GetLevel()

	local wave =Stage.wave

	if wave ==0 or wave ~=nil then
		wave=1
	end


	local id = caster:GetPlayerOwnerID() +1
	local spawner=Entities:FindByName(nil,shuaguai.sgd[id])
	local p = spawner:GetAbsOrigin()
	
	local cs = hero.jbboss 
	
	local unit = CreateUnitByName("BOSS_jb", p, false, nil, nil, TEAM_ENEMY)
		--设置套装BOSS的品质
		
		--设置套装BOSS的掉落权  
		--暂时不设置
		--unit:SetContextNum("ywboss",pz,0)

	local maxhp = 2000  *cs*cs * ma.nd_hp[difficulty]--怪物10倍血量
	if maxhp > 500000000 then   --如果boss血量超过5亿，就给加减伤
		unit.shjs = string.format("%.2f",maxhp / 500000000)
		maxhp = 500000000
	end
	
	unit:SetBaseMaxHealth(maxhp)

	local maxarmor = 5 *cs * cs * ma.nd_hj[difficulty]
	unit:SetPhysicalArmorBaseValue(maxarmor)
	local mk = maxarmor*0.06/(1+maxarmor*0.06)*100    	--设置怪物的魔抗
	unit:SetBaseMagicalResistanceValue(mk)
	
	local maxattack =100  *cs * cs * ma.nd_gj[difficulty]--所有怪攻击太高，先削弱测试
	unit:SetBaseDamageMin(maxattack)
	unit:SetBaseDamageMax(maxattack)

	local maxgold =  ma.gold[wave] *30 --先设置5倍金钱
	unit:SetMinimumGoldBounty(maxgold)
	unit:SetMaximumGoldBounty(maxgold)

	--标记为玩家几的存活怪
	unit.playchs = id;
	--一个怪代表一个存活，boss另算
	unit.playchsl = 1;
	--对应的玩家怪物数量+1
	Stage.chs["chs"..id] = Stage.chs["chs"..id] + unit.playchsl
	--同步往服务器发怪物目前的数量
	local  nowchs = #Stage.kezhw
	for _, PlayerID in pairs(Stage.playeronline) do
		nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
	end
	table.insert(Stage["player"..id-1],unit:GetEntityIndex())
	unit:AddNewModifier(unit, ability, "modifier_kill", { duration = 30 })
	--BOSS的掉落率
	unit.zhz = playerID--召唤者的ID
	--当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
	unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	
	
end




function cswp(keys)
	if Stage.gameFinished then
		return
	end

	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(playerID)
	local level = ability:GetLevel() - 1
	local radius =  ability:GetLevelSpecialValueFor("radius", level)	
	local point = hero:GetAbsOrigin()
	--hero:EmitSound("General.Sell")
	EmitSoundOn( "General.Sell", hero )
	EmitSoundOn( "ui.inv_drop_chest", hero )
	--EmitSoundOn( "Item.DropGemWorld", hero )
	--指定地点所有的物品
  local ItemTable = Entities:FindAllByClassnameWithin("dota_item_drop",point,radius)
  if ItemTable == nil or #ItemTable == 0 or hero == nil  then return end
	local totalMoney = 0;
  --累计金额,删除物品
  local sds = 0
  local pz = 0
  local lv = 0
  local sdsnum = 0
  for i,drop in pairs(ItemTable) do
  	
    local item = drop:GetContainedItem()
    local itemName = item:GetAbilityName()
  	if item:GetCost() <=50  then
  		if itemName ~= "item_xhp_zbbx_1" then
	  		local idx = string.find(itemName,"item_xhp_");
	  		if idx == 1 then
				drop:RemoveSelf()
				TimerUtil.CreateTimerWithEntity(hero,function()
					if itemName == "item_xhp_xjb" then					
						local gold = RandomInt(90,180)				
						local jqjc = hero.cas_table.jqjc + 100
						local wave= Stage.wave	
						local gold = math.ceil(gold * jqjc / 100 * (wave*0.2 + 1))
						PopupNum:PopupGoldGain(hero,gold)
						PlayerUtil.ModifyGold(hero,gold)
					elseif itemName == "item_xhp_nljs" then
						local x = RandomInt(1,3)
						local wave = Stage.wave
						local z = RandomInt(1,5) * (0.5+wave/2)
						local nljszjbfb = hero.nljszjbfb
						z = z * nljszjbfb
						if x ==1 then
							NotifyUtil.ShowSysMsg(playerID,"add_ll",nil,"item_xhp_nljs",{value=z})
							local y = hero:GetBaseStrength()
							z = z + y
							hero:SetBaseStrength(z)

						elseif x ==2 then
							NotifyUtil.ShowSysMsg(playerID,"add_mj",nil,"item_xhp_nljs",{value=z})
							local y = hero:GetBaseAgility()
							z = z + y
							hero:SetBaseAgility(z)
						elseif x ==3 then
							NotifyUtil.ShowSysMsg(playerID,"add_zl",nil,"item_xhp_nljs",{value=z})
							local y = hero:GetBaseIntellect()
							z = z + y
							hero:SetBaseIntellect(z)
						end
						hero:CalculateStatBonus(true)
					end
				end,0.1 * i,true)
	  		end
	  	end
  		--物品价格小于50的都不可分解
  		--专属武器和防具不可分解  
  	else
  		if string.sub(item:GetName(),1,12) == "item_xhp_mys"  then
  			hero:AddItem(item)
  			drop:RemoveSelf()
  		else
		  	if item.pz then
		    	pz = zbds[item.pz]
		    end
		    if item.lv then
		    	lv =  zbxs[item.lv]
		    end
		    sds = pz*lv
		    sdsnum = sdsnum+ sds
		    if sds ==0 then
		    	sds = 1
		    end
		    totalMoney = totalMoney + (item:GetCost()*sds * 0.5)
		    drop:RemoveSelf() --移除掉掉落物品
		    item:RemoveSelf() --移除掉掉落物中包含的物品，只删除上面的物品的话，item仍然存在，这样，如果玩家已经持有过25个物品，并卖掉了这些物品，将无法再次进行购买
		    sds=0
	    end
  	end

    
  end

  	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
 	local netTable = hero.cas_table
  	netTable["sds"] =netTable["sds"]  + sdsnum
  	SetNetTableValue("UnitAttributes",unitKey,netTable)	
	PlagueLand:ModifyCustomGold(playerID, totalMoney)
	PopupNum:PopupGoldGain(caster,totalMoney)
	NotifyUtil.ShowSysMsg2(playerID,"add_money",{value=totalMoney})
	if sdsnum > 0 then
		NotifyUtil.ShowSysMsg2(playerID,"add_sds",{value=sdsnum})
	end
end





 --tzj_bc_summon {name="team_1",PlayerID=0,group="suit/personal/team"}
