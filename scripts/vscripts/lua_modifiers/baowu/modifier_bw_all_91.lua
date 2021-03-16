
modifier_bw_all_91 = class({})
LinkLuaModifier( "modifier_bw_all_91_buff", "lua_modifiers/baowu/modifier_bw_all_91_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_all_91:GetTexture()
	return "item_treasure/梅肯斯姆"
end
--------------------------------------------------------------------------------

function modifier_bw_all_91:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_91:OnRefresh()
	
end


function modifier_bw_all_91:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_all_91:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_bw_all_91:GetModifierAura()
	return "modifier_bw_all_91_buff"
end

--------------------------------------------------------------------------------

function modifier_bw_all_91:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_bw_all_91:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_bw_all_91:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_bw_all_91:GetAuraRadius()
	return 800
end
function modifier_bw_all_91:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end