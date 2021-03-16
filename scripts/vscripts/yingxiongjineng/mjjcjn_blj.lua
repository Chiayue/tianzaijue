function fs( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local ll = caster:GetAgility()
	local point = target:GetAbsOrigin()
	if caster.fs_baseDamage == nil then
		caster.fs_baseDamage = 0
	end
	if caster.fs_damage == nil then
		caster.fs_damage = 0
	end
	i = i + caster.fs_damage
	local baseDamage2 = baseDamage + caster.fs_baseDamage
	damage = (ll * i + baseDamage2 ) * x
	--	FindUnitsInRadius( DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil,radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, targetType,flag, order, false)
	--在给定范围内用给定flags搜索单位( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
	--									队伍数字		坐标		nil 	搜索范围	队伍标签	单位类型   单位目标标签	搜寻类型	真假


	--local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
					--						  DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- Destination
	ParticleManager:SetParticleControl(particle, 5, target:GetAbsOrigin()) -- Hit Glow				
	

	local units = FindAlliesInRadiusEx(target,point,radius)
	
--	if unit ~= nil
	for key, unit in pairs(units) do
	
		
		ApplyDamageEx(caster,unit,ability,damage)
		ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
		

		end
--	end	
	

end


