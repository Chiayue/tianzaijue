function jxtm( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius",level)
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local duration = ability:GetLevelSpecialValueFor("duration", level)	
	local interval = ability:GetLevelSpecialValueFor("interval", level)	
	local ll = caster:GetAgility()
	local point = caster:GetAbsOrigin()
	local damage = ll * i 
	local particle = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal_golden.vpcf", PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl( particle, 5, Vector(radius,0,0) )	
	local time =  0 
	TimerUtil.createTimerWithDelay(0,function()
		if time <= duration then
			time = time +interval
			local units = FindEnemiesInRadiusEx(caster,point,radius)
			if units ~= nil then
				for key, unit in pairs(units) do
					ApplyDamageEx(caster,unit,ability,damage)
				end	
			end
			return interval
		else
			ParticleManager:DestroyParticle(particle,true)
		end
	end)

end
