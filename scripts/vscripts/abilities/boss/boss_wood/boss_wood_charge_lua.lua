boss_wood_charge_lua = class({})
LinkLuaModifier( "modifier_boss_wood_charge_lua","lua_modifiers/boss/boss_wood/modifier_boss_wood_charge_lua.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_boss_wood_charge_lua_effect","lua_modifiers/boss/boss_wood/modifier_boss_wood_charge_lua_effect.lua", LUA_MODIFIER_MOTION_BOTH )

LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )

function boss_wood_charge_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	if hCaster == nil then
		return
	end
	
	local vTarget= self:GetCursorTarget()
    self.vTarget=vTarget
    
	local origin_point = hCaster:GetAbsOrigin()
    local target_point = vTarget:GetOrigin()
    self.targetPoint = target_point
    
    hCaster:SetForwardVector((target_point - origin_point):Normalized())
    hCaster:AddNewModifier( hCaster, self, "modifier_boss_wood_charge_lua", {duration=0.5} )

end



