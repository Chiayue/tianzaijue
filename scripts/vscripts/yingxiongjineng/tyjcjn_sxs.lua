function sxs( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage =ability:GetLevelSpecialValueFor("baseDamage", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local shbs = ability:GetLevelSpecialValueFor("shbs", level)
	local point = target:GetAbsOrigin()
	if caster.sxs_baseDamage == nil then
		caster.sxs_baseDamage = 0
	end
	if caster.sxs_damage == nil then
		caster.sxs_damage = 0
	end
	local ll = caster:GetHealth() * (i+caster.sxs_damage)
	if caster.sxs_multiple == nil then
		caster.sxs_multiple = 0
	end
	local multiple = 1
	if RollPercentage(50) then
		multiple = caster.sxs_multiple + multiple
	end	  
	local baseDamage2 = baseDamage + caster.sxs_baseDamage
	local damage = (ll +  baseDamage2 ) * x * multiple * shbs
	if caster:GetPrimaryAttribute() == 0 then
		damage = damage *1.5
	end
	local fxIndex3 = ParticleManager:CreateParticle("particles/test/sxsbx.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( fxIndex3, 0, point )
	ApplyDamageMf(caster,target,ability,damage)	
	
end







function sxs2(keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local bfb = ability:GetLevelSpecialValueFor("bfb", level)
	local ll = caster:GetHealth() *bfb / 100 
	local xl = caster:GetHealth() - caster:GetHealth() *bfb / 100
	caster:SetHealth(xl)
end