


function cyj(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local level = ability:GetLevel() - 1
	local projectileName = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_combo.vpcf"
	
	local powershot_max_range = ability:GetLevelSpecialValueFor( "shock_distance",level)
	local powershot_max_movespeed = ability:GetLevelSpecialValueFor( "shock_speed", level)
	local powershot_radius = ability:GetLevelSpecialValueFor( "shock_width",level)
	local max = ability:GetLevelSpecialValueFor( "max",level)
	local fv = GetForwardVector(caster:GetAbsOrigin(),point)

	if caster.cyj_radius == nil then
	caster.cyj_radius = 0
	end
	if caster.cyj_distance == nil then
		caster.cyj_distance = 0
	end
	if caster.cyj_count == nil then
		caster.cyj_count = 0
	end
	if caster.cyj_time == nil then
		caster.cyj_time = 0
	end
	local time = 1 + caster.cyj_time 
	powershot_max_range = powershot_max_range + caster.cyj_distance

	powershot_radius = powershot_radius + caster.cyj_radius

	max = max + caster.cyj_count
	if max > 15 then
		max = 15
	end
	local time2 = 0
 TimerUtil.createTimerWithDelay(0,function()
	if time2 < time then
	time2 = time2 +1
	for var=1, max do
	local jd =RotateVector2D(fv,RandomInt(0,360))
	local projectileTable =
	{
		EffectName = projectileName,
		Ability = ability,
		vSpawnOrigin = caster:GetAbsOrigin()+jd *RandomInt(-400,-100),
		vVelocity = fv * powershot_max_range,
		fDistance = powershot_max_range,
		fStartRadius = powershot_radius,
		fEndRadius = powershot_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = true,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	local powershot_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )
	end
	return 0.5
		end
	end)


end



function cyjsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10


	local mj = caster:GetAgility()
	
	if caster.cyj_baseDamage == nil then
		caster.cyj_baseDamage = 0
	end
	if caster.cyj_damage == nil then
		caster.cyj_damage = 0
	end

	local baseDamage2 = baseDamage + caster.cyj_baseDamage
	i = i + caster.cyj_damage
	local damage = (mj * i + baseDamage2 ) * x
	if damage > 500000000 then
		damage = 500000000
	end	
	ApplyDamageEx(caster,target,ability,damage)


end


