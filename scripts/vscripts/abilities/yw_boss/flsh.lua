function flsh(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local reduce = keys.ability:GetLevelSpecialValueFor("reduce", keys.ability:GetLevel() - 1)	
	local bs = keys.ability:GetLevelSpecialValueFor("bs", keys.ability:GetLevel() - 1)	

	local mana = target:GetMana()
	if mana < reduce then
		reduce = mana
	end
	target:ReduceMana(reduce)
	local damage = reduce * bs
	ApplyDamageEx(caster,target,ability,damage)
	
end