fxtx={
"particles/mjjcjn/fx_1.vpcf";
"particles/mjjcjn/fx_2.vpcf";
"particles/mjjcjn/fx_3.vpcf";
"particles/mjjcjn/fx_4.vpcf";
"particles/mjjcjn/fx_5.vpcf";
"particles/mjjcjn/fx_6.vpcf";

}
fxfx={
	0;
	30;
	-30;
	60;
	-60;
	90;
	-90;

}
function fx(keys)
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
	if caster.fx_chance == nil then
		caster.fx_chance = 0
	end
    chance = chance + caster.fx_chance
	if chance <= xyz then
		
		return nil 
	end



	local point = target:GetAbsOrigin()
	local projectileName = "particles/mjjcjn/fx_"..lv..".vpcf"
	local powershot_max_range = ability:GetLevelSpecialValueFor( "shock_distance", level )
	local movespeed = ability:GetLevelSpecialValueFor( "shock_speed", level)
	--movespeed = RandomInt(1000,movespeed) --随机设置特效的飞行速度
	local powershot_radius = ability:GetLevelSpecialValueFor( "shock_width",level)
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
	if caster.fx_max == nil then
		caster.fx_max = 0
	end
	local max = 1+ caster.fx_max
	if max > 7 then		--最多七道剑气
		max = 7
	end

	powershot_max_range = powershot_max_range + caster.fx_distance

	powershot_radius = powershot_radius + caster.fx_radius

	local time = caster.fx_time + 1
	local time2  = 1
	TimerUtil.createTimer(function ()
		if time2 <= time then
			time2 = time2 + 1
			if caster:IsAlive() then	--如果单位死亡，则不继续释放技能了
				fxfs(projectileName,ability,caster,fv,movespeed,powershot_max_range,powershot_radius,max)
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

function fxfs(projectileName,ability,caster,fv,movespeed,powershot_max_range,powershot_radius,max)
	for i=1,max do
		local projectileTable =
		{
			EffectName = projectileName,
			Ability = ability,
			vSpawnOrigin = caster:GetAbsOrigin(),
			vVelocity =  RotateVector2D(fv,fxfx[i]) * movespeed,
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



function fxsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	


	local mj = caster:GetAgility()

	if caster.fx_baseDamage == nil then
		caster.fx_baseDamage = 0
	end
	if caster.fx_damage == nil then
		caster.fx_damage = 0
	end
	if caster.fx_multiple == nil then
		caster.fx_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.fx_multiple + multiple
	end	
	i = i + caster.fx_damage
	local baseDamage2 = baseDamage + caster.fx_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * multiple * shbs
		
	ApplyDamageEx(caster,target,ability,damage)

end


