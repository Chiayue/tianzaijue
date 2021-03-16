stun_nothing = class({})
--------------------------------------------------------------------------------

function stun_nothing:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function stun_nothing:IsStunDebuff()
	return true
end
function stun_nothing:IsDebuff( params )
    return true
end
function stun_nothing:GetTexture( params )
    return "sword/stun_modifier"
end
function stun_nothing:OnCreated( kv )
 
    if IsServer() then
         self.partic = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    	 ParticleManager:SetParticleControl(self.partic ,0,self:GetParent():GetOrigin())
         
    end
end

function stun_nothing:OnDestroy()
	if IsServer() then
		if  self.partic ~=nil then
			ParticleManager:DestroyParticle(self.partic , false)
		end
	end
end

--------------------------------------------------------------------------------

function stun_nothing:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function stun_nothing:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------


function stun_nothing:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
