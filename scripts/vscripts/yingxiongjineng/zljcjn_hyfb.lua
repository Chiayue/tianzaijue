function hyfb( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
		local level = ability:GetLevel() - 1
	local i = keys.ability:GetLevelSpecialValueFor("i", level)	
	local radius = keys.ability:GetLevelSpecialValueFor("radius", level)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	local duration = keys.ability:GetLevelSpecialValueFor("duration", level)
	local point = ability:GetCursorPosition()

	local x = 1 + (level+caster.cas_table.grjndj) / 10

	
	if caster.hyfb_baseDamage == nil then
		caster.hyfb_baseDamage = 0
	end
	if caster.hyfb_damage == nil then
		caster.hyfb_damage = 0
	end
	if caster.hyfb_duration == nil then
		caster.hyfb_duration = 0
	end
	if caster.hyfb_multiple == nil then
		caster.hyfb_multiple = 0
	end
	duration =duration + caster.hyfb_duration
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.hyfb_baseDamage
	i = i + caster.hyfb_damage
	local count =0
	local damage = (zl * i + baseDamage2 ) * x
	if damage > 500000000 then
		damage = 500000000
	end
	TimerUtil.createTimerWithDelay(0.5,function()
		if count < 5 then
			StartSoundEventFromPosition("Hero_Jakiro.LiquidFire",point)
			-- 控制点0控制落冰点，控制点1控制落冰起始点。
		for var=0,  5 do
		local iceAttackPoint = FindRandomPoint(point,radius)
		local particleName = "particles/test/abyssal_underlord_firestorm_wave.vpcf";
		local fxIndex = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( fxIndex, 0, iceAttackPoint )
		end
		local multiple = 1
		if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
				multiple = multiple +  caster.hyfb_multiple
		end	
		local damage2 = damage * multiple
			--寻找实体周围的unit
			local units = FindAlliesInRadiusExdd(caster,point,radius)
			if units~=nil then
				for key, unit in pairs(units) do
					ability:ApplyDataDrivenModifier(caster, unit, "modifier_zljcjn_hyfb1", {duration=duration})	
					ApplyDamageMf(caster,unit,ability,damage)
				end
			end
			count = count + 1
			return 1
		end
	end)

end


function hyfbsh(keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = keys.ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local zl = caster:GetIntellect()
	if caster.hyfb_multiple == nil then
		caster.hyfb_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
		multiple = multiple +  caster.hyfb_multiple
	end	
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.hyfb_baseDamage
	i = i + caster.hyfb_damage
	local count =0
	local damage = (zl * i + baseDamage2 ) * x /2  * multiple
	if damage > 500000000 then
		damage = 500000000
	end
	ApplyDamageMf(caster,target,ability,damage)
	
end


