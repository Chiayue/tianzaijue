function bsbp( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel()-1)
	local i = ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local chance =  ability:GetLevelSpecialValueFor("chance", level)

	local xyz = RandomInt(1,100)		--设置触发概率
	if caster.bsbp_chance == nil then
		caster.bsbp_chance = 0
	end
    chance = chance + caster.bsbp_chance
	if chance <= xyz then
		
		return nil 
	end	
	
	
	local point = target:GetAbsOrigin()

	if caster.bsbp_baseDamage == nil then
		caster.bsbp_baseDamage = 0
	end
	if caster.bsbp_damage == nil then
		caster.bsbp_damage = 0
	end
	if caster.bsbp_radius == nil then
		caster.bsbp_radius = 0
	end
	i = i + caster.bsbp_damage
	radius = radius + caster.bsbp_radius
	local mj = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.bsbp_baseDamage
	local damage = (mj * i + baseDamage2 ) * x *shbs
	
	if caster.bsbp_time == nil then
		caster.bsbp_time = 0
	end
	if caster.bsbp_multiple == nil then
		caster.bsbp_multiple = 0
	end
	if RollPercentage(50) then	--百分之二十的概率触发暴击伤害
			damage = damage * (caster.bsbp_multiple + 1 )
	end	

	local units = FindAlliesInRadiusExdd(caster,point,radius)
	local p1 = ParticleManager:CreateParticle("particles/econ/items/bsbp111cowlofice.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(p1, 0, point) -- Origin
	ParticleManager:SetParticleControl(p1, 1, Vector(radius,radius,radius)) -- Origin
	TimerUtil.createTimerWithDelay(0.5, function()	--0.2S摧毁特效
   		ParticleManager:DestroyParticle(p1,true)          
   	end)
	local time = caster.bsbp_time	--触发次数
	if time > 2 then
		damage = damage * ((time-2)*0.33+1)
		time = 2
	end

 	for key, unit in pairs(units) do
		ApplyDamageMf(caster,unit,ability,damage)			
	end
	TimerUtil.createTimerWithDelay(0.5,function ()
		if time > 0 then
			if EntityIsAlive(target) then	--如果目标存活，则重新选取目标点
				point = target:GetAbsOrigin()
			end
			local p1 = ParticleManager:CreateParticle("particles/econ/items/bsbp111cowlofice.vpcf", PATTACH_POINT_FOLLOW, target)
			ParticleManager:SetParticleControl(p1, 0, point) -- Origin
			ParticleManager:SetParticleControl(p1, 1, Vector(radius,radius,radius)) -- Origin
			 TimerUtil.createTimerWithDelay(0.5, function()	--0.2S摧毁特效
			       ParticleManager:DestroyParticle(p1,true)          
			 end)
			local multiple = 1
		 	local units = FindAlliesInRadiusExdd(caster,point,radius)
			for key, unit in pairs(units) do
				ApplyDamageMf(caster,unit,ability,damage)	
			--	ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)	
			end
			time = time - 1

		else
			return nil
		end	
			return 0.5 	--每0.5S触发一次

	end)

end


