xffffx={
	0;
	20;
	-20;
	40;
	-40;
	60;
	-60;

}

function xfff( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	

    local projectileName = "particles/xuanfengfeihuwhirling_axe_ranged.vpcf"
    powershot_max_range = ability:GetLevelSpecialValueFor( "distance", keys.ability:GetLevel() -1 )
	powershot_max_movespeed = ability:GetLevelSpecialValueFor( "speed", keys.ability:GetLevel() -1)
	powershot_radius = ability:GetLevelSpecialValueFor( "start_radius",keys.ability:GetLevel() - 1)
	max = ability:GetLevelSpecialValueFor( "max",keys.ability:GetLevel() - 1)
	local fv = caster:GetForwardVector()
	local point = keys.target_points[1]
	local caster_point=caster:GetAbsOrigin()
	local fv = GetForwardVector(caster_point,point) 

	if caster.xfff_radius == nil then
	caster.xfff_radius = 0
	end
	if caster.xfff_distance == nil then
		caster.xfff_distance = 0
	end
	if caster.xfff_max == nil then
		caster.xfff_max = 0
	end

	powershot_max_range = powershot_max_range + caster.xfff_distance

	powershot_radius = powershot_radius + caster.xfff_radius




	max = max + caster.xfff_max
		if max > 7 then		--最多七道剑气
			max = 7
		end
	for var=1, max do
    local projectileTable =
	{
		EffectName = projectileName,
		Ability = ability,
		vSpawnOrigin = caster:GetAbsOrigin(),
		vVelocity = RotateVector2D(fv,xffffx[var]) * powershot_max_range,
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
	caster.powershot_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )
	end

end




function xfffsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = keys.ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
    local point = target:GetAbsOrigin()
	local ll = caster:GetStrength()

	if caster.xfff_baseDamage == nil then
		caster.xfff_baseDamage = 0
	end
	if caster.xfff_damage == nil then
		caster.xfff_damage = 0
	end

	local baseDamage2 = baseDamage + caster.xfff_baseDamage
	i = i + caster.xfff_damage
	damage = (ll * i + baseDamage2 ) * x



	ApplyDamageEx(caster,target,ability,damage)

		


end




