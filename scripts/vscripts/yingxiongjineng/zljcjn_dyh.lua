--[[Author: YOLOSPAGHETTI
	Date: March 15, 2016
	Creates the death ward]]
function dyh(keys)
	local caster = keys.caster
	local ability = keys.ability
	local position = ability:GetCursorPosition()	
	local level = ability:GetLevel() - 1
	local radius =  keys.ability:GetLevelSpecialValueFor("radius", level)
	if caster.dyh_max == nil then
		caster.dyh_max = 0
	end
	local num = math.ceil((1 +caster.dyh_max)* caster.cas_table.zhwslbs)
	local shzj = 1
	local shjs = 1
	if num > 1 then
		shzj = 1+(num-1)
		shjs = 1+(num-1)
		num = 1
	end

	TimerUtil.createTimerWithDelay(0.1,function()
	EmitSoundOnLocationWithCaster( position, "Hero_Invoker.ChaosMeteor.Impact", caster )
	local particleID2 = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf",PATTACH_WORLDORIGIN,nil)--
	ParticleManager:SetParticleControl(particleID2,0,position)
	 
	 TimerUtil.createTimerWithDelay(0.05,function()
	 	local particle_main_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_main_fx, 0, position)
		ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_main_fx)
		CreateDyh(caster,ability,position,shzj,shjs)
		end
		)
	end
	)	
	



end

function CreateDyh(caster,ability,position,ewsh,ewxl)
	if not caster:IsAlive() then
		if ability then
			ability:EndCooldown()
		end
	end
	if caster:HasModifier("modifier_zljcjn_dyh1_5") == false then	--如果在召唤途中，删了技能就不执行操作
		return nil
	end
	local level = ability:GetLevel() - 1
	local duration =ability:GetLevelSpecialValueFor("duration", level)
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local max = ability:GetLevelSpecialValueFor("max", level)			
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local radius =  ability:GetLevelSpecialValueFor("radius", level)
	local lv =ability:GetLevelSpecialValueFor("lv", level)
	local shbs =ability:GetLevelSpecialValueFor("shbs", level)
	local dummys = caster.dyhunits	--记录召唤的单位，方便删除技能后一起删除
	if not dummys then
		dummys = {}
		caster.dyhunits = dummys
	end

	if caster:HasModifier("modifier_yxtfjn_shushi") then
		local gl = math.ceil(50+caster:GetLevel()/4)
		if RollPercent(gl) then
			shbs = shbs * 1.4
			if lv == 3 then
				lv = 6
			elseif lv == 1 then
				lv = 3
			end
		end
	end
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local unit = CreateUnitByName("diyuhuo_"..lv, position, true, caster, nil, caster:GetTeam())
	unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	unit:SetOwner(caster)

	local mj = caster:GetAgility()

	local sx = 0
	if EntityHelper.IsStrengthHero(caster) then
		 sx = caster:GetStrength()
	else
	if EntityHelper.IsAgilityHero(caster)then
		 sx = caster:GetAgility()
	else
		 sx = caster:GetIntellect()
	end
	end
	if caster.dyh_baseDamage == nil then
		caster.dyh_baseDamage = 0
	end
	if caster.dyh_damage == nil then
		caster.dyh_damage = 0
	end
	i = i + caster.dyh_damage
	if caster.dyh_duration == nil then
		caster.dyh_duration = 0
	end
	duration = duration + caster.dyh_duration
	local baseDamage2 = baseDamage + caster.dyh_baseDamage
	local damage = (sx * i + baseDamage2 ) * x  * ((caster.cas_table["zhwsh"]+100)/100)  * shbs*ewsh *(1+caster.cas_table.zzsh/100) *(1+caster.cas_table.fjsh/100)
	local bjj = math.ceil(caster.cas_table.mfbjgl)
	if bjj >100 then
		bjj = 100
	end
	if bjj < 0 then
		bjj= 0
	end
	if RollPercent(bjj) then
		damage=damage*(1+caster.cas_table.mfbjsh/100)
	end
	if caster.dyh_multiple == nil then
		caster.dyh_multiple = 0
	end
	local hj = caster:GetPhysicalArmorValue(false)*x * shbs * ((caster.cas_table["zhwsh"]+100)/100)
	if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
		damage = damage * (caster.dyh_multiple + 1 )
		hj = hj * (caster.dyh_multiple + 1 )
	end	
	if damage > 100000000 then
		unit.shzj = damage / 100000000
		damage = 100000000
	end
	unit:SetBaseDamageMax(damage)
	unit:SetBaseDamageMin(damage)
	mj = math.ceil(mj/50)+((x-1)*100)--暂时每50点敏捷提升一点攻击速度,每提升一级增加十点攻击速度
	local hp3 = caster:GetMaxHealth()* 2.2 * ewxl * (1+caster.cas_table.shjm/100)
	if hp3 > 100000000 then
		unit.shjs = hp3 / 100000000
		hp3 = 100000000
	end
	unit:SetBaseMaxHealth(hp3)
	unit:SetPhysicalArmorBaseValue(hj)
	local mk = hj*0.06/(1+hj*0.06)*100    	--设置BOSS的魔抗
	unit:SetBaseMagicalResistanceValue(mk)
	-- Applies the modifier (gives it damage, removes health bar, and makes it invulnerable)
	ability:ApplyDataDrivenModifier( caster, unit, "modifier_zljcjn_dyh1", {duration = duration} )
	unit:AddNewModifier(unit, ability, "modifier_kill", { duration = duration })

	ability:ApplyDataDrivenModifier( caster, unit, "modifier_zljcjn_dyh1_2", {} )
	ability:ApplyDataDrivenModifier( caster, unit, "modifier_zljcjn_dyh1_4", {} )
	unit:SetModifierStackCount("modifier_zljcjn_dyh1_2", ability, mj)
	table.insert(dummys,unit)

	local units = FindAlliesInRadiusExdd(caster,position,radius)	
	for key, unit in pairs(units) do
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_zljcjn_dyh1_3", {})
		ApplyDamageMf(caster,unit,ability,damage2)	
	end

end


function dyhxj( keys )
	local caster = keys.caster
	if caster:HasModifier("modifier_zljcjn_dyh1_5") == false then	--如果在召唤途中，删了技能就不执行操作
		return nil
	end
	local target = keys.target
	local ability =keys.ability
	local level = ability:GetLevel() - 1
	local bfb =  ability:GetLevelSpecialValueFor("bfb", level)
	local radius =  ability:GetLevelSpecialValueFor("radius2", level)
	local interval =  ability:GetLevelSpecialValueFor("interval", level)
	local shbs =ability:GetLevelSpecialValueFor("shbs", level)


	local damage = target:GetBaseMaxHealth()*bfb * ((caster.cas_table["zhwsh"]+100)/100) * shbs

	
	local units = FindAlliesInRadiusExdd(caster,target:GetAbsOrigin(),radius)	
	for key, unit in pairs(units) do

		ApplyDamageMf(target,unit,ability,damage)	
	end

end










