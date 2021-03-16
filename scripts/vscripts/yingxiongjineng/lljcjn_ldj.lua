ldzfx={
	0;
	30;
	-30;
	60;
	-60;
	90;
	-90;

}
function ldj(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if not caster:IsAlive() then
		return nil 
	end
	local lv = keys.ability:GetLevelSpecialValueFor("lv", keys.ability:GetLevel() - 1)	
	local chance =  keys.ability:GetLevelSpecialValueFor("chance", keys.ability:GetLevel() - 1)

	local xyz = RandomInt(1,100)		--设置触发概率
	if caster.ldj_chance == nil then
		caster.ldj_chance = 0
	end
    chance = chance + caster.ldj_chance
	if chance <= xyz then
		
		return nil 
	end



	local point = target:GetAbsOrigin()
	local projectileName = "particles/econ/items/nyx_assassin/nyx_assassin_ti6/nyx_assassin_impale_ti6.vpcf"
	-- Ability variables
	
	local powershot_max_range = ability:GetLevelSpecialValueFor( "shock_distance", keys.ability:GetLevel() -1 )
	local movespeed = ability:GetLevelSpecialValueFor( "shock_speed", keys.ability:GetLevel() -1)
	local powershot_radius = ability:GetLevelSpecialValueFor( "shock_width",keys.ability:GetLevel() - 1)
	local fv = GetForwardVector(caster:GetAbsOrigin(),point)


	if caster.ldj_radius == nil then
	caster.ldj_radius = 0
	end
	if caster.ldj_distance == nil then
		caster.ldj_distance = 0
	end
	if caster.ldj_time == nil then
		caster.ldj_time = 0
	end

	if caster.ldj_max == nil then
		caster.ldj_max = 0
	end
	local max =  1+caster.ldj_max
	if max > 7 then		--最多七道剑气
		max = 7
	end
	powershot_max_range = powershot_max_range + caster.ldj_distance

	powershot_radius = powershot_radius + caster.ldj_radius

	local time = caster.ldj_time + 1
	if time > 5 then
		time = 5
	end
	local time2  = 1
	TimerUtil.createTimer(function ()
		if time2 <= time then
			time2 = time2 + 1
			if caster:IsAlive() then	--如果单位死亡，则不继续释放技能了
				ldjfs(projectileName,ability,caster,fv,movespeed,powershot_max_range,powershot_radius,max)
				if RollPercentage(20) or time2 == 2 then
					StartSoundEventFromPosition("Hero_DragonKnight.BreathFire",caster:GetAbsOrigin()) --龙骑火焰吐息的声音
				end
			else 
				return nil
			end
			return 0.5 	--每0.5S触发一次
		end
	end)


	
end

function ldjfs(projectileName,ability,caster,fv,movespeed,powershot_max_range,powershot_radius,max)
	for i=1,max do
		local projectileTable =
		{
			EffectName = projectileName,
			Ability = ability,
			vSpawnOrigin = caster:GetAbsOrigin(),
			vVelocity = RotateVector2D(fv,ldzfx[i]) * movespeed,
			fDistance = powershot_max_range,
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



function ldjsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = keys.ability:GetLevelSpecialValueFor("i", level)
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = target:GetAbsOrigin()	
	local kv_knockback =
	{
		center_x = point.x,
		center_y = point.y,
		center_z = point.z,
		should_stun = true, 
		duration = 0.2,
		knockback_duration = 0.2,
		knockback_distance = 0,
		knockback_height = 100,
	}
	if target.isboss ~= 1 then
		target:AddNewModifier( target, nil, "modifier_knockback", kv_knockback )
	end

	local mj = caster:GetStrength()

	if caster.ldj_baseDamage == nil then
		caster.ldj_baseDamage = 0
	end
	if caster.ldj_damage == nil then
		caster.ldj_damage = 0
	end
	if caster.ldj_multiple == nil then
		caster.ldj_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.ldj_multiple + multiple
	end	
	i = i + caster.ldj_damage
	local baseDamage2 = baseDamage + caster.ldj_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * multiple  * shbs
		
	ApplyDamageEx(caster,target,ability,damage)

end


