function gjz( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local duration = ability:GetLevelSpecialValueFor("duration", level)
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = keys.target_points[1]
	
	if caster.gjz_baseDamage == nil then
		caster.gjz_baseDamage = 0
	end
	if caster.gjz_damage == nil then
		caster.gjz_damage = 0
	end
	if caster.gjz_radius == nil then
		caster.gjz_radius = 0
	end
	if caster.gjz_duration == nil then
		caster.gjz_duration = 0
	end
	if caster.gjz_max == nil then
		caster.gjz_max = 0
	end
	if caster.gjz_multiple == nil then
		caster.gjz_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
			multiple = multiple +  caster.gjz_multiple
	end	
	radius = radius + caster.gjz_radius
	duration =duration + caster.gjz_duration
	
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.gjz_baseDamage
	i = i + caster.gjz_damage
	local damage = (zl * i + baseDamage2 ) * x * multiple * shbs
	if damage > 500000000 then
		damage = 500000000
	end
	local max  = 1 + caster.gjz_max 
	for i=1,max do
		local point2 = point
		if i ~=1 then
			point2 =   point + RandomVector(RandomFloat(300, 800)) 
		end
		local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(p1, 0, point2) -- Origin
		ParticleManager:SetParticleControl(p1, 1, Vector(radius,0,0)) -- Origin
		ParticleManager:SetParticleControl(p1, 3, Vector(0,0,0)) -- Origin
		TimerUtil.createTimerWithDelay(0.2, function()	
	   		   local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl(p2, 0, point2) -- Origin
				ParticleManager:SetParticleControl(p2, 1, Vector(radius,0,0)) -- Origin
				ParticleManager:SetParticleControl(p2, 3, Vector(0,0,0)) -- Origin
	   	end)

		local units = FindAlliesInRadiusExdd(caster,point2,radius)	
		for key, unit in pairs(units) do
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_light_strike_array_datadriven", {duration=duration})
			ApplyDamageMf(caster,unit,ability,damage)	
		end
	end
	

end


