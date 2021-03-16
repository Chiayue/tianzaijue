function hsjq( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = keys.ability:GetLevelSpecialValueFor("radius",level)
	local distance = ability:GetLevelSpecialValueFor( "distance", level )
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	local i = keys.ability:GetLevelSpecialValueFor("i", level)	
	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local mj = caster:GetAgility()
	if caster.hsjq_distance == nil then
		caster.hsjq_distance = 0
	end
	if caster.hsjq_baseDamage == nil then
		caster.hsjq_baseDamage = 0
	end
	if caster.hsjq_damage == nil then
		caster.hsjq_damage = 0
	end
	if caster.hsjq_multiple == nil then
		caster.hsjq_multiple = 0
	end

	local baseDamage2 = baseDamage + caster.hsjq_baseDamage
	i = i + caster.hsjq_damage
	local damage = (mj * i + baseDamage2 ) * x
	local damage2 = damage
	if RollPercentage(20) then
			damage2 = damage * (caster.hsjq_multiple + 1 )
	end	
	distance = distance + caster.hsjq_distance
	local point = keys.target_points[1]
	local caster_point=caster:GetAbsOrigin()
	local fv = GetForwardVector(caster_point,point) * distance
	point = caster_point + fv
	
	local particleID = ParticleManager:CreateParticle( "particles/units/heroes/hero_drow/drow_silence_wave.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( particleID, 1, Vector(point.x-caster_point.x,point.y-caster_point.y,0) )



	--local units = FindAlliesInRadiusEx(target,point,radius)
	local units = FindUnitsInLine( caster:GetTeamNumber(),caster_point,point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER  )
	if units ~= nil then
	for key, unit in pairs(units) do
		ability:ApplyDataDrivenModifier(caster,unit,"modifier_mjjcjn_hsjq1",{})
		ApplyDamageEx(caster,unit,ability,damage2)
		ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	--	local particleID = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_ABSORIGIN, caster )
	--	ParticleManager:SetParticleControl( particleID, 0, unit:GetAbsOrigin() )

		end
	end	
	


end


