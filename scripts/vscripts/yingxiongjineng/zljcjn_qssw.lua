--[[Author: YOLOSPAGHETTI
	Date: March 15, 2016
	Creates the death ward]]
function CreateQssw(keys)
	local caster = keys.caster
	local ability = keys.ability
	local position = ability:GetCursorPosition()	
	local level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", level)
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local max = ability:GetLevelSpecialValueFor("max", level)			
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	if caster.qssw_max == nil then
		caster.qssw_max = 0
	end
	max =max + caster.qssw_max
	max = math.ceil(max * caster.cas_table.zhwslbs)
	local ewsh = 1
	if max > 4 then
		ewsh = 1+(max-4)*0.25
		max = 4
	end
	for i2=1,max do
		local unit = CreateUnitByName("qunshesw", position, true, caster, nil, caster:GetTeam())
		unit:SetControllableByPlayer(caster:GetPlayerID(), true)
		unit:SetOwner(caster)

		--local gjsd = caster:GetAttackSpeed()
		--gjsd = string.format("%.2f",gjsd) - 1 根据英雄的攻击来设置守卫的攻击速度，但是，还是根据敏捷来算吧
		local mj = caster:GetAgility()

		local sx = 0
		if EntityHelper.IsStrengthHero(caster) then
			 sx = caster:GetStrength()
		else
		if EntityHelper.IsAgilityHero(caster)then
			 sx = caster:GetAgility()
		else
			 sx = caster:GetIntellect()
		end
		end
		if caster.qssw_baseDamage == nil then
			caster.qssw_baseDamage = 0
		end
		if caster.qssw_damage == nil then
			caster.qssw_damage = 0
		end
		if caster.qssw_duration == nil then
			caster.qssw_duration = 0
		end
		duration = duration + caster.qssw_duration
		local baseDamage2 = baseDamage + caster.qssw_baseDamage
		local damage = (sx * i + baseDamage2 ) * x  * ((caster.cas_table["zhwsh"]+100)/100) *ewsh
		local damage2= damage
		if caster.qssw_multiple == nil then
			caster.qssw_multiple = 0
		end
		local hp = caster:GetBaseMaxHealth()*0.4 * ewsh
		local hj = caster:GetPhysicalArmorValue(false)*x/2
		if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
				damage2 = damage * (caster.qssw_multiple + 1 )
				hj = hj *  (caster.qssw_multiple + 1 )
		end	

		mj = math.ceil(mj/50)+((x-1)*100)--暂时每50点敏捷提升一点攻击速度,每提升一级增加十点攻击速度
		unit:SetPhysicalArmorBaseValue(hj)
		unit:SetBaseMaxHealth(hp)
		unit:SetBaseDamageMax(damage2)
		unit:SetBaseDamageMin(damage2)
		-- Applies the modifier (gives it damage, removes health bar, and makes it invulnerable)
		ability:ApplyDataDrivenModifier( caster, unit, "modifier_zljcjn_qssw_1", {} )
		unit:AddNewModifier(unit, ability, "modifier_kill", { duration = duration })
		ability:ApplyDataDrivenModifier( caster, unit, "modifier_zljcjn_qssw1", {} )
		unit:SetModifierStackCount("modifier_zljcjn_qssw1", ability, mj)

	end
	
end

