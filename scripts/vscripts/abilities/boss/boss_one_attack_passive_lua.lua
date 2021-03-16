boss_one_attack_passive_lua = class({})
LinkLuaModifier( "modifier_boss_one_attack_passive_lua","lua_modifiers/boss/boss_one/modifier_boss_one_attack_passive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )

function boss_one_attack_passive_lua:GetIntrinsicModifierName()
	return "modifier_boss_one_attack_passive_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
