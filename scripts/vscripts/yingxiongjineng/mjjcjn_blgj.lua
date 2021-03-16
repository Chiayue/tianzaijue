function blgj( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel()-1)
	local i = ability:GetLevelSpecialValueFor("i", ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local chance =  ability:GetLevelSpecialValueFor("chance", level)

	local xyz = RandomInt(1,100)		--设置触发概率
	if caster.blgj_chance == nil then
		caster.blgj_chance = 0
	end
    chance = chance + caster.blgj_chance
	if chance <= xyz then
		
		return nil 
	end	
	
	
	local point = target:GetAbsOrigin()

	if caster.blgj_baseDamage == nil then
		caster.blgj_baseDamage = 0
	end
	if caster.blgj_damage == nil then
		caster.blgj_damage = 0
	end
	if caster.blgj_radius == nil then
		caster.blgj_radius = 0
	end
	i = i + caster.blgj_damage
	radius = radius + caster.blgj_radius
	local mj = caster:GetAgility()
	local baseDamage2 = baseDamage + caster.blgj_baseDamage
	local damage = (mj * i + baseDamage2 ) * x *shbs
	if damage > 500000000 then
		damage = 500000000
	end
	local damage2= damage
	
	if caster.blgj_time == nil then
		caster.blgj_time = 0
	end
	if caster.blgj_multiple == nil then
		caster.blgj_multiple = 0
	end
	if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
			damage2 = damage * (caster.blgj_multiple + 1 )
	end	
	
	local units = FindAlliesInRadiusExdd(caster,point,radius)
	local p1 = ParticleManager:CreateParticle("particles/mjjcjn_blgj_kid/invoker_kid_forge_spirit_ambient.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(p1, 0, point) -- Origin
	TimerUtil.createTimerWithDelay(0.5, function()	--0.2S摧毁特效
   		ParticleManager:DestroyParticle(p1,true)          
   	end)
	StartSoundEventFromPosition("Hero_Jakiro.LiquidFire",point)--这个是双头龙液体火命中敌人的声音
	 for key, unit in pairs(units) do
		ApplyDamageEx(caster,unit,ability,damage2)	
			
	end
	local time = caster.blgj_time	--触发次数
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
			local p1 = ParticleManager:CreateParticle("particles/mjjcjn_blgj_kid/invoker_kid_forge_spirit_ambient.vpcf", PATTACH_POINT_FOLLOW, target)
			ParticleManager:SetParticleControl(p1, 0, point) -- Origin
			 TimerUtil.createTimerWithDelay(0.5, function()	--0.2S摧毁特效
			       ParticleManager:DestroyParticle(p1,true)          
			 end)
			local multiple = 1
			if RollPercentage(20) then
				multiple = caster.blgj_multiple +multiple
			end	
			damage2 = damage * multiple
		 	local units = FindAlliesInRadiusExdd(caster,point,radius)
			for key, unit in pairs(units) do
				ApplyDamageEx(caster,unit,ability,damage2)	
			--	ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)	
			end
			time = time - 1

		else
			return nil
		end	
			return 0.5 	--每0.5S触发一次

	end)

end


