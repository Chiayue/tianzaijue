function ymcz(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local skewer_speed = ability:GetLevelSpecialValueFor("skewer_speed", ability:GetLevel() - 1)
	local range = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1)
	local point = ability:GetCursorPosition()
	
	-- Distance and direction variables
	local vector_distance = point - caster:GetAbsOrigin()
	local direction = (vector_distance):Normalized()	
	local distance = (vector_distance):Length2D()
	if distance < range then
		
		 range = distance
	end

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
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ymcz_disable_caster", {})
end


function ymcz2(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local point2 = ability.point
	local i = ability:GetLevelSpecialValueFor("i", ability:GetLevel() - 1)
	
	local skewer_radius = ability:GetLevelSpecialValueFor("skewer_radius", ability:GetLevel() - 1)
	local level = ability:GetLevel() - 1
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local ll = caster:GetStrength()

	if caster.ymcz_baseDamage == nil then
		caster.ymcz_baseDamage = 0
	end
	if caster.ymcz_damage == nil then
		caster.ymcz_damage = 0
	end
	if caster.ymcz_multiple == nil then
		caster.ymcz_multiple = 0
	end

	local baseDamage2 = baseDamage + caster.ymcz_baseDamage
	i = i + caster.ymcz_damage
	local damage = (ll * i + baseDamage2 ) * x
	if RollPercentage(20) then
			damage = damage * (caster.ymcz_multiple + 1 )
	end	
	-- Units to be caught in the skewer
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, skewer_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
					
	-- Loops through target
	for key,unit in ipairs(units) do
		if unit:HasModifier("modifier_ymcz_disable_target") == false or 	--避免受到多次伤害
			caster:HasModifier("modifier_ymcz_disable_target2") == false then -- 能让多个傀儡同时冲锋的时候一起造成伤害
		local jl = 	GetDistance2D( point2, caster:GetAbsOrigin())

		



		ApplyDamageEx(caster,unit,ability,damage)
		ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_ymcz_disable_target", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ymcz_disable_target2", {})
	end		
	end
end

function ymcz3(keys)
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
			target:RemoveModifierByName("modifier_ymcz_disable_caster")
		else
			target:RemoveModifierByName("modifier_ymcz_disable_target")
		end
	end
end
