

function hytx( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)

	local mj = caster:GetAgility()
	
	if caster.hytx_baseDamage == nil then
		caster.hytx_baseDamage = 0
	end
	if caster.hytx_damage == nil then
		caster.hytx_damage = 0
	end
	i = i + caster.hytx_damage
	local baseDamage2 = baseDamage + caster.hytx_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * shbs
	ApplyDamageEx(caster,target,ability,damage)

end


