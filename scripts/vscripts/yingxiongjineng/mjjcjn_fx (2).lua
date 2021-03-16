fxtx={
"particles/mjjcjn/fx.vpcf";
"particles/mjjcjn/fx_2.vpcf";
"particles/mjjcjn/fx_3.vpcf";
"particles/mjjcjn/fx_4.vpcf";
"particles/mjjcjn/fx_5.vpcf";
"particles/mjjcjn/fx_6.vpcf";

}
function fx(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local lv = keys.ability:GetLevelSpecialValueFor("lv", keys.ability:GetLevel() - 1)	
	local chance =  keys.ability:GetLevelSpecialValueFor("chance", level)

	local xyz = RandomInt(1,100)		--设置触发概率
	if caster.fx_chance == nil then
		caster.fx_chance = 0
	end
    chance = chance + caster.fx_chance
	if chance <= xyz then
		
		return nil 
	end



	local point = target:GetAbsOrigin()
	local projectileName = fxtx[lv]
	-- Ability variables
	
	powershot_max_range = ability:GetLevelSpecialValueFor( "shock_distance", keys.ability:GetLevel() -1 )
	local movespeed = ability:GetLevelSpecialValueFor( "shock_speed", keys.ability:GetLevel() -1)
	--movespeed = RandomInt(1000,movespeed) --随机设置特效的飞行速度
	powershot_radius = ability:GetLevelSpecialValueFor( "shock_width",keys.ability:GetLevel() - 1)
	local fv = GetForwardVector(caster:GetAbsOrigin(),point)

	if caster.fx_radius == nil then
	caster.fx_radius = 0
	end
	if caster.fx_distance == nil then
		caster.fx_distance = 0
	end
	if caster.fx_time == nil then
		caster.fx_time = 0
	end


	powershot_max_range = powershot_max_range + caster.fx_distance

	powershot_radius = powershot_radius + caster.fx_radius

	time = 1+ caster.fx_time	--s设置触发概率

	TimerUtil.createTimer(function ()
		if time == 0 then
			fxfs(projectileName,ability,caster,fv,movespeed,powershot_max_range,powershot_radius)
			time = time - 1
			return 0.3 	--每0.3S触发一次
		end
	end)


	
end

function fxfs(projectileName,ability,caster,fv,movespeed,powershot_max_range,powershot_radius)
	local projectileTable =
	{
		EffectName = projectileName,
		Ability = ability,
		vSpawnOrigin = caster:GetAbsOrigin(),
		vVelocity = fv * movespeed,
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



function fxsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = keys.ability:GetLevelSpecialValueFor("i", level)
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	
	local x = 1 + level / 10
	


	local mj = caster:GetAgility()

	if caster.fx_baseDamage == nil then
		caster.fx_baseDamage = 0
	end
	if caster.fx_damage == nil then
		caster.fx_damage = 0
	end
	i = i + caster.fx_damage
	local baseDamage2 = baseDamage + caster.fx_baseDamage
	damage = (mj * i + baseDamage2 ) * x
		
	ApplyDamageEx(caster,target,ability,damage)

end


