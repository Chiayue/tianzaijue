dxcqfx={
	0;
	30;
	-30;
	60;
	-60;
	90;
	-90;

}

function dxcq(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if not caster:IsAlive() then
		return nil 
	end
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)	
	local chance =  ability:GetLevelSpecialValueFor("chance", level)

	local xyz = RandomInt(1,100)		--设置触发概率
	if caster.dxcq_chance == nil then
		caster.dxcq_chance = 0
	end
    chance = chance + caster.dxcq_chance
	if chance <= xyz then
		
		return nil 
	end

	local point = target:GetAbsOrigin()
	local projectileName = "particles/econ/items/death_prophet333.vpcf"
	local powershot_max_range = ability:GetLevelSpecialValueFor( "shock_distance", level )
	local movespeed = ability:GetLevelSpecialValueFor( "shock_speed", level)
	--movespeed = RandomInt(1000,movespeed) --随机设置特效的飞行速度
	local powershot_radius = ability:GetLevelSpecialValueFor( "shock_width",level)
	local fv = GetForwardVector(caster:GetAbsOrigin(),point)


	if caster.dxcq_radius == nil then
	caster.dxcq_radius = 0
	end
	if caster.dxcq_distance == nil then
		caster.dxcq_distance = 0
	end
	if caster.dxcq_time == nil then
		caster.dxcq_time = 0
	end
	if caster.dxcq_max == nil then
		caster.dxcq_max = 0
	end
	

	powershot_max_range = powershot_max_range + caster.dxcq_distance

	powershot_radius = powershot_radius + caster.dxcq_radius

	local max = caster.dxcq_max + 1
	local time = caster.dxcq_time + 1
	if time*max > 12 then
		 time = 3
		 max = 4
	end
	
	TimerUtil.createTimer(function ()
		time = time - 1
		if caster:IsAlive() then	--如果单位死亡，则不继续释放技能了
			dxcqfs(projectileName,ability,caster,fv,powershot_max_range,powershot_radius,max)
		else 
			return nil
		end
		if time > 0 then
			return 0.5 	--每0.5S触发一次
		end
	end)


	
end

function dxcqfs(projectileName,ability,caster,fv,powershot_max_range,powershot_radius,max)
	for i=1,max do
		local projectileTable =
		{
			EffectName = projectileName,
			Ability = ability,
			vSpawnOrigin = caster:GetAbsOrigin(),
			vVelocity = RotateVector2D(fv,dxcqfx[i]) * powershot_max_range,
			fDistance = powershot_max_range or 1000,
			fStartRadius = powershot_radius,
			fEndRadius = powershot_radius,
			Source = caster,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		
			iVisionTeamNumber = caster:GetTeamNumber(),
			fExpireTime = GameRules:GetGameTime() + 5.0,

		}
		ProjectileManager:CreateLinearProjectile( projectileTable )
	end
end


function dxcqsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	


	local mj = caster:GetIntellect()

	if caster.dxcq_baseDamage == nil then
		caster.dxcq_baseDamage = 0
	end
	if caster.dxcq_damage == nil then
		caster.dxcq_damage = 0
	end
	if caster.dxcq_multiple == nil then
		caster.dxcq_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.dxcq_multiple + multiple
	end	
	i = i + caster.dxcq_damage
	local baseDamage2 = baseDamage + caster.dxcq_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * multiple * shbs
	if caster.cas_table.tswsh > 100 then
		damage = damage * caster.cas_table.tswsh /100
	end
	local max = caster.dxcq_max + 1
	local time = caster.dxcq_time + 1
	if time*max > 12 then
		 damage = ((time*max -12) *0.08+1) * damage
	end
	ApplyDamageMf(caster,target,ability,damage)

end


