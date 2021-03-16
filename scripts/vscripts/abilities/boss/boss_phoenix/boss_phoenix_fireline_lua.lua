boss_phoenix_fireline_lua = class({})
LinkLuaModifier( "modifier_boss_phoenix_fireline_lua","lua_modifiers/boss/boss_phoenix/modifier_boss_phoenix_fireline_lua", LUA_MODIFIER_MOTION_NONE )



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function boss_phoenix_fireline_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	EmitSoundOn( "Hero_Jakiro.Macropyre.Cast", hCaster )
    for i=1,12 do
    	local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_phoenix_fireline_lua", { duration = 12 }, hCaster:GetOrigin(), self:GetCaster():GetTeamNumber(), false )
    end
end
function boss_phoenix_fireline_lua:OnProjectileHit( hTarget, vLocation )

	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		
			local hCaster=self:GetCaster()
			
			EmitSoundOn( "hero_jakiro.projectileImpact", hTarget )
			local damageInfo =
						{
							victim = hTarget,
							attacker = self:GetCaster(),
							damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*0.3,
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = self,
						}
					ApplyDamage( damageInfo )
			
			
		
		
	end

	return false
end
function boss_phoenix_fireline_lua:GetCooldown( nLevel )
	
	return self.BaseClass.GetCooldown( self, nLevel )
end