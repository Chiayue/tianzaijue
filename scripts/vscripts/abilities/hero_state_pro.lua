hero_state_pro = class( {} )

LinkLuaModifier( "modifier_hero_state_pro", "lua_modifiers/modifier_hero_state_pro", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_state_pro_maxhealth", "lua_modifiers/modifier_hero_state_pro_maxhealth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_state_pro_agi_per", "lua_modifiers/modifier_hero_state_pro_agi_per", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_state_pro_str_per", "lua_modifiers/modifier_hero_state_pro_str_per", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_state_pro_int_per", "lua_modifiers/modifier_hero_state_pro_int_per", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hero_state_pro:Precache( context )

end

--------------------------------------------------------------------------------

function hero_state_pro:GetIntrinsicModifierName()
	return "modifier_hero_state_pro"
end

--------------------------------------------------------------------------------
