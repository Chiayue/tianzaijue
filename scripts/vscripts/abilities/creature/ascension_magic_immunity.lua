ascension_magic_immunity = class({})
LinkLuaModifier( "modifier_ascension_magic_immunity_autocast","lua_modifiers/creature/modifier_ascension_magic_immunity_autocast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ascension_magic_immunity", "lua_modifiers/creature/modifier_ascension_magic_immunity", LUA_MODIFIER_MOTION_NONE )

function ascension_magic_immunity:Precache( hContext )
	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", hContext )
	PrecacheResource( "particle", "particles/status_fx/status_effect_avatar.vpcf", hContext )
end
function ascension_magic_immunity:GetIntrinsicModifierName()
	return "modifier_ascension_magic_immunity_autocast"
end


	



