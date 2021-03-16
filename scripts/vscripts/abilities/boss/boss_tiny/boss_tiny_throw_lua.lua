boss_tiny_throw_lua = class({})
LinkLuaModifier( "modifier_boss_tiny_throw_lua","lua_modifiers/boss/boss_tiny/modifier_boss_tiny_throw_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function boss_tiny_throw_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	
	EmitSoundOn( "Hero_Brewmaster.ThunderClap", self:GetCaster() )
	hCaster:AddNewModifier( hCaster, self, "modifier_boss_tiny_throw_lua", {duration=10} )
			-- body


end
function boss_tiny_throw_lua:OnProjectileHit( hTarget, vLocation )

	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		
			local hCaster=self:GetCaster()
			hTarget:AddNewModifier( hCaster, self, "stun_nothing", {duration=0.3} )
			EmitSoundOn( "Hero_Tiny.CraggyExterior", hTarget )
			local damageInfo =
						{
							victim = hTarget,
							attacker = self:GetCaster(),
							damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = self,
						}
					ApplyDamage( damageInfo )
			
			
		
		
	end

	return false
end


function boss_tiny_throw_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end
