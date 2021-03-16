aoshuzhuanjin = class({})
LinkLuaModifier( "modifier_aoshuzhuanjin","lua_modifiers/creature/modifier_aoshuzhuanjin", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function aoshuzhuanjin:Precache( context )

    
    PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_soul_assumption_bolt6.vpcf", context )
    --PrecacheResource( "particle", "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", context )
    
    PrecacheResource( "particle", "particles/add_custom/boss_warning/aoe_warning.vpcf", context )

end

function aoshuzhuanjin:GetIntrinsicModifierName()
	return "modifier_aoshuzhuanjin"
end

function aoshuzhuanjin:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
        
		local damageInfo = 
            {
                victim = hTarget,
                attacker = self:GetCaster(),
                damage = 0.4*self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self,
            }

            ApplyDamage( damageInfo )
		    EmitSoundOn( "Dungeon.BanditDagger.Target", hTarget )
	end

	return true
end