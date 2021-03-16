boss_phoenix_firetarget_lua = class({})
LinkLuaModifier( "modifier_boss_phoenix_firetarget_lua","lua_modifiers/boss/boss_phoenix/modifier_boss_phoenix_firetarget_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "lower_movespeed","lua_modifiers/boss/lower_movespeed", LUA_MODIFIER_MOTION_NONE )



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function boss_phoenix_firetarget_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	EmitSoundOn( "Hero_Phoenix.ProjectileImpact", hCaster )
	local hTarget=self:GetCursorTarget()	
    self.unit = CreateUnitByName( "npc_bot", hTarget:GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
    hTarget:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
    local attachment = hCaster:ScriptLookupAttachment( "attach_attack1" )
     local info = 
		{
			Target = self.unit,
			Source = hCaster,
			Ability = self,
			EffectName = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf",
			iMoveSpeed = 1000,
			vSourceLoc = hCaster:GetAttachmentOrigin( attachment ),
			bDodgeable = false,
			bProvidesVision = false,
			flExpireTime = GameRules:GetGameTime() + 1,
		}

		ProjectileManager:CreateTrackingProjectile( info )
end
function boss_phoenix_firetarget_lua:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		
		local hCaster=self:GetCaster()
		
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_phoenix_firetarget_lua", { duration = 10 }, vLocation, self:GetCaster():GetTeamNumber(), false )
		
	end
	self.unit:RemoveSelf()
	return true
end
function boss_phoenix_firetarget_lua:GetCooldown( nLevel )

	if IsServer() then
		if self:GetCaster():HasModifier("modifier_boss_phoenix_turnegg_lua") then
			return self.BaseClass.GetCooldown( self, nLevel )/2	
		else
			self.BaseClass.GetCooldown( self, nLevel )
		end
	end
	return self.BaseClass.GetCooldown( self, nLevel )
end