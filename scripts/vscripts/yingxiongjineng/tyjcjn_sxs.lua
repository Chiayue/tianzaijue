function sxs( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage =ability:GetLevelSpecialValueFor("baseDamage", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = target:GetAbsOrigin()
	local ll = caster:GetHealth() * i 
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
	if damage > 500000000 then
		damage = 500000000
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