boss_invoker_unit_passive_lua = class({})
LinkLuaModifier( "modifier_boss_invoker_unit_passive_lua","lua_modifiers/boss/boss_three/modifier_boss_invoker_unit_passive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_invoker_unit_passive_lua_water","lua_modifiers/boss/boss_three/modifier_boss_invoker_unit_passive_lua_water", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_invoker_unit_passive_lua_fire","lua_modifiers/boss/boss_three/modifier_boss_invoker_unit_passive_lua_fire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "lower_attackspeed","lua_modifiers/boss/lower_attackspeed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )

function boss_invoker_unit_passive_lua:GetIntrinsicModifierName()
	return "modifier_boss_invoker_unit_passive_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
