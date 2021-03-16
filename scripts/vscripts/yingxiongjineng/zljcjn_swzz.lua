function swzz( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = keys.ability:GetLevelSpecialValueFor("i", level)	
	local sh = keys.ability:GetLevelSpecialValueFor("sh", level)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)
	local radius =  keys.ability:GetLevelSpecialValueFor("radius", level)
	local max =  keys.ability:GetLevelSpecialValueFor("max", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local modifier = keys.modifier
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)	
	local particle_finger = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"
	local particle_finger_fx = ParticleManager:CreateParticle(particle_finger, PATTACH_ABSORIGIN_FOLLOW, caster)

	local cs = caster:FindModifierByName(modifier):GetStackCount()

	if caster.swzz_baseDamage == nil then
		caster.swzz_baseDamage = 0
	end
	if caster.swzz_damage == nil then
		caster.swzz_damage = 0
	end
	if caster.swzz_multiple == nil then
		caster.swzz_multiple = 0
	end
	if caster.swzz_max == nil then
		caster.swzz_max = 0
	end

	max = max + caster.swzz_max
	if caster:HasModifier("modifier_yxtfjn_laien") then
		max = max + math.ceil(caster:GetLevel()/30)*2
	end
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.swzz_baseDamage +(sh*cs)
	i = i + caster.swzz_damage 
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.swzz_multiple + multiple
	end	 
	local damage = (zl * i + baseDamage2 ) * x 
	local damage2 = damage * multiple * shbs
	
	ParticleManager:SetParticleControlEnt(particle_finger_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_finger_fx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_finger_fx, 2, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_finger_fx)    
		
		
	ApplyDamageMf(caster,target,ability,damage2)
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage2)
		if target:IsAlive() then
		--	print(cs)
		else
			cs = cs + math.ceil(caster:GetLevel()/20)
			caster:SetModifierStackCount(modifier, caster, cs)
		end

	if max > 1 then
		local units = FindAlliesInRadiusExdd(caster,target:GetAbsOrigin(),radius) --寻找玩家的敌对单位	
	if units ~= nil then
		local a = 1
		for key, unit in pairs(units) do
			if unit ~=target then
				if a < max then
					a= a+1
					local cs = caster:FindModifierByName(modifier):GetStackCount()
					local zl = caster:GetIntellect()
					local baseDamage2 = baseDamage + caster.swzz_baseDamage +(sh*cs)
					i = i + caster.swzz_damage 
					local multiple = 1
					if RollPercentage(20) then
						multiple = caster.swzz_multiple + multiple
					end	 
					local damage = (zl * i + baseDamage2 ) * x 
					local damage2 = damage * multiple
					local particle_finger_fx = ParticleManager:CreateParticle(particle_finger, PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControlEnt(particle_finger_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(particle_finger_fx, 1, unit:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle_finger_fx, 2, unit:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(particle_finger_fx)    
						
						
					ApplyDamageMf(caster,unit,ability,damage2)
					ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage2)
					if unit:IsAlive() == false then
						cs = cs + math.ceil(caster:GetLevel()/20)
						caster:SetModifierStackCount(modifier, caster, cs)
					end
				end
				
			end
			
		end
	end	
	end
	




end



