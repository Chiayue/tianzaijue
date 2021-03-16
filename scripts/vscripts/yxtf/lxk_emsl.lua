function emsl( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local zl = caster:GetIntellect()
	local point = caster:GetAbsOrigin()
	
	local is_ability = false
	for i=0, 4 do
		local current_ability = caster:GetAbilityByIndex(i)
		local name = current_ability:GetAbilityName()
		local name2 = string.sub(name,1,3)
		if name2 ~= "kjn" and  name2 ~= "yxt" and name2 ~= "abi" then
			local cd = current_ability:GetCooldownTimeRemaining()		
			local full_cd = current_ability:GetCooldown(level)		--无法获得经过冷却缩减的技能CD，还是有BUG存在
			if cd > 0 and full_cd - cd < 0.04 then 
				is_ability = true
				local path = "particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf"
				local pid =  CreateParticleEx(path,PATTACH_OVERHEAD_FOLLOW,caster,1)
				SetParticleControlEx( pid, 1, caster:GetAbsOrigin())
			end
		end
	end
	if is_ability == true then
		local units = FindEnemiesInRadiusEx(caster,point,radius)
		if units ~= nil then
			for key, unit in pairs(units) do
				damage = zl * i	
				ApplyDamageMf(caster,unit,ability,damage)
				ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
			end
		end
	end
end

