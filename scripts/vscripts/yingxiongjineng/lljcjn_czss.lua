function czss( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local sh = ability:GetLevelSpecialValueFor("sh", level)
	local max = ability:GetLevelSpecialValueFor("max", level)
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)	
	local modifier = keys.modifier
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local cs = 0

	local ll = caster:GetStrength()
	local point = caster:GetAbsOrigin()

	if caster.czss_baseDamage == nil then
		caster.czss_baseDamage = 0
	end
	if caster.czss_damage == nil then
		caster.czss_damage = 0
	end
	if caster.czss_radius == nil then
	caster.czss_radius = 0
	end
	if caster.czss_time == nil then
		caster.czss_time = 0
	end
	if caster.czss_multiple == nil then
		caster.czss_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.czss_multiple + multiple
	end	
	radius = radius + caster.czss_radius
	local baseDamage2 = baseDamage + caster.czss_baseDamage
	local damage = (ll * (i+caster.czss_damage) + baseDamage2 )*shbs --没有乘以技能等级，下面再乘
	if caster:HasModifier("modifier_yxtfjn_gbs") then
		damage = damage * 2
	end
	local particle = ParticleManager:CreateParticle("particles/hero/bristle_spikey_quill_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle, 1, Vector(radius*1.8,radius*3.6,0)) -- Origin

	local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位
	if units ~= nil then
	for key, unit in pairs(units) do
		ability:ApplyDataDrivenModifier(unit,unit,modifier,{})
		local  cs = unit:FindModifierByName(modifier):GetStackCount()
		 if cs >=max then
		 	cs =max - 1
		 end
		 local damage2 = (cs * (ll*sh) + damage) *x * multiple
		 cs = cs + 1
		unit:SetModifierStackCount(modifier, unit, cs)		
		ApplyDamageEx(caster,unit,ability,damage2)	
		end
	end	

	
	local time = caster.czss_time - 1
	local time2  = 0
	TimerUtil.createTimerWithDelay(0.5,function ()
		if time2 <= time then
			time2 = time2 + 1		
			if caster:IsAlive() then	--如果单位死亡，则不继续释放技能了
				point = caster:GetAbsOrigin()
			else 
				return nil
			end
			local particle = ParticleManager:CreateParticle("particles/hero/bristle_spikey_quill_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
			ParticleManager:SetParticleControl(particle, 1, Vector(radius*1.8,radius*3.6,0)) -- Origin

			local multiple = 1
			if RollPercentage(20) then
				multiple = caster.czss_multiple +multiple
			end	
			local sound = false
			if RollPercentage(20) then
				StartSoundEventFromPosition("Hero_Bristleback.QuillSpray.Cast",point)
				sound = true
			end
			
			local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位
			if units ~= nil then
				for key, unit in pairs(units) do
					ability:ApplyDataDrivenModifier(unit,unit,modifier,{})
					 local cs = unit:FindModifierByName(modifier):GetStackCount()
					 if cs >=max then
					 	cs =max - 1
					 end
					 if sound == true then 
					 	StartSoundEventFromPosition("Hero_Bristleback.QuillSpray.Cast",unit:GetAbsOrigin())
					 end
					 local damage2 = (cs * (ll*sh) + damage) *x *multiple

					 cs = cs + 1
					unit:SetModifierStackCount(modifier, unit, cs)		
					ApplyDamageEx(caster,unit,ability,damage2)	
				end
			end		


		else 
			return nil 
		end
		return 0.5
	end)






end
