function zlqq( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local ll = caster:GetBaseIntellect() + i
	local damage = ll 
	ApplyDamageEx(caster,target,ability,damage,DAMAGE_TYPE_PURE)
	caster:SetBaseIntellect(ll)

end


