function jrfb( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local interval = ability:GetLevelSpecialValueFor("interval", level)	
	local duration = ability:GetLevelSpecialValueFor("duration", level)	
	local radius = ability:GetLevelSpecialValueFor("radius", level)	
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local ll = caster:GetAgility()
	local point = caster:GetAbsOrigin()


	if caster.jrfb_radius == nil then
	caster.jrfb_radius = 0
	end
	if caster.jrfb_duration == nil then
		caster.jrfb_duration = 0
	end
	if caster.jrfb_interval == nil then
		caster.jrfb_interval = 0
	end

	if caster.jrfb_baseDamage == nil then
		caster.jrfb_baseDamage = 0
	end
	if caster.jrfb_damage == nil then
		caster.jrfb_damage = 0
	end
	if caster.jrfb_multiple == nil then
		caster.jrfb_multiple = 0
	end
	duration = duration + caster.jrfb_duration
	interval = interval - caster.jrfb_interval

	if interval <0.2 then	--伤害间隔最低为0.2
		interval = 0.2
	end
	radius = radius + caster.jrfb_radius
	i = i + caster.jrfb_damage
	local baseDamage2 = baseDamage + caster.jrfb_baseDamage
	local damage = (ll * i + baseDamage2 ) * x  * shbs
	local sound = StartSoundEvent("Greevil.BladeFuryStart",caster)

	local particle = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_crimson_blade_fury_abyssal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl( particle, 5, Vector(radius,0,0) )
			--ability:ApplyDataDrivenModifier(caster,caster,"modifier_mjjcjn_jrfb1_2",nil)
	TimerUtil.createTimer(function ()
		if duration > 0 then
			point = caster:GetAbsOrigin()
			local multiple = 1
			if RollPercentage(20) then
				multiple = caster.jrfb_multiple + multiple
			end	
			local damage2 = damage * multiple
			DamageEnemiesWithinRadius(point,radius,caster,damage2)
			--ability:ApplyDataDrivenModifier(caster,caster,"modifier_mjjcjn_jrfb1_2",{duration=interval})
			duration = duration - interval
			return interval
		else --打击结束以后，销毁雷云特效(这个特效并不会自动消失)。如果可以触发多重效果，就触发
			ParticleManager:DestroyParticle(particle,true)
			StopSoundEvent("Greevil.BladeFuryStart",caster)
			return nil
		--	caster:RemoveModifierByName("modifier_mjjcjn_jrfb1_2")
		end
	end)



end




