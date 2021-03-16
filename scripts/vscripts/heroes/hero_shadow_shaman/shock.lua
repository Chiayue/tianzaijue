
function Shock( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level )
	local targets = ability:GetLevelSpecialValueFor("targets", level )
	local baseDamage = ability:GetLevelSpecialValueFor("baseDamage", level)	
	local i = ability:GetLevelSpecialValueFor("i", level )
	local AbilityDamageType = ability:GetAbilityDamageType()
	local particleName = "particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf"

	local level = ability:GetLevel() - 1
	local x = 1 + level / 10
	if caster.cqzj_baseDamage == nil then
		caster.cqzj_baseDamage = 0
	end
	if caster.cqzj_damage == nil then
		caster.cqzj_damage = 0
	end
	if caster.cqzj_max == nil then
		caster.cqzj_max = 0
	end
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.cqzj_baseDamage
	damage = (zl * i + baseDamage2 ) * x

	targets = targets + caster.cqzj_max
	local point = target:GetAbsOrigin()
	print(caster:GetBoundingMaxs().z)
	print(target:GetBoundingMaxs().z)
	-- Make sure the main target is damaged
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z*2.5 ))	
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z *2.5))
	ApplyDamageMf(caster,target,ability,damage)
	target:EmitSound("Hero_ShadowShaman.EtherShock.Target")


end

