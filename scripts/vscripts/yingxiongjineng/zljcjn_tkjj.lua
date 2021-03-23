function tkjj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)	
	if caster.tkjj_baseDamage == nil then
		caster.tkjj_baseDamage = 0
	end
	if caster.tkjj_damage == nil then
		caster.tkjj_damage = 0
	end
	if caster.tkjj_multiple == nil then
		caster.tkjj_multiple = 0
	end
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.tkjj_baseDamage
	i = i +caster.tkjj_damage
	local multiple = 1
	if RollPercentage(50) then
		multiple = caster.tkjj_multiple +multiple
	end	
	local damage = (zl * i + baseDamage2 ) * x * multiple * shbs
	if caster.cas_table.tswsh > 100 then
		damage = damage * caster.cas_table.tswsh /100
	end
	local time = caster.tkjj_time + 1	--触发次数
	
	if time > 5 then
		 damage = ((time -5) *0.2+1) * damage
	end
	ApplyDamageMf(caster,target,ability,damage)


end

function fctkjj(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel() - 1)	
	if caster.tkjj_radius == nil then
		caster.tkjj_radius = 0
	end
	if caster.tkjj_time == nil then
		caster.tkjj_time = 0
	end
	radius = radius + caster.tkjj_radius
	local time = caster.tkjj_time + 1	--触发次数
	if time > 5 then
		time = 5
	end
	local time2 = 0
	TimerUtil.createTimer(function ()
		if time2 < time then
			if caster:IsAlive() then	--如果目标存活，则重新选取目标点
				local units = FindAlliesInRadiusExdd(caster,caster:GetAbsOrigin(),radius)
				if RollPercentage(50) and time2~=0 then 		--为了防止后续攻击频率太高，降低了多次触发时候的声音出现次数
					StartSoundEventFromPosition("Hero_QueenOfPain.ScreamOfPain",caster:GetAbsOrigin())
				end
				local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_POINT_FOLLOW, caster)
				ParticleManager:SetParticleControl(p1, 0, caster:GetAbsOrigin()) -- Origin
				 for key, unit in pairs(units) do
					local info = 
					{
						Target = unit,
						Source = caster,
						Ability = ability,	
						EffectName = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf",
					    iMoveSpeed = 1000,
						vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
						bDrawsOnMinimap = false,                          -- Optional
					     bDodgeable = true,                                -- Optional
					    bIsAttack = false,                                -- Optional
					     bVisibleToEnemies = true,                         -- Optional
					     bReplaceExisting = false,                         -- Optional
					     flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
						bProvidesVision = true,                           -- Optional
						iVisionRadius = 400,                              -- Optional
						iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
					}
					local projectile = ProjectileManager:CreateTrackingProjectile(info)		
				end
			else
				return nil
			end
			
			time2 = time2 + 1

		else
			return nil
		end	
			return 0.5 	--每0.5S触发一次

	end)


	



end