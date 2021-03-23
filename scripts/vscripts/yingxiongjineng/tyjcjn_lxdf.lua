function lxdf( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local bfb = ability:GetLevelSpecialValueFor("bfb", level)
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local chance =  ability:GetLevelSpecialValueFor("chance", level)

	local xyz = RandomInt(1,100)		--设置触发概率
	if caster.lxdf_chance == nil then
		caster.lxdf_chance = 0
	end
    chance = chance + caster.lxdf_chance
	if chance <= xyz then
		
		return nil 
	end	
	
	
	local point = target:GetAbsOrigin()

	if caster.lxdf_baseDamage == nil then
		caster.lxdf_baseDamage = 0
	end
	if caster.lxdf_damage == nil then
		caster.lxdf_damage = 0
	end
	i = i +caster.lxdf_damage
	local mj = caster:GetHealth() * bfb /100
	local xl = caster:GetHealth() - caster:GetHealth() *bfb / 100
	caster:SetHealth(xl)	
	local baseDamage2 = baseDamage + caster.lxdf_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * shbs
	local damage2= damage
	
	if caster.lxdf_time == nil then
		caster.lxdf_time = 0
	end
	if caster.lxdf_multiple == nil then
		caster.lxdf_multiple = 0
	end
	if RollPercentage(50) then	--百分之二十的概率触发暴击伤害
			damage2 = damage * (caster.lxdf_multiple + 1 )
	end	

	local p1 = ParticleManager:CreateParticle("particles/test/lxdf.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(p1, 1, point) -- Origin
	ApplyDamageEx(caster,target,ability,damage2)	
			
	local time = caster.lxdf_time	--触发次数
	if time > 5 then
		time = 5
	end
	TimerUtil.createTimerWithDelay(0.5,function ()
		if time > 0 then
			if EntityIsAlive(target) then	--如果目标存活，则重新选取目标点
				point = target:GetAbsOrigin()
			end
			local p1 = ParticleManager:CreateParticle("particles/test/lxdf.vpcf", PATTACH_POINT_FOLLOW, target)
			ParticleManager:SetParticleControl(p1, 1, point) -- Origin
			local mj = caster:GetHealth() * bfb /100
			local xl = caster:GetHealth() - caster:GetHealth() *bfb / 100
			caster:SetHealth(xl)	
			local baseDamage2 = baseDamage + caster.lxdf_baseDamage
			local damage = (mj * i + baseDamage2 ) * x * shbs
			local damage2= damage
			
			if caster.lxdf_time == nil then
				caster.lxdf_time = 0
			end
			if caster.lxdf_multiple == nil then
				caster.lxdf_multiple = 0
			end
			if RollPercentage(50) then	--百分之二十的概率触发暴击伤害
					damage2 = damage * (caster.lxdf_multiple + 1 )
			end	
					
			ApplyDamageEx(caster,target,ability,damage2)	
		
			time = time - 1

		else
			return nil
		end	
			return 0.5 	--每0.5S触发一次

	end)

end


