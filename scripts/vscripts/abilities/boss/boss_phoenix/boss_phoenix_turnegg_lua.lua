boss_phoenix_turnegg_lua = class({})
LinkLuaModifier( "modifier_boss_phoenix_turnegg_lua","lua_modifiers/boss/boss_phoenix/modifier_boss_phoenix_turnegg_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_phoenix_turnegg_lua_effect","lua_modifiers/boss/boss_phoenix/modifier_boss_phoenix_turnegg_lua_effect", LUA_MODIFIER_MOTION_NONE )



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function boss_phoenix_turnegg_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	EmitSoundOn( "Hero_Phoenix.SuperNova.Cast", hCaster )
	
	hCaster:AddNewModifier(hCaster, self, "modifier_boss_phoenix_turnegg_lua", {duration=10})
		
end

function boss_phoenix_turnegg_lua:GetCooldown( nLevel )
	
	return  self.BaseClass.GetCooldown( self, nLevel )
end