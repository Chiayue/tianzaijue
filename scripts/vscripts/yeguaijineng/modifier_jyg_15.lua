
modifier_jyg_15 = class({})
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function modifier_jyg_15:OnCreated( kv )
	
	self:OnRefresh()
end

function modifier_jyg_15:GetEffectName()
	return "particles/gh/aura_assault.vpcf"
end
function modifier_jyg_15:OnRefresh()
	
end


function modifier_jyg_15:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_jyg_15:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_jyg_15:GetModifierAura()
	return "modifier_jyg_15_buff"
end

--------------------------------------------------------------------------------

function modifier_jyg_15:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_jyg_15:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_jyg_15:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_jyg_15:GetAuraRadius()
	return 800
end
