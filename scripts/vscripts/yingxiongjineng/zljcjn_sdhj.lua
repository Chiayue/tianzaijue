function sdhj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local duration = keys.ability:GetLevelSpecialValueFor("duration", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	
	if caster.sdhj_duration == nil then
		caster.sdhj_duration = 0
	end
	if caster.sdhj_max == nil then
		caster.sdhj_max = 0
	end
	if caster.sdhj_multiple == nil then
		caster.sdhj_multiple = 0
	end
	duration = duration + caster.sdhj_duration
	ability:ApplyDataDrivenModifier(target,target,"modifier_frost_armor",{duration =duration})
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.sdhj_multiple + multiple
	end	 
	local cs = math.floor((5 + level +caster.sdhj_max)*multiple)	
	target:SetModifierStackCount("modifier_frost_armor", target, cs)
	
end


function sdhjsh( keys )
	local caster = keys.caster
	local target = keys.attacker
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	ability:ApplyDataDrivenModifier(target,target,"modifier_frost_armor_slow",{duration =2})
	if caster.sdhj_baseDamage == nil then
		caster.sdhj_baseDamage = 0
	end
	if caster.sdhj_damage == nil then
		caster.sdhj_damage = 0
	end
	if caster.sdhj_multiple == nil then
		caster.sdhj_multiple = 0
	end
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.sdhj_baseDamage
	i = i +caster.sdhj_damage
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.sdhj_multiple +multiple
	end	
	local damage = (zl * i + baseDamage2 ) * x * multiple

	ApplyDamageMf(caster,target,ability,damage)
end