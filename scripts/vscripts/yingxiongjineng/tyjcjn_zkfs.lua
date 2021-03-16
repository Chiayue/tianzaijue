function zkfs( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local chance =  ability:GetLevelSpecialValueFor("chance", level)

	local xyz = RandomInt(1,100)		--设置触发概率
	if caster.zkfs_chance == nil then
		caster.zkfs_chance = 0
	end
    chance = chance + caster.zkfs_chance
	if chance <= xyz then
		
		return nil 
	end	
	
	
	local point = target:GetAbsOrigin()

	if caster.zkfs_baseDamage == nil then
		caster.zkfs_baseDamage = 0
	end
	if caster.zkfs_damage == nil then
		caster.zkfs_damage = 0
	end
	if caster.zkfs_radius == nil then
		caster.zkfs_radius = 0
	end
	radius = radius + caster.zkfs_radius
	i = i +caster.zkfs_damage
	local mj = caster:GetAverageTrueAttackDamage(caster)
	local baseDamage2 = baseDamage + caster.zkfs_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * shbs
	if damage > 500000000 then
		damage = 500000000
	end
	local damage2= damage
	if caster.zkfs_time == nil then
		caster.zkfs_time = 0
	end
	if caster.zkfs_multiple == nil then
		caster.zkfs_multiple = 0
	end
	if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
			damage2 = damage * (caster.zkfs_multiple + 1 )
	end	

	local units = FindAlliesInRadiusExdd(caster,point,radius)
	local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(p1, 0, point) -- Origin
	TimerUtil.createTimerWithDelay(0.5, function()	--0.2S摧毁特效
   		ParticleManager:DestroyParticle(p1,true)          
   	end)
	StartSoundEventFromPosition("Hero_Abaddon.AphoticShield.Destroy",point)
	 for key, unit in pairs(units) do
		ApplyDamageEx(caster,unit,ability,damage2)	
			
	end
	local time = caster.zkfs_time	--触发次数
	if time > 5 then
		time = 5
	end
	TimerUtil.createTimerWithDelay(0.6,function ()
		if time > 0 then
			if EntityIsAlive(target) then	--如果目标存活，则重新选取目标点
				point = target:GetAbsOrigin()
			end
			if RollPercentage(30) then 		--为了防止后续攻击频率太高，降低了多次触发时候的声音出现次数
				StartSoundEventFromPosition("Hero_Abaddon.AphoticShield.Destroy",point)
			end
			local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_POINT_FOLLOW, target)
			ParticleManager:SetParticleControl(p1, 0, point) -- Origin
			 TimerUtil.createTimerWithDelay(0.5, function()	--0.2S摧毁特效
			       ParticleManager:DestroyParticle(p1,true)          
			 end)
			local multiple = 1
			if RollPercentage(20) then
				multiple = caster.zkfs_multiple +multiple
			end	
			damage2 = damage * multiple
		 	local units = FindAlliesInRadiusExdd(caster,point,radius)
			for key, unit in pairs(units) do
				ApplyDamageEx(caster,unit,ability,damage2)	
			end
			time = time - 1

		else
			return nil
		end	
			return 0.6 	--每0.5S触发一次

	end)

end

