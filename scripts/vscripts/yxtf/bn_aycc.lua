function aycc(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local skewer_speed = ability:GetLevelSpecialValueFor("skewer_speed", ability:GetLevel() - 1)
	local range = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1)
	local point = ability:GetCursorPosition()
	
	-- Distance and direction variables
	local vector_distance = point - caster:GetAbsOrigin()
	local direction = (vector_distance):Normalized()	


	ability.point = caster:GetAbsOrigin()	
	-- Total distance to travel
	ability.distance = range
	
	-- Distance traveled per interval
	ability.speed = skewer_speed/17
	
	-- The direction to travel
	ability.direction = direction
	
	-- Distance traveled so far
	ability.traveled_distance = 0
	
	-- Applies the disable modifier
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_yxtfjn_aycc_caster", {})
	local projectileTable =
			{
				EffectName = "",
				Ability = ability,
				vSpawnOrigin =caster:GetAbsOrigin(),
				vVelocity = direction * 1800,
				fDistance = 1200,
				fStartRadius = 300,
				fEndRadius = 300,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = true,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			local p  = ProjectileManager:CreateLinearProjectile( projectileTable )
end




function aycc2(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	-- Move the target while the distance traveled is less than the original distance upon cast
	if ability.traveled_distance < ability.distance then
		target:SetAbsOrigin(target:GetAbsOrigin() + ability.direction * ability.speed)
		-- If the target is the caster, calculate the new travel distance
		if target == caster then
			ability.traveled_distance = ability.traveled_distance + ability.speed
		end
	else
		-- Remove the motion controller once the distance has been traveled
		target:InterruptMotionControllers(true)
		-- Remove the appropriate disable modifier from the target
		if target == caster then
			target:RemoveModifierByName("modifier_yxtfjn_aycc_caster")
		end
	end
end

function ayccsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)/100
	local chance = ability:GetLevelSpecialValueFor("chance", level)
	local vLocation=caster:GetAbsOrigin()
	local kv_knockback =
	{
		center_x = vLocation.x,
		center_y = vLocation.y,
		center_z = vLocation.z,
		should_stun = true, 
		duration = 0.4,
		knockback_duration = 0.4,
		knockback_distance = 200,
		knockback_height = 0,
	}
	if target.isboss ~= 1 then
		target:AddNewModifier( target, nil, "modifier_knockback", kv_knockback )
	end
	if RollPercent(chance) then
		caster:PerformAttack(target, true, true, true, false, true, false, true)
	end

	local mj = caster:GetHealth()
	local damage = mj * i
	ApplyDamageEx(caster,target,ability,damage)


end