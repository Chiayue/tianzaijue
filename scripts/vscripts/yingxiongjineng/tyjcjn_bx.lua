function bx( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local base = keys.ability:GetLevelSpecialValueFor("base", keys.ability:GetLevel() - 1)
	local level = ability:GetLevel() - 1
	
	local h = caster:GetBaseMaxHealth() * (base + level) / 100
	--local cold_embrace_start_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_POINT, caster);
		--	ParticleManager:SetParticleControl(cold_embrace_start_particle, 0, caster:GetAbsOrigin());
	
	caster:Heal(h,caster)

end


