
modifier_bw_2_7 = class({})
LinkLuaModifier( "modifier_bw_2_7_buff", "lua_modifiers/baowu/modifier_bw_2_7_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_2_7:GetTexture()
	return "item_treasure/梅肯斯姆"
end
--------------------------------------------------------------------------------

function modifier_bw_2_7:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_7:OnRefresh()
	
end


function modifier_bw_2_7:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_2_7:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_2_7:GetModifierAura()
	return "modifier_bw_2_7_buff"
end

--------------------------------------------------------------------------------

function modifier_bw_2_7:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_bw_2_7:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_bw_2_7:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_bw_2_7:GetAuraRadius()
	return 1200
end
function modifier_bw_2_7:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end