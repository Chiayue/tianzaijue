bingzhishijie = class({})
LinkLuaModifier( "modifier_bingzhishijie","lua_modifiers/creature/modifier_bingzhishijie", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bingzhishijie_thinker","lua_modifiers/creature/modifier_bingzhishijie_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bingzhishijie_frazen","lua_modifiers/creature/modifier_bingzhishijie_frazen", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function bingzhishijie:Precache( context )

    
    PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", context )
    --PrecacheResource( "particle", "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", context )
    
    PrecacheResource( "particle", "particles/add_custom/boss_warning/aoe_warning.vpcf", context )

end

function bingzhishijie:GetIntrinsicModifierName()
	return "modifier_bingzhishijie"
end

