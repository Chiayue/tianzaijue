--各种过滤器
local m = {};



---注册过滤器
--@param #table context 过滤器使用的上下文
function m.register(context)
	local gameMode = GameRules:GetGameModeEntity();
	gameMode:SetDamageFilter( Dynamic_Wrap(m, "FilterDamage" ), context )
--	gameMode:SetModifyExperienceFilter( Dynamic_Wrap(m, "FilterExp" ), context )
--	gameMode:SetModifyGoldFilter( Dynamic_Wrap(m, "FilterGold" ), context )
	gameMode:SetExecuteOrderFilter( Dynamic_Wrap(m, "OrderFilter" ), context )
	
	--下面这个filter是在有物品通过dota的方式（非自定义属性）修改了单位属性的时候会触发。比如装备了武器，加了100攻击，就会触发事件
--	gameMode:SetAbilityTuningValueFilter( Dynamic_Wrap(m, "AbilityTuningValueFilter" ), context )
end

---伤害过滤器
--伤害类型常量
--DAMAGE_TYPE_NONE 0
--DAMAGE_TYPE_PHYSICAL   1
--DAMAGE_TYPE_MAGICAL    2
--DAMAGE_TYPE_PURE       4
--DAMAGE_TYPE_ALL        7
function m:FilterDamage(filterTable)
	local attacker_index = filterTable["entindex_attacker_const"]
	if not attacker_index then
		return true
	end
	local attacker = EntityHelper.findEntityByIndex(attacker_index)
	local victim = EntIndexToHScript(filterTable.entindex_victim_const)
	local damage = filterTable["damage"];
	local damagetype = filterTable["damagetype_const"]

	if attacker.shzj then --怪物的攻击力减少附带的额外伤害
		damage = damage * attacker.shzj
	end

	if attacker and attacker:IsRealHero() then
		if attacker.cas_table.fjsh >0 then --附加伤害，不分伤害类型  攻击者
			damage=damage*(1+attacker.cas_table.fjsh/100)
		end	
		if attacker.cas_table.zzsh >0 then --最终伤害，不分伤害类型  攻击者
			damage=damage*(1+attacker.cas_table.zzsh/100)
		end
		if attacker.cas_table.xlbs >1 then --仙力倍数
			damage=damage*attacker.cas_table.xlbs
		end
		if attacker.cas_table.mlbs >1 then --魔力倍数
			damage=damage*attacker.cas_table.mlbs
		end
		if attacker.cas_table.slbs >1 then --神力倍数
			damage=damage*attacker.cas_table.slbs
		end

		if damagetype == 2 or damagetype == 4 then
			if attacker.cas_table.mfct >0 then --魔法穿透  
				damage=damage*(1+attacker.cas_table.mfct/33)  --公式算不来，算了算了
			end	
			if attacker.cas_table.mfshts >0 then --魔法伤害提升
				damage=damage*(1+attacker.cas_table.mfshts/100)
			end	
			if attacker.cas_table.mfbjgl >0 then --魔法暴击伤害，
				if RollPercent(attacker.cas_table.mfbjgl) then
					damage=damage*(1+attacker.cas_table.mfbjsh/100)
					PopupNum:PopupCriticalDamage(victim, damage)  --最后计算暴击伤害，用来显示暴击伤害
				end
			end	
			if attacker.cas_table.fsxx >0 or attacker.cas_table.qjxx >0  then
				m:lifeSteal(attacker,damage,true);
			end	
		elseif damagetype == 1 then  --物理攻击吸血
			if attacker.cas_table.wlct > 0 then --护甲穿透
				local wlct = attacker.cas_table.wlct
				local hj = victim:GetPhysicalArmorValue(false) 
				if wlct > 80 then
					wlct = 80
				end
				if wlct > 0 and hj > 0 then
					local hj2 = hj * (1-wlct/100)
					local zqjs = 1- hj*0.06 / (1+ hj*0.06) 
					local zhjs = 1- hj2*0.06 / (1+ hj2*0.06) 
					damage = damage /zqjs * zhjs
				end
			end	
			if attacker.cas_table.wlshts >0 then --物理伤害提升
				damage=damage*(1+attacker.cas_table.wlshts/100)
			end	
			if attacker.cas_table.wlbjgl >0 then --物理暴击伤害
				if RollPercent(attacker.cas_table.wlbjgl) then
					damage=damage*(1+attacker.cas_table.wlbjsh/100)
					PopupNum:PopupCriticalDamage(victim, damage)  --最后计算暴击伤害，用来显示暴击伤害
				end
			end	
			if attacker.cas_table.wlxx >0 or attacker.cas_table.qjxx >0  then
				m:lifeSteal(attacker,damage,false);
			end
		end






		if attacker.targetzzsh then
			if victim==EntIndexToHScript(attacker.targetzzsh.target) then
				damage=damage*(1+attacker.targetzzsh.damage/100)
			end
		end
		if attacker.range300zzsh and ( victim:GetOrigin() - attacker:GetOrigin() ):Length2D()<300 then
			
			damage=damage*(1+attacker.range300zzsh/100)
			
		end
		if attacker.range900zzsh and ( victim:GetOrigin() - attacker:GetOrigin() ):Length2D()<900 then
			
			damage=damage*(1+attacker.range900zzsh/100)
			
		end
		if attacker.range900zzsh and ( victim:GetOrigin() - attacker:GetOrigin() ):Length2D()<900 then
			
			damage=damage*(1+attacker.range900zzsh/100)
			
		end
		if attacker:HasModifier("modifier_bw_all_28") and not victim:HasModifier("modifier_bw_all_28_debuff") then
			damage=damage*2
			LinkLuaModifier( "modifier_bw_all_28_debuff", "lua_modifiers/baowu/modifier_bw_all_28_debuff", LUA_MODIFIER_MOTION_NONE )
			victim:AddNewModifier( attacker, nil, "modifier_bw_all_28_debuff", {} )
		end
		if attacker.healthpercent70zzsh and  victim:GetHealthPercent()>70 then
			
			damage=damage*(1+attacker.healthpercent70zzsh.damage/100)
			
		end
		if attacker.healthpercent25zzsh and  victim:GetHealthPercent()<25 then
			damage=damage*(1+attacker.healthpercent25zzsh.damage/100)
		end
	end
	if victim and victim:IsRealHero() then -- 被攻击者,承受伤害
		if victim.cas_table.shjm then --伤害减免 ，不分伤害类型,之前的伤害减免计算方式不对
			damage=damage/(1+victim.cas_table.shjm/100)
		end
		if victim.cas_table.shhm then --伤害豁免，没伤害，不分伤害类型，被攻击者
			local shhm = victim.cas_table.shhm
			if shhm > 80 then
				shhm = 80
			end
			if RollPercentage(shhm) then
				damage=0
			end
		end
	end
	
	--按照减伤前的伤害，统计生存boss的伤害
	if victim.isAttackBoss then
		SurvivalBossDPS.DamageStatistic(attacker,victim,damage)
	end
	
	if victim.shjs then
		damage = damage / victim.shjs
	end
	--使用修改后的伤害值
	filterTable["damage"] = damage
	
	
	return true
