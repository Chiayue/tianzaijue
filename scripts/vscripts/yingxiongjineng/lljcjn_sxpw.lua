function sxpw( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local ll = caster:GetStrength()

	if caster.sxpw_baseDamage == nil then
		caster.sxpw_baseDamage = 0
	end
	if caster.sxpw_damage == nil then
		caster.sxpw_damage = 0
	end
	local baseDamage2 = baseDamage + caster.sxpw_baseDamage
	local damage = (ll * (i+caster.sxpw_damage) + baseDamage2 ) * x
	if damage > 500000000 then
		damage = 500000000
	end
	if caster.sxpw_multiple == nil then
		caster.sxpw_multiple = 0
	end
	if RollPercentage(20) then
			damage = damage * (caster.sxpw_multiple + 1 )
	end	
		
		ApplyDamageEx(caster,target,ability,damage)
		ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
		


end


