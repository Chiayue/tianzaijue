
function lxgy(keys)
	local caster = keys.caster
	local ability = keys.ability
	local max = ability:GetLevelSpecialValueFor("max", keys.ability:GetLevel() - 1)	
	local point = keys.target_points[1]
	local level = ability:GetLevel() - 1
	local projectileName = "particles/test/lxgy.vpcf"
	
	local powershot_max_range = ability:GetLevelSpecialValueFor( "shock_distance", level )
	local powershot_max_movespeed = ability:GetLevelSpecialValueFor( "shock_speed", level)
	local powershot_radius = ability:GetLevelSpecialValueFor( "shock_width",level)
	local fv = GetForwardVector(caster:GetAbsOrigin(),point)
	local point2 = caster:GetAbsOrigin()




	local projectileTable =
	{
		EffectName = projectileName,
		Ability = ability,
		vSpawnOrigin =point2,
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
	local p  = ProjectileManager:CreateLinearProjectile( projectileTable )



	
end


function lxgysh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage",level)	
	local bfb = ability:GetLevelSpecialValueFor("bfb",level)	
	local mj = caster:GetAgility()
	local damage = mj * i +baseDamage
	local modifier = ability:ApplyDataDrivenModifier(caster,target,"modifier_yxtfjn_sye",{})
	local cs = math.ceil(target:GetPhysicalArmorBaseValue()*bfb/100)
	modifier:SetStackCount(cs)
	ApplyDamageEx(caster,target,ability,damage)
end


