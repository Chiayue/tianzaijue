boss_pudge_flesh_heap_lua = class({})
LinkLuaModifier( "modifier_boss_pudge_flesh_heap_lua","lua_modifiers/boss/boss_pudge/modifier_boss_pudge_flesh_heap_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function boss_pudge_flesh_heap_lua:GetIntrinsicModifierName()
	return "modifier_boss_pudge_flesh_heap_lua"
end

--------------------------------------------------------------------------------
--[[
function boss_pudge_flesh_heap_lua:OnHeroDiedNearby( hVictim, hKiller, kv )
	print(44444444444)
	print("dddd",hVictim,hKiller)
	if hVictim == nil or hKiller == nil then
		return
	end

	if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
		self.flesh_heap_range = self:GetSpecialValueFor( "flesh_heap_range" )
		local vToCaster = self:GetCaster():GetOrigin() - hVictim:GetOrigin()
		local flDistance = vToCaster:Length2D()
		if hKiller == self:GetCaster() or self.flesh_heap_range >= flDistance then
			if self.nKills == nil then
				self.nKills = 0
			end

			self.nKills = self.nKills + 1

			local hBuff = self:GetCaster():FindModifierByName( "modifier_boss_pudge_flesh_heap_lua" )
			if hBuff ~= nil then
				hBuff:SetStackCount( self.nKills )
				--self:GetCaster():CalculateStatBonus(true)
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end
]]
--------------------------------------------------------------------------------

function boss_pudge_flesh_heap_lua:GetFleshHeapKills()
	if self.nKills == nil then
		self.nKills = 0
	end
	return self.nKills
end
 
--------------------------------------------------------------------------------

