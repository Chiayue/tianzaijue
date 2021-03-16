yunshi = class({})
LinkLuaModifier( "modifier_yunshi","lua_modifiers/creature/modifier_yunshi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yunshi_thinker","lua_modifiers/creature/modifier_yunshi_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function yunshi:Precache( context )

    
    
    
    PrecacheResource( "particle", "particles/add_custom/boss_warning/aoe_warning.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly2.vpcf", context )

end

function yunshi:GetIntrinsicModifierName()
	return "modifier_yunshi"
end

