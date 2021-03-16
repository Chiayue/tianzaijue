anjiannanfang = class({})
LinkLuaModifier( "modifier_anjiannanfang","lua_modifiers/creature/modifier_anjiannanfang", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function anjiannanfang:Precache( context )

    
    
    
    PrecacheResource( "particle", "particles/add_custom/boss_warning/aoe_warning.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf", context )

end

function anjiannanfang:GetIntrinsicModifierName()
	return "modifier_anjiannanfang"
end


function anjiannanfang:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
        self.stun_duration=self:GetSpecialValueFor("stun_duration")
        hTarget:AddNewModifier( self:GetCaster(), self, "stun_nothing", {duration=self.stun_duration} )
		local damageInfo = 
            {
                victim = hTarget,
                attacker = self:GetCaster(),
                damage = 1.5*self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self,
            }

            ApplyDamage( damageInfo )
		EmitSoundOn( "Dungeon.BanditDagger.Target", hTarget )
	end

	return true
end