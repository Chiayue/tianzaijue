function yg30yslt(keys)
	local caster = keys.caster
	local ability = keys.ability
	

	local bouns = keys.ability:GetLevelSpecialValueFor( "bouns", ability:GetLevel() - 1 ) or 0--s获取伤害
	local radius = keys.ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 ) or 0--s获取伤害
	local hf = keys.ability:GetLevelSpecialValueFor( "hf", ability:GetLevel() - 1 ) or 0--s获取伤害
	local h = caster:GetBaseMaxHealth()
	local hh = h * hf
	local point = caster:GetAbsOrigin()
--	print(point)
--	local i = 0
--	 local p1 = ParticleManager:CreateParticle("particles/econ/items/viper/viper_immortal_tail_ti8/viper_immortal_ti8_nethertoxin.vpcf",PATTACH_CUSTOMORIGIN,nil)
 --   ParticleManager:SetParticleControl( p1, 0, point )

		local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS, point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		
	--	local b = unit:GetBaseDamageMin + caster:GetBaseDamageMin 
	--	local c = unit:GetPhysicalArmorBaseValue + caster:GetPhysicalArmorBaseValue * bouns
		
		for key, unit in pairs(units) do
			local d = unit:GetBaseMaxHealth() + h * bouns
			local a = unit:GetBaseDamageMax() + caster:GetBaseDamageMax() * bouns 	
			local b = unit:GetBaseDamageMin() + caster:GetBaseDamageMin() * bouns			
			unit:SetBaseMaxHealth(d)	
			unit:SetBaseDamageMax(a)
			unit:SetBaseDamageMin(b)
			unit:Heal(hh , caster)
		
	--	unit:SetBaseDamageMax(a)	
	--	unit:SetBaseDamageMin(b)
	--	unit:SetPhysicalArmorBaseValue(c)					

		end
		
end


					