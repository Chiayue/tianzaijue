function smbf( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage =ability:GetLevelSpecialValueFor("baseDamage", level)	
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local bfb = ability:GetLevelSpecialValueFor("bfb", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = caster:GetAbsOrigin()
	local ll = caster:GetHealth() *bfb / 100
	if caster.smbf_baseDamage == nil then
		caster.smbf_baseDamage = 0
	end
	if caster.smbf_damage == nil then
		caster.smbf_damage = 0
	end
	if caster.smbf_multiple == nil then
		caster.smbf_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.smbf_multiple + multiple
	end	  
	local baseDamage2 = baseDamage + caster.smbf_baseDamage
	local damage = (ll * (i+caster.smbf_damage) + baseDamage2 ) * x * multiple
	caster:SetHealth(ll)
	local fxIndex2 = ParticleManager:CreateParticle("particles/test/smbf2.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
	ParticleManager:SetParticleControl( fxIndex2, 0, point )
	ParticleManager:SetParticleControl( fxIndex2, 2, Vector(0.1,0,0.1) )
	StartSoundEventFromPosition("Hero_LifeStealer.Assimilate.Destroy",point)
	TimerUtil.createTimerWithDelay(0.1,function ()
	local fxIndex = ParticleManager:CreateParticle("particles/test/smbf.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( fxIndex, 0, point )
	
	local fxIndex3 = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( fxIndex3, 0, point )
	local units = FindAlliesInRadiusExdd(caster,point,radius)
	if units ~= nil then
	for key, unit in pairs(units) do
		ApplyDamageMf(caster,unit,ability,damage)	
		end
	end	

 	end)
end







