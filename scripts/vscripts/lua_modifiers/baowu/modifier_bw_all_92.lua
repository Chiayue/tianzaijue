
modifier_bw_all_92 = class({})
LinkLuaModifier( "modifier_bw_all_92_buff", "lua_modifiers/baowu/modifier_bw_all_92_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_all_92:GetTexture()
	return "item_treasure/梅肯斯姆"
end
--------------------------------------------------------------------------------

function modifier_bw_all_92:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_92:OnRefresh()
	
end


function modifier_bw_all_92:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_all_92:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_all_92:GetModifierAura()
	return "modifier_bw_all_92_buff"
end

--------------------------------------------------------------------------------

function modifier_bw_all_92:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_bw_all_92:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_bw_all_92:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_bw_all_92:GetAuraRadius()
	return 800
end
function modifier_bw_all_92:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end