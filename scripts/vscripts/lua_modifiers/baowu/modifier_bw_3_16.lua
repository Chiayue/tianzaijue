
modifier_bw_3_16 = class({})
LinkLuaModifier( "modifier_bw_3_16_buff", "lua_modifiers/baowu/modifier_bw_3_16_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_3_16:GetTexture()
	return "item_treasure/强袭胸甲"
end
--------------------------------------------------------------------------------

function modifier_bw_3_16:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_16:OnRefresh()
	
end


function modifier_bw_3_16:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_3_16:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_3_16:GetModifierAura()
	return "modifier_bw_3_16_buff"
end

--------------------------------------------------------------------------------

function modifier_bw_3_16:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_bw_3_16:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_bw_3_16:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_bw_3_16:GetAuraRadius()
	return 1500
end

function modifier_bw_3_16:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end