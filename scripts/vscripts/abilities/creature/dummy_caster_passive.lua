
dummy_caster_passive = class({})

LinkLuaModifier( "modifier_dummy_caster_passive", "lua_modifiers/creature/modifier_dummy_caster_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function dummy_caster_passive:GetIntrinsicModifierName()
	return "modifier_dummy_caster_passive"
end

--------------------------------------------------------------------------------

