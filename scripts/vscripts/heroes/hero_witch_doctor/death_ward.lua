--[[Author: YOLOSPAGHETTI
	Date: March 15, 2016
	Creates the death ward]]
function CreateWard(keys)
	local caster = keys.caster
	local ability = keys.ability
	local position = ability:GetCursorPosition()	
	local level = ability:GetLevel() - 1
	local duration = keys.ability:GetLevelSpecialValueFor("duration", level)
	local i = keys.ability:GetLevelSpecialValueFor("i", level)		
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	if caster.swsw_max == nil then
		caster.swsw_max = 0
	end
	-- Creates the death ward (There is no way to control the default ward, so this is a custom one)
	local num = math.ceil((1+caster.swsw_max) * caster.cas_table.zhwslbs)
	local ewsh = 1
	if num > 3 then
		ewsh = 1+(num-3)*0.3
		num =3
	end
	for i2=1,num do
		local unit = CreateUnitByName("witch_doctor_death_ward_datadriven", FindRandomPoint(position,150), true, caster, nil, caster:GetTeam())
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
		if caster.swsw_baseDamage == nil then
			caster.swsw_baseDamage = 0
		end
		if caster.swsw_damage == nil then
			caster.swsw_damage = 0
		end
		if caster.swsw_duration == nil then
			caster.swsw_duration = 0
		end
		duration = duration + caster.swsw_duration
		local baseDamage2 = baseDamage + caster.swsw_baseDamage
		local damage = (sx * i + baseDamage2 ) * x  * ((caster.cas_table["zhwsh"]+100)/100) * 2 * ewsh
		if damage > 500000000 then
			damage = 500000000
		end
		local damage2= damage
		if caster.swsw_multiple == nil then
			caster.swsw_multiple = 0
		end

		if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
				damage2 = damage * (caster.swsw_multiple + 1 )
		end	

		mj = math.ceil(mj/50)+((x-1)*100)--暂时每50点敏捷提升一点攻击速度,每提升一级增加十点攻击速度

		unit:SetBaseDamageMax(damage2)
		unit:SetBaseDamageMin(damage2)
		-- Applies the modifier (gives it damage, removes health bar, and makes it invulnerable)
		ability:ApplyDataDrivenModifier( caster, unit, "modifier_death_ward_datadriven", {} )
		unit:AddNewModifier(unit, ability, "modifier_kill", { duration = duration })
		ability:ApplyDataDrivenModifier( caster, unit, "modifier_zljcjn_swsw1", {} )
		unit:SetModifierStackCount("modifier_zljcjn_swsw1", ability, mj)
	end
	
end



