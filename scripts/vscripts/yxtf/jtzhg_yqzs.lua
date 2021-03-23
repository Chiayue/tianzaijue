function yqzs( keys )
	local caster = keys.caster
	local target = keys.attacker
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local ii = keys.ability:GetLevelSpecialValueFor("ii", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + level / 10
	
	local ll = caster:GetStrength()
	local damage = ll * i * x
	local heal = ll * ii
	if heal > 100000000 then
		heal = 100000000
	end
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)
	Timers:CreateTimer(0.1, function()
	caster:PerformAttack(target, false, true, true, false, false, false, false)
	caster:Heal(heal, caster)
	ApplyDamageEx(caster,target,ability,damage)
	end)	

end



