function sxkw( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1

	local ll = caster:GetMaxHealth()
	
		damage = ll * i

		ApplyDamageEx(caster,target,ability,damage)
		ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	

end


function sxkw2( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ii = ability:GetLevelSpecialValueFor("ii", ability:GetLevel() - 1)

	local modifier  = caster:FindModifierByName("modifier_yxtfjn_xm")
	if modifier then
		ii = modifier:GetStackCount() + ii 
		modifier:SetStackCount(ii)
	else
		local modifier = ability:ApplyDataDrivenModifier(caster,caster,"modifier_yxtfjn_xm",{})
		modifier:SetStackCount(ii)
			
	end
	caster:CalculateStatBonus(true)


end