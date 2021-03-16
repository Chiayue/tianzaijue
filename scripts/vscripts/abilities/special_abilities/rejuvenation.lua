LinkLuaModifier("modifier_rejuvenation", "abilities/special_abilities/rejuvenation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rejuvenation_buff", "abilities/special_abilities/rejuvenation.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if rejuvenation == nil then
	rejuvenation = class({})
end
function rejuvenation:GetIntrinsicModifierName()
	return "modifier_rejuvenation"
end
---------------------------------------------------------------------
--Modifiers
if modifier_rejuvenation == nil then
	modifier_rejuvenation = class({})
end
function modifier_rejuvenation:IsAura()
	return true
end
function modifier_rejuvenation:GetAuraDuration()
	return 0.5
end
function modifier_rejuvenation:GetAuraRadius()
	return self.radius
end
function modifier_rejuvenation:GetModifierAura()
	return "modifier_rejuvenation_buff"
end
function modifier_rejuvenation:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_rejuvenation:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_rejuvenation:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_rejuvenation:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_rejuvenation:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_rejuvenation:OnDestroy()
	if IsServer() then
	end
end

------------------------------------------------------------------------------
if modifier_rejuvenation_buff == nil then
	modifier_rejuvenation_buff = class({}, nil, eom_modifier)
end
function modifier_rejuvenation_buff:OnCreated(params)
	self.health_regen_bonus = self:GetAbilitySpecialValueFor("health_regen_bonus")
end
function modifier_rejuvenation_buff:OnRefresh(params)
	self.health_regen_bonus = self:GetAbilitySpecialValueFor("health_regen_bonus")
end
function modifier_rejuvenation_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end
function modifier_rejuvenation_buff:GetModifierConstantHealthRegen()
	return self.health_regen_bonus
end