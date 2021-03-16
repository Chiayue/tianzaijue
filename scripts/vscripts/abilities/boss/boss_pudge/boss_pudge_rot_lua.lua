boss_pudge_rot_lua = class({})
LinkLuaModifier( "modifier_boss_pudge_rot_lua","lua_modifiers/boss/boss_pudge/modifier_boss_pudge_rot_lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_boss_pudge_rot_creatwenyi_lua","lua_modifiers/boss/boss_pudge/modifier_boss_pudge_rot_creatwenyi_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_pudge_rot_creatwenyi_damage","lua_modifiers/boss/boss_pudge/modifier_boss_pudge_rot_creatwenyi_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_pudge_rot_creatwenyi_effect_lua","lua_modifiers/boss/boss_pudge/modifier_boss_pudge_rot_creatwenyi_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_pudge_rot_creatwenyi_lua_thinker","lua_modifiers/boss/boss_pudge/modifier_boss_pudge_rot_creatwenyi_lua_thinker", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function boss_pudge_rot_lua:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function boss_pudge_rot_lua:OnSpellStart()
	
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_boss_pudge_rot_lua", {duration=10} )
		
		if not self:GetCaster():IsChanneling() then
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_ROT )
		end
		if self:GetCaster():FindModifierByName("modifier_boss_pudge_wenyiyuan_lua") then
			self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_boss_pudge_rot_creatwenyi_lua", {duration=10} )
		end
		
	
end

--------------------------------------------------------------------------------