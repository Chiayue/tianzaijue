function jdc( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
	local i2 = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local damage = keys.ability:GetLevelSpecialValueFor("damage", keys.ability:GetLevel() - 1)	
	local damage2 = 0
	local point =caster:GetAbsOrigin()
	local is_ability = false
	for i=0, 4 do
		local current_ability = caster:GetAbilityByIndex(i)
		local name = current_ability:GetAbilityName()
		local name2 = string.sub(name,1,3)
		if name2 ~= "kjn" and  name2 ~= "yxt" and name2 ~= "abi"  then
			local cd = current_ability:GetCooldownTimeRemaining()		
			local full_cd = current_ability:GetCooldown(current_ability:GetLevel()-1)		--无法获得经过冷却缩减的技能CD，还是有BUG存在
			if cd > 0 and full_cd - cd < 0.1 then 
				is_ability = true
			end
		end
	end
	if is_ability == true then
		-- Finds every unit in the radius
		local units = FindEnemiesInRadiusEx(caster,point,radius)
		if units ~= nil then
		for key,unit in ipairs(units) do
			-- Attaches the particle
			local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:SetParticleControl(particle,0,unit:GetAbsOrigin())
			-- Plays the sound on the target
			EmitSoundOn(keys.sound, unit)
			-- Deals the damage based on the unit's current health
			local smz = unit:GetHealth()
			damage2 =  smz * i2 /100 +damage * caster:GetIntellect()
			ApplyDamageMf(caster,unit,ability,damage2)
		end
		end
	end


end

