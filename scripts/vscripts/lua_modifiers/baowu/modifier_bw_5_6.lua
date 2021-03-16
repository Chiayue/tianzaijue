
modifier_bw_5_6 = class({})
LinkLuaModifier( "modifier_bw_5_6_buff", "lua_modifiers/baowu/modifier_bw_5_6_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_5_6:GetTexture()
	return "item_treasure/韧鼓"
end
--------------------------------------------------------------------------------

function modifier_bw_5_6:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_5_6:OnRefresh()
	
end


function modifier_bw_5_6:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_5_6:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_5_6:GetModifierAura()
	return "modifier_bw_5_6_buff"
end

--------------------------------------------------------------------------------

function modifier_bw_5_6:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_bw_5_6:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_bw_5_6:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_bw_5_6:GetAuraRadius()
	return 1200
end
function modifier_bw_5_6:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end