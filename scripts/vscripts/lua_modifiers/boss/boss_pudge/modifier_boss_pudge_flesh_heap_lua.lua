modifier_boss_pudge_flesh_heap_lua = class({})

--------------------------------------------------------------------------------

function modifier_boss_pudge_flesh_heap_lua:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.health = self:GetAbility():GetSpecialValueFor( "health" )
	if IsServer() then
		self:SetStackCount( self:GetAbility():GetFleshHeapKills() )
		--self:GetParent():CalculateStatBonus(true)
	end
end
function modifier_boss_pudge_flesh_heap_lua:IsDebuff()
	return false
end
function modifier_boss_pudge_flesh_heap_lua:IsHidden()
	return false
end
--------------------------------------------------------------------------------

function modifier_boss_pudge_flesh_heap_lua:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.health = self:GetAbility():GetSpecialValueFor( "health" )
	if IsServer() then
		--self:GetParent():CalculateStatBonus(true)
	end
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_flesh_heap_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH, 
	}

	return funcs
end
--------------------------------------------------------------------------------
function modifier_boss_pudge_flesh_heap_lua:OnDeath( params )
	if IsServer() then
		local hVictim=params.unit
		local hKiller=params.attacker
		if hVictim == nil or hKiller == nil then
			return
		end

		if hVictim == hKiller then
			return
		end
	
		if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
			self:GetAbility().flesh_heap_range = self:GetAbility():GetSpecialValueFor( "flesh_heap_range" )
			local vToCaster = self:GetCaster():GetOrigin() - hVictim:GetOrigin()
			local flDistance = vToCaster:Length2D()
			if hKiller == self:GetCaster() or self:GetAbility().flesh_heap_range >= flDistance then
				if self:GetAbility().nKills == nil then
					self:GetAbility().nKills = 0
				end
				local i = self:GetAbility().nKills + 1
				if i > 40 then
					i=40
				end
				self:GetAbility().nKills = i
	
				
				self:SetStackCount( self:GetAbility().nKills )
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end

		
	end
end

function modifier_boss_pudge_flesh_heap_lua:GetModifierExtraHealthPercentage( params )

		
		return self:GetStackCount()* self.health


end

--------------------------------------------------------------------------------

function modifier_boss_pudge_flesh_heap_lua:GetModifierDamageOutgoing_Percentage( params )

		return self:GetStackCount()* self.damage

end

--------------------------------------------------------------------------------