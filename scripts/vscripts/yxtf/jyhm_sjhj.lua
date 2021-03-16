

function sjhj( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)
	local damage = caster:GetStrength()*i
	local point =target:GetAbsOrigin()
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_tag_team_debuff.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle, 1, point) -- Origin

	ApplyDamageEx(caster,target,ability,damage)	
	
	
end