
function csyz( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability:GetLevel() - 1)	
	for i=0,4 do
		local ability = caster:GetAbilityByIndex(i)
		if ability then
			ability:EndCooldown()
		end
	end
	ability:StartCooldown(cooldown)
	

end



