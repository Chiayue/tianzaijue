function zygb( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel() - 1)
	local baseHeal = keys.ability:GetLevelSpecialValueFor("baseHeal", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = caster:GetAbsOrigin()
    local particle_projectile = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf"

    local target = caster
  	local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
	local maxhealth = 0
	local health = caster:GetHealthPercent()
	for key,unit in pairs(units) do	
		if unit ~= nil then
		if unit ~= caster then
			maxhealth = unit:GetHealthPercent()
			if maxhealth < health then
				health = maxhealth
				target = unit	
			end

		end
		end
	end

	
	if target ~= caster then
	local concussive_projectile
	concussive_projectile = {Target = target,
							  Source = caster,
							  Ability = ability,
							  EffectName = particle_projectile,
							  iMoveSpeed = 1600,
							  bDodgeable = true, 
							  bVisibleToEnemies = true,
							  bReplaceExisting = false,
							  bProvidesVision = true,
							  iVisionRadius = radius,
							  iVisionTeamNumber = caster:GetTeamNumber(),
						--	  ExtraData = {bounces_left = bounces_left, primary_concussive = primary, bShouldBounce = bShouldBounce}
	}

	ProjectileManager:CreateTrackingProjectile(concussive_projectile)  

	else
	local zl = caster:GetIntellect()

	if caster.zlsw_baseHeal == nil then
		caster.zlsw_baseHeal = 0
	end
	if caster.zlsw_heal == nil then
		caster.zlsw_heal = 0
	end
	local baseHeal2 = baseHeal + caster.zlsw_baseHeal
	heal = (zl * (i+caster.zlsw_heal) + baseHeal2 ) * x

	target:Heal(heal, caster)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot_failure.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- Origin
	end

end


function zl(keys)
	local caster = keys.caster
	local target= keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseHeal = keys.ability:GetLevelSpecialValueFor("baseHeal", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local zl = caster:GetIntellect()

	if caster.zlsw_baseHeal == nil then
		caster.zlsw_baseHeal = 0
	end
	if caster.zlsw_heal == nil then
		caster.zlsw_heal = 0
	end
	local baseHeal2 = baseHeal + caster.zlsw_baseHeal
	heal = (zl * (i+caster.zlsw_heal) + baseHeal2 ) * x
	target:Heal(heal, caster)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot_failure.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin()) -- Origin
end
	
		
	--	ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,heal)