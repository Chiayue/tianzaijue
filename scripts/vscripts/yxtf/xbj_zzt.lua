
function zzt( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability:GetLevel() - 1)	
	if ability:IsCooldownReady() then
		for i=0,4 do
			local ability = caster:GetAbilityByIndex(i)
			if ability and ability:GetCooldownTime() <=30 then
				ability:EndCooldown()
			end
		end
		ability:StartCooldown(cooldown)
	end

end



