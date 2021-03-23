function hpq( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i",level)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local chance =  keys.ability:GetLevelSpecialValueFor("chance", level)

	local xyz = RandomInt(1,100)		--设置触发概率
	if caster.hpq_chance == nil then
		caster.hpq_chance = 0
	end
    chance = chance + caster.hpq_chance 
	if chance <= xyz then
		
		return nil 
	end	
	
	
	local point = target:GetAbsOrigin()

	if caster.hpq_baseDamage == nil then
		caster.hpq_baseDamage = 0
	end
	if caster.hpq_damage == nil then
		caster.hpq_damage = 0
	end
	i = i +caster.hpq_damage
	local ll = caster:GetStrength()
	local baseDamage2 = baseDamage + caster.hpq_baseDamage
	local damage = (ll * i + baseDamage2 ) * x * shbs
	local damage2= damage
	
	if caster.hpq_time == nil then
		caster.hpq_time = 0
	end
	if caster.hpq_multiple == nil then
		caster.hpq_multiple = 0
	end
	if RollPercentage(50) then	--百分之二十的概率触发暴击伤害
			damage2 = damage * (caster.hpq_multiple + 1 )
	end	

	local p1 = ParticleManager:CreateParticle("particles/test/tusk_ti9_golden_walruspunch_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(p1, 0, point) -- Origin
	
	StartSoundEventFromPosition("Hero_Tusk.WalrusPunch.Target",point)--白牛被动命中人的声音

	ApplyDamageEx(caster,target,ability,damage2)	
	local kv_knockback =
	{
		center_x = point.x,
		center_y = point.y,
		center_z = point.z,
		should_stun = true, 
		duration = 0.5,
		knockback_duration = 0.5,
		knockback_distance = 0,
		knockback_height = 300,
	}
	if target.isboss ~= 1 then
		target:AddNewModifier( target, nil, "modifier_knockback", kv_knockback )
	end



	local time = caster.hpq_time --触发次数
	if time > 7 then
		time = 7
	end
	TimerUtil.createTimerWithDelay(0.5,function ()
		if time > 0 then
			if EntityIsAlive(target) == false then	--如果目标存活，则重新选取目标点
				return nil
			end
			local point = target:GetAbsOrigin()
			if RollPercentage(30) then 		--为了防止后续攻击频率太高，降低了多次触发时候的声音出现次数
				StartSoundEventFromPosition("Hero_Tusk.WalrusPunch.Target",point)
			end
			local p1 = ParticleManager:CreateParticle("particles/test/tusk_ti9_golden_walruspunch_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(p1, 0, point) -- Origin
			local multiple = 1
			if RollPercentage(50) then
				multiple = caster.hpq_multiple +multiple
			end	
			damage2 = damage * multiple
		 	local kv_knockback =
			{
				center_x = point.x,
				center_y = point.y,
				center_z = point.z,
				should_stun = true, 
				duration = 0.4,
				knockback_duration = 0.4,
				knockback_distance = 0,
				knockback_height = 300,
			}
			if target.isboss ~= 1 then
				target:AddNewModifier( target, nil, "modifier_knockback", kv_knockback )
			end
			ApplyDamageEx(caster,target,ability,damage2)	
			time = time - 1

		else
			return nil
		end	
			return 0.5 	--每0.5S触发一次

	end)

end