end

---造成伤害的时候吸血。
function m:lifeSteal(hero,damage,isMagic)

	local ratio = 0;
	if isMagic then
		ratio = hero.cas_table.fsxx  + hero.cas_table.qjxx
	else
		ratio = hero.cas_table.wlxx + hero.cas_table.qjxx
	end
	local healAmout = damage * ratio / 1000
	if healAmout > 0 then
		if healAmout > 100000000 then
			healAmout = 100000000
		end
		hero:Heal(healAmout,hero);
		local id = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,hero);
		TimerUtil.createTimerWithDelay(1,function()
			ParticleManager:DestroyParticle(id,false)
		end)
	end
end


--经验过滤器。获得经验的时候，如果玩家有宠物，并且宠物提供了经验加成。则增加经验
function m:FilterExp(filterTable)
--	local playerID = filterTable["player_id_const"]
--	local hero = PlayerUtil.GetHero(playerID)
--	if not hero then
--		return 0
--	end

--	if hero.cas_table.jyjc then
--		filterTable.experience = filterTable.experience * (1+hero.cas_table.jyjc/100)
	--end
	return 0
end

---金币过滤器。获得金币的时候，如果玩家有金币加成buff，则提高金币
--目前好像只有杀怪获得金币可以进这个过滤器
function m:FilterGold(filterTable)
	--local playerID = filterTable["player_id_const"]
	--local hero = PlayerUtil.GetHero(playerID)
	--print_r(filterTable)
--	if not hero then
	--	return 0
	--end
	--if hero.cas_table.jqjc and filterTable.gold > 0  then
	--	filterTable.gold = (filterTable.gold + hero.cas_table.sgzjjb)* (1+hero.cas_table.jqjc/100) 
--	end
	return 0
end


---命令过滤器
function m:OrderFilter(data)
	if data.units and data.units["0"] then
		local unit = EntityHelper.findEntityByIndex(data.units["0"])
		if unit then
			--执行命令之后要终止扔物品的thinker，否则即使中途被打断也会一直think下去
			if unit.m_Backpack_DropItemToPosition_OrderType then
				unit.m_Backpack_DropItemToPosition_OrderType = nil
			elseif unit.m_inventory_DropItemToPosition_OrderType then
				unit.m_inventory_DropItemToPosition_OrderType = nil
			end
		end
	end
	
	return true;
end


return m