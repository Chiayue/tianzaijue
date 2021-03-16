boss_wood_bot_lua = class({})
LinkLuaModifier( "modifier_boss_wood_bot_passive_lua","lua_modifiers/boss/boss_wood/modifier_boss_wood_bot_passive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_wood_bot_passive_lua_thinker","lua_modifiers/boss/boss_wood/modifier_boss_wood_bot_passive_lua_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function boss_wood_bot_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local num = 3 + Stage.playernum *3
    for i=1,num do
    	local point = FindRandomPoint(hCaster:GetAbsOrigin(),1500)
    	local unit=CreateUnitByName("npc_wood_bot", point, true, hCaster, hCaster, hCaster:GetTeamNumber() )
    	unit:AddNewModifier(hCaster, self, "modifier_boss_wood_bot_passive_lua", {})
    	unit:SetBaseDamageMax(hCaster:GetAverageTrueAttackDamage(hCaster))
    	unit:SetBaseDamageMin(hCaster:GetAverageTrueAttackDamage(hCaster))
    	unit:AddNewModifier(hCaster, self, "modifier_kill", {duration=3})
    end
end

function boss_wood_bot_lua:GetCooldown( nLevel )
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_boss_phoenix_stone_lua_bloodfier") then
			return self.BaseClass.GetCooldown( self, nLevel )/2	
		end
	end
	return self.BaseClass.GetCooldown( self, nLevel )
end