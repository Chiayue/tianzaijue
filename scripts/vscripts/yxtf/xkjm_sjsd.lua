function sjsd( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	
	if target:IsAlive() then

	local ll = caster:GetAgility()
--	local point = caster:GetAbsOrigin()	
		damage = ll * i
		ApplyDamageEx(caster,target,ability,damage)
--	if  caster:AttackReady() then
--	caster:StartGesture(ACT_DOTA_ATTACK)
--	caster:PerformAttack(target, true, true, true, false, true, false, false)

--	caster:PerformAttack(target, true, true, true, true, false, false, false)
--	caster:PerformAttack(target, true, true, false, true, true, false, false)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)
	Timers:CreateTimer(0.2, function()
	caster:PerformAttack(target, false, true, true, false, false, false, false)
	end)	
--end
		ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)

	end



	
	
		
end



