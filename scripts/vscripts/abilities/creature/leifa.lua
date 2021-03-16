leifa = class({})
LinkLuaModifier( "modifier_leifa","lua_modifiers/creature/modifier_leifa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leifa_thinker","lua_modifiers/creature/modifier_leifa_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leifa_slow_nothing","lua_modifiers/creature/modifier_leifa_slow_nothing", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function leifa:Precache( context )

    
    
    
    PrecacheResource( "particle", "particles/add_custom/boss_warning/aoe_warning.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike_slow.vpcf", context )

end

function leifa:GetIntrinsicModifierName()
	return "modifier_leifa"
end

