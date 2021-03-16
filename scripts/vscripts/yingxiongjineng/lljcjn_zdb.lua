zdbfx={
	0;
	20;
	-20;
	40;
	-40;
	60;
	-60;

}
function zdb(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local max = keys.ability:GetLevelSpecialValueFor("max", keys.ability:GetLevel() - 1)	
	local point = keys.target_points[1]
	local projectileName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
	-- Ability variables
	
	
	local powershot_max_range = ability:GetLevelSpecialValueFor( "shock_distance", keys.ability:GetLevel() -1 )
	local powershot_max_movespeed = ability:GetLevelSpecialValueFor( "shock_speed", keys.ability:GetLevel() -1)
	local powershot_radius = ability:GetLevelSpecialValueFor( "shock_width",keys.ability:GetLevel() - 1)
	local fv = caster:GetForwardVector()


	if caster.zdb_radius == nil then
	caster.zdb_radius = 0
	end
	if caster.zdb_distance == nil then
		caster.zdb_distance = 0
	end
	if caster.zdb_max == nil then
		caster.zdb_max = 0
	end
	if caster.zdb_time == nil then
		caster.zdb_time = 0
	end


	powershot_max_range = powershot_max_range + caster.zdb_distance

	powershot_radius = powershot_radius + caster.zdb_radius

	max = max + caster.zdb_max
	if max > 7 then		--最多七道剑气
		max = 7
	end
	local point2 = caster:GetAbsOrigin()
	local time = caster.zdb_time
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
				StartSoundEventFromPosition("Hero_Magnataur.ShockWave.Particle",point2)
				sound = true
			end
			for var=1, max do
			local projectileTable =
			{
				EffectName = projectileName,
				Ability = ability,
				vSpawnOrigin = point2,
				vVelocity = RotateVector2D(fv,zdbfx[var]) * powershot_max_range,
				fDistance = powershot_max_range,
				fStartRadius = powershot_radius,
				fEndRadius = powershot_radius,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = true,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 5.0,
				iVisionTeamNumber = caster:GetTeamNumber(),
			}
			local p = ProjectileManager:CreateLinearProjectile( projectileTable )
			end

		else 
			return nil 
		end
		return 0.5
	end)
end


function zdbsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10 
	local ll = caster:GetStrength()
	
	if caster.zdb_baseDamage == nil then
		caster.zdb_baseDamage = 0
	end
	if caster.zdb_damage == nil then
		caster.zdb_damage = 0
	end
	if caster.zdb_multiple == nil then
		caster.zdb_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.zdb_multiple + multiple
	end	
	i = i + caster.zdb_damage
	local baseDamage2 = baseDamage + caster.zdb_baseDamage
	local damage = (ll * i + baseDamage2 ) * x * multiple * shbs
	ApplyDamageEx(caster,target,ability,damage)
	--ability:ApplyDataDrivenModifier(caster, target, "modifier_lljcjn_zdb", {})
--	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lljcjn_zdb", {})
	--end

end


