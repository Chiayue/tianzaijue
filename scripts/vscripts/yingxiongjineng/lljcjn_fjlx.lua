function fjlx( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local ll = caster:GetStrength()
	if caster.fjlx_baseDamage == nil then
		caster.fjlx_baseDamage = 0
	end
	if caster.fjlx_damage == nil then
		caster.fjlx_damage = 0
	end
	if caster.fjlx_multiple == nil then
		caster.fjlx_multiple = 0
	end
	local baseDamage2 = baseDamage + caster.fjlx_baseDamage
	local damage = (ll * (i+caster.fjlx_damage) + baseDamage2 ) * x *shbs
	if caster:HasModifier("modifier_yxtfjn_fjfb") then
		damage = damage * 1.5
	end
	if RollPercentage(20) then
			damage = damage * (caster.fjlx_multiple + 1 )
	end	
	if damage > 1000000000 then
		damage = 1000000000
	end
	ApplyDamageEx(caster,target,ability,damage)

end


