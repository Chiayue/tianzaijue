lpzfx={
	0;
	20;
	-20;
	40;
	-40;
	60;
	-60;
}

function lpz( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)	
	local zl = caster:GetIntellect()


	if caster.lpz_baseDamage == nil then
		caster.lpz_baseDamage = 0
	end
	if caster.lpz_damage == nil then
		caster.lpz_damage = 0
	end
	if caster.lpz_multiple == nil then
		caster.lpz_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.lpz_multiple + multiple
	end	
	local baseDamage2 = baseDamage + caster.lpz_baseDamage
	i = i+ caster.lpz_damage
	local damage = (zl * i + baseDamage2 ) * x * multiple * shbs
		
	ApplyDamageMf(caster,target,ability,damage)


end

function lpzsf(keys)
	local caster = keys.caster
	--local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local max = keys.ability:GetLevelSpecialValueFor("max", keys.ability:GetLevel() - 1)	
	local point = keys.target_points[1]
	
	--local projectileName = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
	local projectileName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf"
--	E:\steam\steamapps\common\dota 2 beta\content\dota_addons\wenyizhidi\particles
	-- Ability variables
	
	
	local powershot_max_range = ability:GetLevelSpecialValueFor( "shock_distance", keys.ability:GetLevel() -1 )
	local powershot_max_movespeed = ability:GetLevelSpecialValueFor( "shock_speed", keys.ability:GetLevel() -1)
	local powershot_radius = ability:GetLevelSpecialValueFor( "shock_start_width",keys.ability:GetLevel() - 1)

	local fv = GetForwardVector(caster:GetAbsOrigin(),point)

	if caster.lpz_radius == nil then
	caster.lpz_radius = 0
	end
	if caster.lpz_distance == nil then
		caster.lpz_distance = 0
	end
	if caster.lpz_max == nil then
		caster.lpz_max = 0
	end
	if caster.lpz_time == nil then
		caster.lpz_time = 0
	end


	powershot_max_range = powershot_max_range + caster.lpz_distance

	powershot_radius = powershot_radius + caster.lpz_radius

	max = max + caster.lpz_max
	if max > 7 then		--最多七道剑气
		max = 7
	end
	local point2 = caster:GetAbsOrigin()
	local time = caster.lpz_time
	if time > 5 then
		time = 5
	end
	local time2  = 0
	TimerUtil.createTimer(function ()
		if time2 <= time then
			time2 = time2 + 1		
			if caster:IsAlive() then	--如果单位死亡，则不继续释放技能了
				point2 = caster:GetAbsOrigin()
			else 
				return nil
			end
			if RollPercentage(20) and time2 ~= 1 then
				StartSoundEventFromPosition("Hero_Lina.DragonSlave",point2)
				sound = true
			end



	for var=1, max do
	local projectileTable =
	{
		EffectName = projectileName,
		Ability = ability,
		vSpawnOrigin = caster:GetAbsOrigin(),
		vVelocity = RotateVector2D(fv,lpzfx[var]) * powershot_max_range,
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
	local p = ProjectileManager:CreateLinearProjectile( projectileTable )
		end

		else 
			return nil 
		end
		return 0.5
	end)
end
