LinkLuaModifier("modifier_brewmaster_windspirit_3_aura", "abilities/tower/brewmaster_windspirit/brewmaster_windspirit_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brewmaster_windspirit_3", "abilities/tower/brewmaster_windspirit/brewmaster_windspirit_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brewmaster_windspirit_3_buff", "abilities/tower/brewmaster_windspirit/brewmaster_windspirit_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if brewmaster_windspirit_3 == nil then
	brewmaster_windspirit_3 = class({})
end
function brewmaster_windspirit_3:GetIntrinsicModifierName()
	return "modifier_brewmaster_windspirit_3_aura"
end
---------------------------------------------------------------------
--Modifiers
if modifier_brewmaster_windspirit_3_aura == nil then
	modifier_brewmaster_windspirit_3_aura = class({}, nil, ModifierHidden)
end
function modifier_brewmaster_windspirit_3_aura:IsAura()
	return true
end
function modifier_brewmaster_windspirit_3_aura:GetAuraRadius()
	return self.radius
end
function modifier_brewmaster_windspirit_3_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_brewmaster_windspirit_3_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_brewmaster_windspirit_3_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_brewmaster_windspirit_3_aura:GetModifierAura()
	return "modifier_brewmaster_windspirit_3"
end
function modifier_brewmaster_windspirit_3_aura:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
---------------------------------------------------------------------
if modifier_brewmaster_windspirit_3 == nil then
	modifier_brewmaster_windspirit_3 = class({}, nil, eom_modifier)
end
function modifier_brewmaster_windspirit_3:OnCreated(params)
	self.mana_regen_bonus	= self:GetAbilitySpecialValueFor("mana_regen_bonus")
end
function modifier_brewmaster_windspirit_3:EDeclareFunctions()
	return {
		[EMDF_MANA_REGEN_BONUS] = self.mana_regen_bonus,
	}
end
function modifier_brewmaster_windspirit_3:GetManaRegenBonus()
	return self.mana_regen_bonus
end
function modifier_brewmaster_windspirit_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_brewmaster_windspirit_3:OnTooltip()
	return self.mana_regen_bonus
end
---------------------------------------------------------------------
--Modifiers
if modifier_brewmaster_windspirit_3_buff == nil then
	modifier_brewmaster_windspirit_3_buff = class({}, nil, BaseModifier)
end
function modifier_brewmaster_windspirit_3_buff:OnCreated(params)
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	if IsServer() then
		self:SetDuration(self:GetAbility():GetDuration(), true)
	end
end
function modifier_brewmaster_windspirit_3_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_brewmaster_windspirit_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_brewmaster_windspirit_3_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attackspeed
end
function modifier_brewmaster_windspirit_3_buff:OnTooltip()
	return self.bonus_attackspeed
end