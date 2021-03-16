
function fbzy( keys )
	
	local caster = keys.caster
	local point =caster:GetAbsOrigin()
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local i = ability:GetLevelSpecialValueFor("i", level)
	local damage = caster:GetAverageTrueAttackDamage(caster) * i * (1+level / 5)
	local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位

	if units then
		for key, unit in pairs(units) do
		local particle = ParticleManager:CreateParticle("particles/test/dgrazor_loadout.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 0, point) -- Origin
		ParticleManager:SetParticleControl(particle, 1, unit:GetAbsOrigin()) -- Origin
		ability:ApplyDataDrivenModifier(caster,unit,"modifier_yxtfjn_td_2",{})
		ApplyDamageEx(caster,unit,ability,damage)	
		end
	end
	

end


