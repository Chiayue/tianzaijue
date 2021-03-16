function sz(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local skewer_speed = ability:GetLevelSpecialValueFor("skewer_speed", ability:GetLevel() - 1)
	local range = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1)
	local point = ability:GetCursorPosition()
	
	if caster.sz_distance == nil then
		caster.sz_distance = 0
	end
	
	-- Distance and direction variables
	local vector_distance = point - caster:GetAbsOrigin()
	local direction = (vector_distance):Normalized()	
	local distance = (vector_distance):Length2D()
	if distance < range then
		
		 range = distance
	end

	ability.point = caster:GetAbsOrigin()	
	-- Total distance to travel
	ability.distance = range + caster.sz_distance
	
	-- Distance traveled per interval
	ability.speed = skewer_speed/17
	
	-- The direction to travel
	ability.direction = direction
	
	-- Distance traveled so far
	ability.traveled_distance = 0
	
	-- Applies the disable modifier
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mjjcjn_sz_caster", {})
end



function sz2(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local point2 = ability.point
	
	local mj = caster:GetAgility()
	local skewer_radius = ability:GetLevelSpecialValueFor("skewer_radius", ability:GetLevel() - 1)
	local max = ability:GetLevelSpecialValueFor("max", ability:GetLevel() - 1)
	local ii = ability:GetLevelSpecialValueFor("i", ability:GetLevel() - 1)
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	-- Units to be caught in the skewer
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, skewer_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
					


	if caster.sz_baseDamage == nil then
		caster.sz_baseDamage = 0
	end
	if caster.sz_damage == nil then
		caster.sz_damage = 0
	end
	if caster.sz_max == nil then
		caster.sz_max = 0
	end
	if caster.sz_multiple == nil then
		caster.sz_multiple = 0
	end
	max = max + caster.sz_max
	local baseDamage2 = baseDamage + caster.sz_baseDamage
	ii = ii + caster.sz_damage
	local damage = (mj * ii + baseDamage2 ) * x
	if RollPercentage(20) then
			damage = damage * (caster.sz_multiple + 1 )
	end	



	-- Loops through target
	for key,unit in ipairs(units) do
		if unit:HasModifier("modifier_mjjcjn_sz_target") == false or 	--避免受到多次伤害
			caster:HasModifier("modifier_mjjcjn_sz_target2") == false then -- 能让多个傀儡同时冲锋的时候一起造成伤害
		local jl = 	GetDistance2D( point2, caster:GetAbsOrigin())

	local interval = 1 / max
   	local count = 0
		TimerUtil.createTimer(function()
		if count < max then

		if unit:IsAlive() then
		 local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion_b.vpcf",PATTACH_ABSORIGIN,caster)
   			 ParticleManager:SetParticleControl( p1, 0, unit:GetAbsOrigin())
   			 ApplyDamageEx(caster,unit,ability,damage)
		--	ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
			count = count + 1

			return interval
end
		end
	end)

		
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_mjjcjn_sz_target", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mjjcjn_sz_target2",{})
	end		
	end
end

function sz3(keys)
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
			target:RemoveModifierByName("modifier_mjjcjn_sz_caster")
			target:RemoveModifierByName("modifier_mjjcjn_sz_target2")
		else
			target:RemoveModifierByName("modifier_mjjcjn_sz_target")
		end
	end
end
