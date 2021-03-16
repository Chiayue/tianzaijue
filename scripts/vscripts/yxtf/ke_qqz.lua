function qqz( keys )

	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ii = keys.ability:GetLevelSpecialValueFor("ii", keys.ability:GetLevel() - 1)
	local level = ability:GetLevel() - 1

	local sm = caster:GetMaxHealth()
	local mf =caster:GetMaxMana()
	local heal =sm *ii/100
	local mana = mf*ii/100
	caster:Heal(heal, caster)
	caster:GiveMana(mana)
end
