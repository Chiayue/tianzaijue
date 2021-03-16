firefly = class({})
LinkLuaModifier( "modifier_firefly","lua_modifiers/creature/modifier_firefly", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_firefly_autocast","lua_modifiers/creature/modifier_firefly_autocast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_firefly_damage","lua_modifiers/creature/modifier_firefly_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_firefly_thinker","lua_modifiers/creature/modifier_firefly_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function firefly:Precache( context )
 
    
    PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_firefly.vpcf", context )
    --PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike_slow.vpcf", context )

end
function firefly:GetIntrinsicModifierName()
	return "modifier_firefly_autocast"
end
