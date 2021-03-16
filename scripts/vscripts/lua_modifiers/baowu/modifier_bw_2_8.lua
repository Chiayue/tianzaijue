
modifier_bw_2_8 = class({})
LinkLuaModifier( "modifier_bw_2_8_buff", "lua_modifiers/baowu/modifier_bw_2_8_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_2_8:GetTexture()
	return "item_treasure/韧鼓"
end
--------------------------------------------------------------------------------

function modifier_bw_2_8:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_8:OnRefresh()
	
end


function modifier_bw_2_8:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_2_8:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_2_8:GetModifierAura()
	return "modifier_bw_2_8_buff"
end

--------------------------------------------------------------------------------

function modifier_bw_2_8:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_bw_2_8:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_bw_2_8:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_bw_2_8:GetAuraRadius()
	return 1200
end
function modifier_bw_2_8:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end