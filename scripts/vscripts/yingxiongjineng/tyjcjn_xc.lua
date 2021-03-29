function xc( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage =ability:GetLevelSpecialValueFor("baseDamage", level)	
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local bfb = ability:GetLevelSpecialValueFor("bfb", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = caster:GetAbsOrigin()
	local ll = caster:GetHealth() *bfb / 100
	local xl = caster:GetHealth() - caster:GetHealth() *bfb / 100
	caster:SetHealth(xl)
	if caster.xc_baseDamage == nil then
		caster.xc_baseDamage = 0
	end
	if caster.xc_damage == nil then
		caster.xc_damage = 0
	end
	if caster.xc_multiple == nil then
		caster.xc_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.xc_multiple + multiple
	end	  
	local baseDamage2 = baseDamage + caster.xc_baseDamage
	local damage = (ll * (i+caster.xc_damage) + baseDamage2 ) * x * multiple
	if caster:GetPrimaryAttribute() == 0 then
		damage = damage *1.5
	end
	local particle = ParticleManager:CreateParticle("particles/test/xuechao2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, point) -- Origin
 	local time = 5
	local time2  = 0
	TimerUtil.createTimerWithDelay(0.5,function ()
		if time2 <= time then
			time2 = time2 + 1			
			if RollPercentage(50) then
				StartSoundEventFromPosition("Ability.Torrent",point)
			end
			local units = FindAlliesInRadiusExdd(caster,point,radius)
			if units ~= nil then
			for key, unit in pairs(units) do
				ApplyDamageMf(caster,unit,ability,damage)	
				end
			end	
			local particle = ParticleManager:CreateParticle("particles/test/xuechaoimpact.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle, 0, point) -- Origin
			ParticleManager:SetParticleControl(particle, 3, point) 
		else 
			return nil 
		end
		return 0.75
	end)
end







