modifier_hdsn_debuff = class({})
--------------------------------------------------------------------------------

function modifier_hdsn_debuff:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_hdsn_debuff:IsStunDebuff()
	return true
end

function modifier_hdsn_debuff:IsHidden()
	return true
end

function modifier_hdsn_debuff:GetTexture( params )
    return "sword/stun_modifier"
end
function modifier_hdsn_debuff:OnCreated( kv )
 
    if IsServer() then
         self.partic = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    	 ParticleManager:SetParticleControl(self.partic ,0,self:GetParent():GetOrigin())
         
    end
end

function modifier_hdsn_debuff:OnDestroy()
	if IsServer() then
		if  self.partic ~=nil then
			ParticleManager:DestroyParticle(self.partic , false)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_hdsn_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_hdsn_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------


function modifier_hdsn_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
