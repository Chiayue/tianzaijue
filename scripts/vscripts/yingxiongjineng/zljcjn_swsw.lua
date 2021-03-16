function swsw( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local point = target:GetAbsOrigin()

	if caster.hpq_baseDamage == nil then
		caster.hpq_baseDamage = 0
	end
	if caster.hpq_damage == nil then
		caster.hpq_damage = 0
	end

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
	local baseDamage2 = baseDamage + caster.hpq_baseDamage
	local damage = (sx * i + baseDamage2 ) * x
	local damage2= damage
	
	if caster.hpq_time == nil then
		caster.hpq_time = 0
	end
	if caster.hpq_multiple == nil then
		caster.hpq_multiple = 0
	end
	if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
			damage2 = damage * (caster.hpq_multiple + 1 )
	end	
	
	ApplyDamageEx(caster,target,ability,damage2)	

	

end


