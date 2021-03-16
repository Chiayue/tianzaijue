boss_wood_bot_passive_lua = class({})
LinkLuaModifier( "modifier_boss_wood_bot_passive_lua","lua_modifiers/boss/boss_wood/modifier_boss_wood_bot_passive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_wood_bot_passive_lua_thinker","lua_modifiers/boss/boss_wood/modifier_boss_wood_bot_passive_lua_thinker", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function boss_wood_bot_passive_lua:GetIntrinsicModifierName()
	return "modifier_boss_wood_bot_passive_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
