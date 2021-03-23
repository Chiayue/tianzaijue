function lypj( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local chance =  ability:GetLevelSpecialValueFor("chance", level)

	local xyz = RandomInt(1,100)		--设置触发概率
	if caster.lypj_chance == nil then
		caster.lypj_chance = 0
	end
    chance = chance + caster.lypj_chance
	if chance <= xyz then
		
		return nil 
	end	
	
	
	local point = target:GetAbsOrigin()

	if caster.lypj_baseDamage == nil then
		caster.lypj_baseDamage = 0
	end
	if caster.lypj_damage == nil then
		caster.lypj_damage = 0
	end
	i = i + caster.lypj_damage
	local mj = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.lypj_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * shbs
	local damage2= damage
	
	if caster.lypj_time == nil then
		caster.lypj_time = 0
	end
	if caster.lypj_multiple == nil then
		caster.lypj_multiple = 0
	end
	if RollPercentage(50) then	--百分之二十的概率触发暴击伤害
			damage2 = damage * (caster.lypj_multiple + 1 )
	end	

	local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", PATTACH_POINT_FOLLOW, target)
--	ParticleManager:SetParticleControl(p1, 0, point) -- Origin
	ParticleManager:SetParticleControl(p1, 5, point) -- Origin
	--ParticleManager:SetParticleControl(p1, 1, point) -- Origin
	TimerUtil.createTimerWithDelay(0.5, function()	--0.2S摧毁特效
   		ParticleManager:DestroyParticle(p1,true)          
   	end)
	--StartSoundEventFromPosition("Hero_Jakiro.LiquidFire",point)--这个是双头龙液体火命中敌人的声音
		ApplyDamageMf(caster,target,ability,damage2)	
			
	local time = caster.lypj_time	--触发次数
	if time > 5 then
		time = 5
	end
	TimerUtil.createTimerWithDelay(0.5,function ()
		if time > 0 then
			if EntityIsAlive(target) then	--如果目标存活，则重新选取目标点
				point = target:GetAbsOrigin()
			end
			local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", PATTACH_POINT_FOLLOW, target)
			ParticleManager:SetParticleControl(p1, 5, point) -- Origin
			--ParticleManager:SetParticleControl(p1, 1, point) -- Origin
			 TimerUtil.createTimerWithDelay(0.5, function()	--0.2S摧毁特效
			       ParticleManager:DestroyParticle(p1,true)          
			 end)
			local multiple = 1
			if RollPercentage(50) then
				multiple = caster.lypj_multiple +multiple
			end	

			damage2 = damage * multiple
			ApplyDamageMf(caster,target,ability,damage2)	
		
			time = time - 1

		else
			return nil
		end	
			return 0.5 	--每0.5S触发一次

	end)

end


