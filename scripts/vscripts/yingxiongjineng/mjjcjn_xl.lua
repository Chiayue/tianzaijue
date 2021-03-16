function xl( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	
	
	if caster.xl_baseDamage == nil then
		caster.xl_baseDamage = 0
	end
	if caster.xl_damage == nil then
		caster.xl_damage = 0
	end

	local mj = caster:GetAgility()
	local baseDamage2 = baseDamage + caster.xl_baseDamage
	i = i + caster.xl_damage
	damage = (mj * i + baseDamage2 ) * x
	--	FindUnitsInRadius( DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil,radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, targetType,flag, order, false)
	--在给定范围内用给定flags搜索单位( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
	--									队伍数字		坐标		nil 	搜索范围	队伍标签	单位类型   单位目标标签	搜寻类型	真假


	--local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
					--						  DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		
		ApplyDamageEx(caster,target,ability,damage)
	
		


end


