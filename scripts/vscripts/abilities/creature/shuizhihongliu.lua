shuizhihongliu = class({})
LinkLuaModifier( "modifier_shuizhihongliu","lua_modifiers/creature/modifier_shuizhihongliu", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shuizhihongliu_thinker","lua_modifiers/creature/modifier_shuizhihongliu_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function shuizhihongliu:Precache( context )

    
    PrecacheResource( "particle", "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", context )
    
    --PrecacheResource( "particle", "particles/add_custom/boss_warning/aoe_warning.vpcf", context )

end

function shuizhihongliu:GetIntrinsicModifierName()
	return "modifier_shuizhihongliu"
end

