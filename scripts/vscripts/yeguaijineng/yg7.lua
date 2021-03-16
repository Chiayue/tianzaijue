function yg7zibao( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("percent2", keys.ability:GetLevel())	
	
	local point = caster:GetAbsOrigin()
	--	FindUnitsInRadius( DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil,radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, targetType,flag, order, false)
	--在给定范围内用给定flags搜索单位( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
	--									队伍数字		坐标		nil 	搜索范围	队伍标签	单位类型   单位目标标签	搜寻类型	真假


	--local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
					--						  DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local units = FindAlliesInRadiusExdd(caster,point,radius)
	local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	--local p2 = ParticleManager:CreateParticle("particles/mjjcjn_blgj_kid/invoker_kid_forge_spirit_ambient_spawn_flames.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(p1, 0, point) -- Origin

	if units ~= nil then
		for key, unit in pairs(units) do
			damage = unit:GetHealth() * i +100
			ApplyDamageMf(caster,unit,ability,damage)
			ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)		
		end
	end	
	

end


