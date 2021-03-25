function lz( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = keys.ability:GetLevelSpecialValueFor("duration", keys.ability:GetLevel() - 1)
	if caster.lz_duration == nil then
		caster.lz_duration = 0
	end
	duration =duration +caster.lz_duration
	ability:ApplyDataDrivenModifier(caster, target, "modifier_mjjcjn_lz_3", {duration=duration})

end





function lzgj(keys)
	local caster = keys.caster
	local target = keys.target
--	caster:PerformAttack(target, true, true, true, false, false, false, false)

--倒数第二个参数：bFakeAttack如果为true，则不会造成伤害
--第三个参数如果为false，则会触发OnAttack事件，但是不会触发其余的几个事件（start、land、finish），这样有些攻击命中才生效的逻辑就不会触发了
--PerformAttack(handle hTarget, bool bUseCastAttackOrb, bool bProcessProcs, bool bSkipCooldown, bool bIgnoreInvis, bool bUseProjectile, bool bFakeAttack, bool bNeverMiss)
--倒数第三个参数：bool bUseProjectile, 为投射物
	if  caster:IsAlive() then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() )
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() )
		ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
		caster:PerformAttack(target, true, true, true, false, true, false, true)

	end
end

function tsgj( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius",level)
	local point = caster:GetAbsOrigin()
	local units = FindAlliesInRadiusExdd(caster,point,radius)
	local sl = 0
	for key, unit in pairs(units) do
		if sl < 6 then
			if  caster:IsAlive() then
				sl = sl +1
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin() )
				ParticleManager:SetParticleControl(particle, 1, unit:GetAbsOrigin() )
				ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", caster:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particle)
				caster:PerformAttack(unit, true, true, true, false, true, false, true)
			end
		else
			return nil 
		end
	end
end
function tsgjadd( keys )
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mjjcjn_tsgj", {})
	
end
function hygj( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius",level)
	local point = caster:GetAbsOrigin()
	local units = FindAlliesInRadiusExdd(caster,point,radius)
	local sl = 0
	for key, unit in pairs(units) do
		if sl < 6 then
			if  caster:IsAlive() then
				sl = sl +1
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_mjjcjn_tsgj_3", {})
			end
		else
			return nil 
		end
	end
end

function wdz(keys)
	local caster = keys.caster
	local unit = keys.target
	local ability = keys.ability
	local i =ability:GetLevelSpecialValueFor("i", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local max = ability:GetLevelSpecialValueFor("max", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local level = ability:GetLevel() - 1 + caster.cas_table.grjndj
	if caster.wdz_count == nil then
		caster.wdz_count = 0
	end
	if caster.wdz_radius == nil then
		caster.wdz_radius = 0
	end

	max = level +max + caster.wdz_count
	if max >30 then
		max = 30
	end	
	local interval = duration / max
	if interval < 0.18 then
		interval =0.18
	end
	local num = 0
	local count = 0
	radius = radius + caster.wdz_radius
			local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_POINT_FOLLOW, unit)
			ParticleManager:SetParticleControlEnt(pfx1, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx1)
			local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx2, 1, unit:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx2)
			local fv = unit:GetForwardVector()
			local z = RandomInt(0,360)
			local vVelocity = RotateVector2D(fv,z) * 50
			local target_pos = unit:GetAbsOrigin() + vVelocity		
			caster:StartGesture(ACT_DOTA_ATTACK)
			caster:PerformAttack(unit, false, true, true, false, true, false, true)
			caster:SetOrigin(target_pos)
			caster:SetForwardVector(GetForwardVector(caster:GetAbsOrigin(),unit:GetAbsOrigin()))
		


	TimerUtil.createTimerWithDelay(interval,function()		
		local point2 = caster:GetAbsOrigin()	
		local units = FindUnitsInRadius(caster:GetTeamNumber(), point2, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
		if count < duration then	
			if units and #units>=1 then
				local maxhp = 0
				for key, unit2 in pairs(units) do
					if unit2:GetHealth() >maxhp and unit2:IsAlive() then
						maxhp= unit2:GetHealth()
						unit = unit2
					end
				end	
				local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_POINT_FOLLOW, unit)
				ParticleManager:SetParticleControlEnt(pfx1, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx1)
				local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(pfx2, 1, unit:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(pfx2)
				local fv = unit:GetForwardVector()
				local z = RandomInt(0,360)
				local vVelocity = RotateVector2D(fv,z) * 50
				local target_pos = unit:GetAbsOrigin() + vVelocity		
				caster:StartGesture(ACT_DOTA_ATTACK)
				caster:PerformAttack(unit, false, true, true, false, true, false, true)
				if GridNav:CanFindPath(caster:GetAbsOrigin(), target_pos) then
					caster:SetOrigin(target_pos)
					caster:SetForwardVector(GetForwardVector(caster:GetAbsOrigin(),unit:GetAbsOrigin()))	
				end
				count = count + interval
			else
				caster:RemoveModifierByName("modifier_mjjcjn_wdzzz")
				return nil
			end		
			return interval
	else
		caster:RemoveModifierByName("modifier_mjjcjn_wdzzz")
	end
	end)

end
