function jxgh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

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
	

	if caster.jxgh_baseDamage == nil then
		caster.jxgh_baseDamage = 0
	end
	if caster.jxgh_damage == nil then
		caster.jxgh_damage = 0
	end
	i = i + caster.jxgh_damage
	local baseDamage2 = baseDamage + caster.jxgh_baseDamage
	local damage = (sx * i + baseDamage2 ) * x * shbs
	if caster.jxgh_multiple == nil then
		caster.jxgh_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then	--百分之二十的概率触发暴击伤害
			multiple = multiple +  caster.jxgh_multiple
	end	
	damage = damage * multiple		
	if damage > 500000000 then
		damage = 500000000
	end
		
	ApplyDamageMf(caster,target,ability,damage)
		


end


