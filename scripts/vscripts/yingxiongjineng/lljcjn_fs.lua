function lzfs( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = keys.ability:GetLevelSpecialValueFor("radius", level)
	local i = keys.ability:GetLevelSpecialValueFor("i", level)	
	local chance =  keys.ability:GetLevelSpecialValueFor("chance", level)
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)
	local shbs = keys.ability:GetLevelSpecialValueFor("shbs", level)		
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local xyz = RandomInt(1,100)
	if caster.lzfs_chance == nil then
		caster.lzfs_chance = 0
	end
    chance = chance + caster.lzfs_chance
	if chance <= xyz then
		
		return nil 
	end

	if caster.lzfs_baseDamage == nil then
		caster.lzfs_baseDamage = 0
	end
	if caster.lzfs_damage == nil then
		caster.lzfs_damage = 0
	end
	if caster.lzfs_radius == nil then
		caster.lzfs_radius = 0
	end
	if caster.lzfs_time == nil then
		caster.lzfs_time = 0
	end
	if caster.lzfs_multiple == nil then
		caster.lzfs_multiple = 0
	end

	radius = radius + caster.lzfs_radius
	local zsx = caster:GetStrength()
	local point = target:GetAbsOrigin()
	local baseDamage2 = baseDamage + caster.lzfs_baseDamage
	local damage = (zsx * (i + caster.lzfs_damage) + baseDamage2 ) * x *shbs
	local damage2 = damage
	if RollPercentage(20) then
			damage2 = damage * (caster.lzfs_multiple + 1 )
	end	
	local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位
	StartSoundEventFromPosition("Hero_Ursa.Earthshock",point)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_earthshock.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, point) -- Origin
	ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius)) -- Destination
	if units ~= nil then
		for key, unit in pairs(units) do
			ApplyDamageEx(caster,unit,ability,damage2)
		end
	end				


	local time = caster.lzfs_time - 1
	if time > 5 then
		time = 5
	end
	local time2  = 0
	TimerUtil.createTimerWithDelay(0.5,function ()
		if time2 <= time then
			time2 = time2 + 1		
			if EntityIsAlive(target) then	--如果目标存活，则重新选取目标点
				point = target:GetAbsOrigin()
			end
			if RollPercentage(30) then
				StartSoundEventFromPosition("Hero_Ursa.Earthshock",point)
			end
			local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_earthshock.vpcf", PATTACH_POINT_FOLLOW, target)
			ParticleManager:SetParticleControl(particle, 0, point) -- Origin
			ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius)) -- Destination
			local multiple = 1
			if RollPercentage(20) then
				multiple = caster.lzfs_multiple +multiple
			end	
			local damage2 = damage * multiple
			if units ~= nil then
				for key, unit in pairs(units) do
					ApplyDamageEx(caster,unit,ability,damage2)
				end
			end
		else 
			return nil 
		end
		return 0.5
	end)


end


