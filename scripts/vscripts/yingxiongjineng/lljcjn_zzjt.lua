function zzjt( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local i = ability:GetLevelSpecialValueFor("i", ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local ll = caster:GetStrength()
	local point = caster:GetAbsOrigin()



	if caster.zzjt_baseDamage == nil then
		caster.zzjt_baseDamage = 0
	end
	if caster.zzjt_damage == nil then
		caster.zzjt_damage = 0
	end
	if caster.zzjt_radius == nil then
	caster.zzjt_radius = 0
	end
	if caster.zzjt_time == nil then
		caster.zzjt_time = 0
	end
	if caster.zzjt_multiple == nil then
		caster.zzjt_multiple = 0
	end
	radius = caster.zzjt_radius + radius
	i = i + caster.zzjt_damage
	local baseDamage2 = baseDamage + caster.zzjt_baseDamage
	local damage = (ll * i + baseDamage2 ) * x * shbs
	local damage2 = damage 
	if RollPercentage(20) then
		damage2 = damage * (caster.zzjt_multiple+1)
	end	

	local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle, 1, Vector(radius*2,0,radius)) -- Origin
	if units ~= nil then
	for key, unit in pairs(units) do
		ApplyDamageEx(caster,unit,ability,damage2)
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_hoof_stomp", {})
		end
	end	
	
	local time = caster.zzjt_time - 1
	if time > 5 then
		time = 5
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
				StartSoundEventFromPosition("Hero_Centaur.HoofStomp",point)
			end	
			
			local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位	
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
			ParticleManager:SetParticleControl(particle, 1, Vector(radius*2,0,radius)) -- Origin
			local multiple = 1
			if RollPercentage(20) then
				multiple = caster.zzjt_multiple +multiple
			end	
			local damage2 = damage * multiple
			if units ~= nil then
				for key, unit in pairs(units) do
					ApplyDamageEx(caster,unit,ability,damage2)
					if RollPercentage(50) then
						ability:ApplyDataDrivenModifier(caster, unit, "modifier_hoof_stomp", {})
					end
				end
			end	


		else 
			return nil 
		end
		return 0.5
	end)
end


