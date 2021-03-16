function hdyj( keys )
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
	if caster.hdyj_chance == nil then
		caster.hdyj_chance = 0
	end
    chance = chance + caster.hdyj_chance
	if chance <= xyz then
		
		return nil 
	end	
	
	
	local point = target:GetAbsOrigin()

	if caster.hdyj_baseDamage == nil then
		caster.hdyj_baseDamage = 0
	end
	if caster.hdyj_damage == nil then
		caster.hdyj_damage = 0
	end
	i = i + caster.hdyj_damage
	local mj = caster:GetAverageTrueAttackDamage(caster)
	local baseDamage2 = baseDamage + caster.hdyj_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * shbs
	if damage > 500000000 then
		damage = 500000000
	end
	local damage2= damage
	
	if caster.hdyj_time == nil then
		caster.hdyj_time = 0
	end
	if caster.hdyj_multiple == nil then
		caster.hdyj_multiple = 0
	end
	if RollPercentage(50) then	--百分之二十的概率触发暴击伤害
			damage2 = damage * (caster.hdyj_multiple + 1 )
	end	

	local p1 = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_crit_tgt.vpcf", PATTACH_POINT_FOLLOW, target)
	--ParticleManager:SetParticleControl(p1, 0, target) -- Origin
	ParticleManager:SetParticleControl(p1, 1, point) -- Origin
	TimerUtil.createTimerWithDelay(0.5, function()	--0.2S摧毁特效
   		ParticleManager:DestroyParticle(p1,true)          
   	end)
	StartSoundEventFromPosition("Hero_Jakiro.LiquidFire",point)--这个是双头龙液体火命中敌人的声音
		ApplyDamageEx(caster,target,ability,damage2)	
			
	local time = caster.hdyj_time	--触发次数
	if time > 5 then
		time = 5
	end
	TimerUtil.createTimerWithDelay(0.5,function ()
		if time > 0 then
			if EntityIsAlive(target) then	--如果目标存活，则重新选取目标点
				point = target:GetAbsOrigin()
			end
			if RollPercentage(30) then 		--为了防止后续攻击频率太高，降低了多次触发时候的声音出现次数
				StartSoundEventFromPosition("Hero_Jakiro.LiquidFire",point)
			end
			local p1 = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_crit_tgt.vpcf", PATTACH_POINT_FOLLOW, target)
	--		ParticleManager:SetParticleControl(p1, 0, target) -- Origin
			ParticleManager:SetParticleControl(p1, 1, point) -- Origin
			 TimerUtil.createTimerWithDelay(0.5, function()	--0.2S摧毁特效
			       ParticleManager:DestroyParticle(p1,true)          
			 end)
			local multiple = 1
			if RollPercentage(50) then
				multiple = caster.hdyj_multiple +multiple
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


