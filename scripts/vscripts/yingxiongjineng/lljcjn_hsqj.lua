function hsqj( keys )	
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	radius = radius + level * 10
	local ll = caster:GetStrength()
	local point = caster:GetAbsOrigin()
	local fx = caster:GetForwardVector()
	jd	= VectorToAngles(fx)
	jd2 = VectorToAngles(RotateVector2D(fx,30))
	jd3 = VectorToAngles(RotateVector2D(fx,-30))
	local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
	for key, unit in pairs(units) do	
		local point3 = unit:GetAbsOrigin()
		jd4 = VectorToAngles(GetForwardVector(point,point3))
		local x1= jd2.y
		local x2= jd3.y
		local x3= jd4.y
		if x1 <= 30 then 
		x1 = x1 + 360
		if x3 <= 30 then
		x3 = x3 + 360
		end
		end
		if x2 >= 330 then
		x2 = x2 - 360
		if x3 >=330 then
		x3 = x3 - 360
		end
		end
		if x3 <= x1 and x3 >= x2   then
		 damage = ll * i * x / 10		
		local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf";
		local fxIndex = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( fxIndex, 0, point3)
		ApplyDamageEx(caster,unit,ability,damage)
		ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
		end
	end

end