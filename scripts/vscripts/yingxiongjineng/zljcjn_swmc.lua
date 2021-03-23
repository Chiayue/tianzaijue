function swmc( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)
	local ii = ability:GetLevelSpecialValueFor("ii", level)	
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local baseHeal = ability:GetLevelSpecialValueFor("baseHeal", level)	
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	if caster.swmc_baseDamage == nil then
		caster.swmc_baseDamage = 0
	end
	if caster.swmc_damage == nil then
		caster.swmc_damage = 0
	end
	if caster.swmc_heal == nil then
		caster.swmc_heal = 0
	end
	if caster.swmc_baseHeal == nil then
		caster.swmc_baseHeal = 0
	end

	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.swmc_baseDamage
	local baseHeal2 = baseHeal + caster.swmc_baseHeal
	i = i + caster.swmc_damage
	ii= ii + caster.swmc_heal
	local damage = (zl * i + baseDamage2 ) * x * shbs
	local heal = (zl * ii + baseHeal2 ) * x * shbs
	if caster.swmc_multiple == nil then
		caster.swmc_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
			multiple = multiple +  caster.swmc_multiple
	end	
	damage = damage * multiple
	heal = heal * multiple
	if heal > 100000000 then
		heal = 100000000
	end
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		
	
		ApplyDamageMf(caster,target,ability,damage)
		ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	else
		
		target:Heal(heal,caster)
		ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,heal)
	end

end


