boss_phoenix_fire_lua = class({})
LinkLuaModifier( "modifier_boss_phoenix_fire_lua","lua_modifiers/boss/boss_phoenix/modifier_boss_phoenix_fire_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_phoenix_fire_lua_effect","lua_modifiers/boss/boss_phoenix/modifier_boss_phoenix_fire_lua_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "npc_target","lua_modifiers/npc_target.lua",LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

function boss_phoenix_fire_lua:GetIntrinsicModifierName()
	return "modifier_boss_phoenix_fire_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
