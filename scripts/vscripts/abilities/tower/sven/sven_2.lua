LinkLuaModifier("modifier_sven_2_buff", "abilities/tower/sven/sven_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sven_2 == nil then
	sven_2 = class({}, nil, ability_base_ai)
end
function sven_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetDuration()

	hCaster:AddNewModifier(hCaster, self, "modifier_sven_2_buff", { duration = duration })

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:EmitSound("Hero_Sven.GodsStrength")
end
---------------------------------------------------------------------
--Modifiers
if modifier_sven_2_buff == nil then
	modifier_sven_2_buff = class({}, nil, eom_modifier)
end
function modifier_sven_2_buff:OnCreated(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_gods_strength.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, 100, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, false, 100, true, false)
	end
end
function modifier_sven_2_buff:OnRefresh(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
end
function modifier_sven_2_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.damage_pct,
		[EMDF_STATUS_HEALTH_BONUS_PERCENTAGE] = self.health_pct,
	}
end
function modifier_sven_2_buff:GetPhysicalAttackBonusPercentage()
	return self.damage_pct
end
function modifier_sven_2_buff:GetStatusHealthBonusPercentage()
	return self.health_pct
end