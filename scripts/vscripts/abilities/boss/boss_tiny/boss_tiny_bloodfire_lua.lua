boss_tiny_bloodfire_lua = class({})
LinkLuaModifier( "modifier_boss_tiny_bloodfire_lua","lua_modifiers/boss/boss_tiny/modifier_boss_tiny_bloodfire_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "add_movespeed","lua_modifiers/boss/add_movespeed", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------


function boss_tiny_bloodfire_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	
	EmitSoundOn( "Hero_Brewmaster.ThunderClap", self:GetCaster() )
 hCaster:AddNewModifier( hCaster, self, "modifier_boss_tiny_bloodfire_lua", {} )
	local buff=hCaster:AddNewModifier( hCaster, self, "add_movespeed", {} )
	buff:SetStackCount(50)		-- body


end



function boss_tiny_bloodfire_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end
