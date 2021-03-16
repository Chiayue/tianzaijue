boss_tiny_armor_lua = class({})
LinkLuaModifier( "modifier_boss_tiny_armor_lua","lua_modifiers/boss/boss_tiny/modifier_boss_tiny_armor_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function boss_tiny_armor_lua:GetIntrinsicModifierName()
	return "modifier_boss_tiny_armor_lua"
end
function boss_tiny_armor_lua:OnProjectileHit( hTarget, vLocation )

	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
		
			local hCaster=self:GetCaster()
			hTarget:AddNewModifier( hCaster, self, "stun_nothing", {duration=0.2} )
			EmitSoundOn( "Hero_Tiny.CraggyExterior", hTarget )
			local damageInfo =
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage =self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*1,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
			ApplyDamage( damageInfo )
				
			
		
		
	end

	return false
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
