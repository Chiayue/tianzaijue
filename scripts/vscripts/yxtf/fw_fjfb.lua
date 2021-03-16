function fjfb( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local duration = ability:GetLevelSpecialValueFor("duration", level)	
	local x = 1 + level / 10
	local ll = caster:GetStrength()
	local damage = ll * i * x
	local point = caster:GetAbsOrigin()
	local units = FindEnemiesInRadiusEx(caster,point,radius)
	if units ~= nil then
		for key, unit in pairs(units) do	
			ApplyDamageEx(caster,unit,ability,damage)
		end
	end
	point = RandomPosInRadius(point,30,100)
	local unit = CreateUnitByName("fwhy", point, true, caster, nil, caster:GetTeam())
	unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	unit:SetOwner(caster)
	ability:ApplyDataDrivenModifier(caster,unit,"modifier_yxtfjn_fw",{})
	unit:AddNewModifier(unit, nil, "modifier_kill", { duration = duration })
end



function fjfb2( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local duration = ability:GetLevelSpecialValueFor("duration", level)	
	local point = target:GetAbsOrigin()
	local particleName = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_attack_blur_counterhelix.vpcf";
	local fxIndex = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( fxIndex, 0, point )
	local x = 1 + level / 10
	local ll = caster:GetStrength()
	local damage = ll * i * x
	local units = FindEnemiesInRadiusEx(caster,point,radius)
	if units ~= nil then
		for key, unit in pairs(units) do	
			ApplyDamageEx(caster,unit,ability,damage)
		end
	end
end