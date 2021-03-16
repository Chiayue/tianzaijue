function yg25zxny(keys)
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
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_skewer_disable_caster", {})
end


function CheckTargets(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local point2 = ability.point
	
	local skewer_radius = ability:GetLevelSpecialValueFor("skewer_radius", ability:GetLevel() - 1)

	-- Units to be caught in the skewer
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, skewer_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, 0, false)
					
	-- Loops through target
	for i,unit in ipairs(units) do
		if unit:HasModifier("modifier_skewer_disable_target") == false or 	--避免受到多次伤害
			caster:HasModifier("modifier_skewer_disable_target2") == false then -- 能让多个傀儡同时冲锋的时候一起造成伤害

		local damage = 10 *  caster:GetAverageTrueAttackDamage(caster) 
	
		ApplyDamageMf(caster,unit,ability,damage)
		ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_skewer_disable_target", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_skewer_disable_target2", {})
	end		
	end
end

function SkewerMotion(keys)
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
			target:RemoveModifierByName("modifier_skewer_disable_caster")
		else
			target:RemoveModifierByName("modifier_skewer_disable_target")
		end
	end
end
