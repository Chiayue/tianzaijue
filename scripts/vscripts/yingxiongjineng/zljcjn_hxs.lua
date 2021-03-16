function hxs( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local max = ability:GetLevelSpecialValueFor("max", level)
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	if caster.hxs_baseDamage == nil then
		caster.hxs_baseDamage = 0
	end
	if caster.hxs_damage == nil then
		caster.hxs_damage = 0
	end
	if caster.hxs_max == nil then
		caster.hxs_max= 0
	end
	if caster.hxs_multiple == nil then
		caster.hxs_multiple = 0
	end
	max = max + caster.hxs_max
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.hxs_baseDamage
	i = i + caster.hxs_damage
	local damage = (zl * i + baseDamage2 ) * x * shbs
	if RollPercentage(20) then
			damage = damage * (caster.hxs_multiple + 1 )
	end	
	local point = caster:GetAbsOrigin()
		 local units = FindAlliesInRadiusExdd(caster,point,radius)
		if units ~= nil then
			local a = 0
			for key,unit in ipairs(units) do	
				if 	a < max then
					a = a +1	
					local point2 = unit:GetAbsOrigin()
					local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf";
					local fxIndex = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, unit )
					ParticleManager:SetParticleControl( fxIndex, 0, point2 )
					Timers:CreateTimer(0.25,function()
					ApplyDamageMf(caster,unit,ability,damage)
					StartSoundEventFromPosition("Ability.StarfallImpact",point2)
					end)
				else	
					break
				end		
			end
		else
			return nil
		end

end



