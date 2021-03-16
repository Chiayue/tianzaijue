function cr( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)*1
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end


function jl( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)*2.5
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end



function lhsd( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)*2
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end





function cc( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)*2
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end


function flzj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)*0.7
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end


function sb(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel() - 1)
	local damage = caster:GetAverageTrueAttackDamage(caster) *0.35
	local vPos =ability:GetCursorPosition()
	local point = keys.caster:GetAbsOrigin()
	local direction = (vPos-point ):Normalized()
	local duration = 3
	TimerUtil.createTimer(function ()
		if duration > 0 then
			for i=1,4 do
				local avalanche = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN,caster)
				ParticleManager:SetParticleControl(avalanche, 0, vPos)
				ParticleManager:SetParticleControl(avalanche, 1, Vector(radius, 1,250))	
				ParticleManager:SetParticleControlForward( avalanche, 0, direction )
				TimerUtil.createTimerWithDelay(0.2, function()
						ParticleManager:DestroyParticle(avalanche, false)
					--	ParticleManager:ReleaseParticleIndex(avalanche)
					end)
			end
		local units = FindAlliesInRadiusExdd(caster, vPos,radius)
			for key,unit in ipairs(units) do
				ApplyDamageMf(caster,unit,ability,damage)
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_yw_boss_sb", {duration = 0.1})
			end			
			duration = duration - 0.4
			return 0.4
		 end
	end)
end



function qqwk( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)*0.5
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end


function yrsj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)* 6
	
	ApplyDamageEx(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end


function shzj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)* 2.5
	
	ApplyDamageEx(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end


function swmc( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)* 1.5
	
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		
	
		ApplyDamageMf(caster,target,ability,damage)
		ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	else
		
		target:Heal(damage,caster)
	--	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	end
	   		

end


function jxgh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)* 0.12
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	---ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end

function yys( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)* 0.6
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end

function lhz( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)* 0.2
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end


function fspf( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)* 0.5
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end

function dxgj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)* 0.5
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end



function ymbh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)* 3
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end




function bsxx(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local damage = caster:GetAverageTrueAttackDamage(caster) * 2
	local point = keys.target_points[1]
	local units = FindAlliesInRadiusExdd(caster, point,radius)
	for key,unit in ipairs(units) do
		ApplyDamageMf(caster,unit,ability,damage)
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_crystal_nova_slow_datadriven", {})
	end			

end


function bsjz(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster) * 0.5

	ApplyDamageMf(caster,target,ability,damage)
			

end




function sszg(keys)
	local caster = keys.caster
	local ability = keys.ability	
	if not ability:IsCooldownReady() then
		return nil
	end
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability:GetLevel() - 1)

	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local damage = caster:GetAverageTrueAttackDamage(caster) /2
	local heal = damage * 2
	local point =caster:GetAbsOrigin()
	local units = FindAlliesInRadiusEx(caster, point,radius)
	for key,unit in ipairs(units) do
		local avalanche = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_CUSTOMORIGIN,unit)
		ParticleManager:SetParticleControl(avalanche, 0, unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(avalanche, 1,Vector(300,300,300))
		unit:Heal(heal,caster)
		local units2 = FindAlliesInRadiusExdd(caster, unit:GetAbsOrigin(),300)
		for key,unit2 in ipairs(units2) do
			ApplyDamageMf(caster,unit2,ability,damage)
		end
	end			
	ability:StartCooldown(cooldown)

end



function lzwk( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	if not ability or not caster then
		return nil
	end
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level) 
	local ion_particle = keys.ion_particle
	local damage = caster:GetAverageTrueAttackDamage(caster) * 5

	local units = FindAlliesInRadiusExdd(caster, target_location,radius)
	for key,unit in ipairs(units) do
		if unit ~= target then
			local particle = ParticleManager:CreateParticle(ion_particle, PATTACH_POINT_FOLLOW, unit) 
			ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true) 
			ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)
			ApplyDamageMf(caster,unit,ability,damage)
		end
	end
end



function dmcj(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local damage = caster:GetAverageTrueAttackDamage(caster) * 0.5
	local point =caster:GetAbsOrigin()
	local units = FindAlliesInRadiusExdd(caster, point,radius)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_shrapnel.vpcf", PATTACH_POINT_FOLLOW, caster) 
	ParticleManager:SetParticleControl(particle, 0, point)
	if units and #units >0 then
		ParticleManager:SetParticleControl(particle, 1, units[1]:GetAbsOrigin())
		ability:ApplyDataDrivenModifier(caster, units[1], "modifier_yw_boss_dmcj_2", {duration = 0.2})
		ApplyDamageMf(caster,units[1],ability,damage)
		
	else
		ParticleManager:SetParticleControl(particle, 1, Vector(point.x+RandomInt(-radius,radius),point.y+RandomInt(-radius,radius),point.z))	
	end			

end
