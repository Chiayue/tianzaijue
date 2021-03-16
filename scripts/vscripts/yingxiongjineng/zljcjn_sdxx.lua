function bsxx( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = keys.target_points[1]
	local zl = caster:GetIntellect()
	if caster.bsxx_baseDamage == nil then
		caster.bsxx_baseDamage = 0
	end
	if caster.bsxx_damage == nil then
		caster.bsxx_damage = 0
	end
	if caster.bsxx_radius == nil then
	caster.bsxx_radius = 0
	end
	if caster.bsxx_time == nil then
		caster.bsxx_time = 0
	end
	if caster.bsxx_multiple == nil then
		caster.bsxx_multiple = 0
	end
	if caster.bsxx_max == nil then
		caster.bsxx_max = 0
	end
	local baseDamage2 = baseDamage + caster.bsxx_baseDamage
	i = i + caster.bsxx_damage
	local damage = (zl * i + baseDamage2 ) * x  * shbs
	if damage > 500000000 then
		damage = 500000000
	end
	radius = radius + caster.bsxx_radius

	local time = caster.bsxx_time  
	if time > 5 then
		time = 5
	end
	local time2  = 0
	local point2 = point
	TimerUtil.createTimer(function ()
		if time2 <= time then
			time2 = time2 + 1		
			local max  = 1 + caster.bsxx_max 
			for i=1,max do
				if caster:IsAlive() then	--如果单位死亡，则不继续释放技能了
					if i > 1  then
						point2 =   point + RandomVector(RandomInt(300, 800)) 
					end
					local units = FindAlliesInRadiusExdd(caster,point2,radius) --寻找玩家的敌对单位
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", PATTACH_WORLDORIGIN, caster)
					ParticleManager:SetParticleControl(particle, 0, point2) -- Origin
					ParticleManager:SetParticleControl(particle, 1, Vector(radius,2,radius)) -- Origin
					if RollPercentage(20) and time2 ~= 1 then
						StartSoundEventFromPosition("Hero_Crystal.CrystalNova",point2)
					end
					if units ~= nil then
						for key, unit in pairs(units) do
							
							local multiple = 1
							if RollPercentage(20) then
								multiple = caster.bsxx_multiple + multiple
							end	 
							local damage2 = damage * multiple
							
							ability:ApplyDataDrivenModifier(caster, unit, "modifier_crystal_nova_slow_datadriven", {})		
							ApplyDamageMf(caster,unit,ability,damage2)	
						end
					end	
				else 
					return nil
				end
			end
		end
		return 0.5
	end)







end


