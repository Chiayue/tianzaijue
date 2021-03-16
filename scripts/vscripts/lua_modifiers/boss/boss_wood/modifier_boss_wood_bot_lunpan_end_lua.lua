modifier_boss_wood_bot_lunpan_end_lua = class({})

--------------------------------------------------------------------------------

function modifier_boss_wood_bot_lunpan_end_lua:IsHidden()
	return true
end




--------------------------------------------------------------------------------

function modifier_boss_wood_bot_lunpan_end_lua:OnCreated( kv )
	
	if IsServer() then
		self.nFXIndex =   ParticleManager:CreateParticle( "particles/basic_boss/ab_lunpan/monkey_king_jump_armor_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		
		
	end
end

--------------------------------------------------------------------------------
function modifier_boss_wood_bot_lunpan_end_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_boss_wood_bot_lunpan_end_lua:OnDeath( params )
	if IsServer() then
		if self:GetParent()==params.unit then
			ParticleManager:DestroyParticle(self.nFXIndex,true)
		end
	end
end
function modifier_boss_wood_bot_lunpan_end_lua:OnDestroy( kv )
	
	
end
--------------------------------------------------------------------------------