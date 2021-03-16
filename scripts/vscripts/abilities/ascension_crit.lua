ascension_crit = class( {} )

LinkLuaModifier( "modifier_ascension_crit", "lua_modifiers/modifier_ascension_crit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ascension_crit_buff", "lua_modifiers/modifier_ascension_crit_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ascension_crit:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )

end

--------------------------------------------------------------------------------

function ascension_crit:GetIntrinsicModifierName()
	return "modifier_ascension_crit"
end

--------------------------------------------------------------------------------
