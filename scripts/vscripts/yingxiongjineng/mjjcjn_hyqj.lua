function hyqj( keys )
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
	if caster.hyqj_chance == nil then
		caster.hyqj_chance = 0
	end
    chance = chance + caster.hyqj_chance 
	if chance <= xyz then
		
		return nil 
	end	
	
	
	local point = target:GetAbsOrigin()

	if caster.hyqj_baseDamage == nil then
		caster.hyqj_baseDamage = 0
	end
	if caster.hyqj_damage == nil then
		caster.hyqj_damage = 0
	end
	i = i +caster.hyqj_damage
	local mj = caster:GetAgility()
	local baseDamage2 = baseDamage + caster.hyqj_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * shbs
	if damage > 500000000 then
		damage = 500000000
	end
	local damage2= damage
	
	if caster.hyqj_time == nil then
		caster.hyqj_time = 0
	end
	if caster.hyqj_multiple == nil then
		caster.hyqj_multiple = 0
	end
	if RollPercentage(50) then	--百分之二十的概率触发暴击伤害
			damage2 = damage * (caster.hyqj_multiple + 1 )
	end	

	local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(p1, 0, point) -- Origin
	
	StartSoundEventFromPosition("Hero_Spirit_Breaker.GreaterBash.Creep",point)--白牛被动命中人的声音

	ApplyDamageEx(caster,target,ability,damage2)	

	local time = caster.hyqj_time	--触发次数
	TimerUtil.createTimerWithDelay(0.5,function ()
		if time > 0 then
			if target:IsAlive() == false then	--如果目标存活，则重新选取目标点
				return nil
			end
			if RollPercentage(30) then 		--为了防止后续攻击频率太高，降低了多次触发时候的声音出现次数
				StartSoundEventFromPosition("Hero_Spirit_Breaker.GreaterBash.Creep",point)
			end
			local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(p1, 0, point) -- Origin
			local multiple = 1
			if RollPercentage(50) then
				multiple = caster.hyqj_multiple +multiple
			end	
			damage2 = damage * multiple
		 
			ApplyDamageEx(caster,target,ability,damage2)	
			time = time - 1

		else
			return nil
		end	
			return 0.5 	--每0.5S触发一次

	end)

end


