--[[Author: Pizzalol
	Date: 26.09.2015.
	Clears current caster commands and disjoints projectiles while setting up everything required for movement]]
function Leap( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local point = keys.target_points[1]
	local vector_distance = point - caster:GetAbsOrigin()
	local direction = (vector_distance):Normalized()	
	local distance = (vector_distance):Length2D()
	
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + level / 10
	radius = radius + level * 10	

	-- Clears any current command and disjoints projectiles
	caster:Stop()
	ProjectileManager:ProjectileDodge(caster)

	-- Ability variables
	ability.leap_direction = caster:GetForwardVector()
	ability.leap_distance = distance
	ability.leap_speed = ability:GetLevelSpecialValueFor("leap_speed", ability_level) * 1/20
	ability.leap_traveled = 0
	ability.leap_z = 0



	local xx = ability.leap_distance / ability.leap_speed


	 TimerUtil.createTimerWithDelay(0.3, function()
            tz(caster,ability,radius,i,level,point)
        end
    )


end

--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function LeapHorizonal( keys )
	local caster = keys.target
	local ability = keys.ability

	if ability.leap_traveled < ability.leap_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.leap_direction * ability.leap_speed)
		ability.leap_traveled = ability.leap_traveled + ability.leap_speed
	else
		caster:InterruptMotionControllers(true)
	end
end

--[[Moves the caster on the vertical axis until movement is interrupted]]
function LeapVertical( keys )
	local caster = keys.target
	local ability = keys.ability

	-- For the first half of the distance the unit goes up and for the second half it goes down
	if ability.leap_traveled < ability.leap_distance/2 then
		-- Go up
		-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
		ability.leap_z = ability.leap_z + ability.leap_speed/2
		-- Set the new location to the current ground location + the memorized z point
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z))
	else
		-- Go down
		ability.leap_z = ability.leap_z - ability.leap_speed/2
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.leap_z))
	end
end

function tz( caster,ability,radius,i,level,point)
	local x = 1 + level / 10
	radius = radius + level * 10

	local ll = caster:GetStrength()
	 local p1 = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9_lvl2_start_rocks.vpcf",PATTACH_ABSORIGIN,caster)
    ParticleManager:SetParticleControl( p1, 0, point )

		local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	print(x)
	print(level)
	print(i)
--	if unit ~= nil
	for key, unit in pairs(units) do
		damage = ll * i * x

		
		ApplyDamageEx(caster,unit,ability,damage)
		ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
		

		end
--	end	
	

end
