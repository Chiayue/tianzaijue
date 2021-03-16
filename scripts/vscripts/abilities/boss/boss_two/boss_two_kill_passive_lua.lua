boss_two_kill_passive_lua = class({})
LinkLuaModifier( "modifier_boss_two_kill_passive_lua","lua_modifiers/boss/boss_two/modifier_boss_two_kill_passive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_two_kill_passive_lua_effect_damage","lua_modifiers/boss/boss_two/modifier_boss_two_kill_passive_lua_effect_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_two_kill_passive_lua_effect_movespeed","lua_modifiers/boss/boss_two/modifier_boss_two_kill_passive_lua_effect_movespeed", LUA_MODIFIER_MOTION_NONE )


function boss_two_kill_passive_lua:GetIntrinsicModifierName()
	return "modifier_boss_two_kill_passive_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
