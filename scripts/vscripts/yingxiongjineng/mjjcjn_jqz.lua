
jqzfx={
	0;
	20;
	-20;
	40;
	-40;
	60;
	-60;

}

function jqz(keys)
	local caster = keys.caster
	--local target = keys.target
	local ability = keys.ability
	local max = ability:GetLevelSpecialValueFor("max", keys.ability:GetLevel() - 1)	
	local point = keys.target_points[1]
	local level = ability:GetLevel() - 1
	local projectileName = "particles/jqjf.vpcf"
	
	local powershot_max_range = ability:GetLevelSpecialValueFor( "shock_distance", level )
	local powershot_max_movespeed = ability:GetLevelSpecialValueFor( "shock_speed", level)
	local powershot_radius = ability:GetLevelSpecialValueFor( "shock_width",level)
	local fv = GetForwardVector(caster:GetAbsOrigin(),point)

	if caster.jqz_radius == nil then
	caster.jqz_radius = 0
	end
	if caster.jqz_distance == nil then
		caster.jqz_distance = 0
	end
	if caster.jqz_max == nil then
		caster.jqz_max = 0
	end
	if caster.jqz_time == nil then
		caster.jqz_time = 0
	end


	powershot_max_range = powershot_max_range + caster.jqz_distance

	powershot_radius = powershot_radius + caster.jqz_radius
	local point2 = caster:GetAbsOrigin()
	max = max + caster.jqz_max
	if max > 7 then		--最多七道剑气
		max = 7
	end
	
	local time = caster.jqz_time
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
				StartSoundEventFromPosition("Hero_Invoker.Tornado.Cast",point2)
				sound = true
			end
			for var=1, max do
			local projectileTable =
			{
				EffectName = projectileName,
				Ability = ability,
				vSpawnOrigin =point2,
				vVelocity = RotateVector2D(fv,jqzfx[var]) * powershot_max_range,
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
			local p  = ProjectileManager:CreateLinearProjectile( projectileTable )
			end

		else 
			return nil 
		end
		return 0.5
	end)

	
end


function jqzsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage",level)	
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

--	if target:HasModifier("modifier_mjjcjn_jqz") == false or 	--避免受到多次伤害
--		caster:HasModifier("modifier_mjjcjn_jqz") == false then -- 能让多个傀儡同时冲锋的时候一起造成伤害


	local mj = caster:GetAgility()
	
	if caster.jqz_baseDamage == nil then
		caster.jqz_baseDamage = 0
	end
	if caster.jqz_damage == nil then
		caster.jqz_damage = 0
	end
	if caster.jqz_multiple == nil then
		caster.jqz_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.jqz_multiple + multiple
	end	
	i = i + caster.jqz_damage
	local baseDamage2 = baseDamage + caster.jqz_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * multiple * shbs
	if caster.cas_table.tswsh > 100 then
		damage = damage * caster.cas_table.tswsh /100
	end

	ApplyDamageEx(caster,target,ability,damage)
--	ability:ApplyDataDrivenModifier(caster, target, "modifier_mjjcjn_jqz", {})
--	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mjjcjn_jqz", {})
	--end

end


