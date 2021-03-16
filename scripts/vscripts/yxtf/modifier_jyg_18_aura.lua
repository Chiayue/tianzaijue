modifier_jyg_18_aura = class({})

--------------------------------------------------------------------------------

function modifier_jyg_18_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_jyg_18_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_jyg_18_aura:GetModifierAura()
	return "modifier_jyg_18"
end

--------------------------------------------------------------------------------

function modifier_jyg_18_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_jyg_18_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_jyg_18_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_jyg_18_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_jyg_18_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_jyg_18_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------