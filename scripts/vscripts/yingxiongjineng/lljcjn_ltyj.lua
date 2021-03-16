function ltyj( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local ll = caster:GetStrength()
	local point = caster:GetAbsOrigin()
	

	if caster.ltyj_baseDamage == nil then
		caster.ltyj_baseDamage = 0
	end
	if caster.ltyj_damage == nil then
		caster.ltyj_damage = 0
	end
	if caster.ltyj_radius == nil then
	caster.ltyj_radius = 0
	end
	if caster.ltyj_time == nil then
		caster.ltyj_time = 0
	end
	if caster.ltyj_multiple == nil then
		caster.ltyj_multiple = 0
	end
	radius = caster.ltyj_radius + radius
	i = i + caster.ltyj_damage
	local baseDamage2 = baseDamage + caster.ltyj_baseDamage
	local damage = (ll * i + baseDamage2 ) * x * shbs
	local damage2 = damage 
	if RollPercentage(20) then
		damage2 = damage * (caster.ltyj_multiple+1)
	end	

	local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位	
	local particle = ParticleManager:CreateParticle("particles/hero/brewmaster_thunder_clap.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle, 1, Vector(radius,0,0)) -- Origin
	ParticleManager:SetParticleControl(particle, 2, Vector(radius/20,0,0)) -- Origin
	if units ~= nil then
	for key, unit in pairs(units) do
		ApplyDamageEx(caster,unit,ability,damage2)
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_thunder_clap", {})
		end
	end	
	
	local time = caster.ltyj_time - 1
	if time > 7 then
		time = 7
	end
	local time2  = 0
	TimerUtil.createTimerWithDelay(0.5,function ()
		if time2 <= time then
			time2 = time2 + 1		
			if caster:IsAlive() then	--如果单位死亡，则不继续释放技能了
				point = caster:GetAbsOrigin()
			else 
				return nil
			end
			if RollPercentage(30) then
				StartSoundEventFromPosition("Hero_Ursa.Earthshock",point)
			end
			local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位	
			local particle = ParticleManager:CreateParticle("particles/hero/brewmaster_thunder_clap.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
			ParticleManager:SetParticleControl(particle, 1, Vector(radius,0,0)) -- Origin
			ParticleManager:SetParticleControl(particle, 2, Vector(radius/20,0,0)) -- Origin
			local multiple = 1
			if RollPercentage(20) then
				multiple = caster.ltyj_multiple +multiple
			end	
			local damage2 = damage * multiple
			if units ~= nil then
			for key, unit in pairs(units) do
				ApplyDamageEx(caster,unit,ability,damage2)
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_thunder_clap", {})
				end
			end	


		else 
			return nil 
		end
		return 0.5
	end)
end


