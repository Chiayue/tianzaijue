--[[Author: YOLOSPAGHETTI
	Date: February 4, 2016
	Riki attacks the target and applies all passive effects]]
function PerformAttacks(keys)
	local caster = keys.caster
	local target = keys.target
	
	caster:PerformAttack(target, true, true, true, false, false)
end

--[[Author: YOLOSPAGHETTI
	Date: February 4, 2016
	Riki backstabs the target]]
function ProcBackstab(keys)
	local caster = keys.caster
	local target = keys.target
	
	local agility_damage_multiplier = 100
		-- Play the sound on the victim.
		EmitSoundOn(keys.sound, keys.target)
		-- Create the back particle effect.
		local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, target) 
		-- Set Control Point 1 for the backstab particle; this controls where it's positioned in the world. In this case, it should be positioned on the victim.
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true) 
		-- Apply extra backstab damage based on Riki's agility
		ApplyDamageEx(caster,target,ability,damage)
end

--[[Author: YOLOSPAGHETTI
	Date: February 4, 2016
	Riki's model is hidden]]
function RemoveModel(keys)
	local caster = keys.caster
	
	caster:AddNoDraw()	
end

--[[Author: YOLOSPAGHETTI
	Date: February 4, 2016
	Riki's model is redrawn]]
function DrawModel(keys)
	local caster = keys.caster

	caster:RemoveNoDraw()
end
