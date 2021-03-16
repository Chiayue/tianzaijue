
modifier_cc = class({})


function modifier_cc:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
	return funcs
end
function modifier_cc:GetModifierExtraHealthPercentage( params )	--
    
        return 5000*self:GetStackCount()
    
end
function modifier_cc:GetModifierDamageOutgoing_Percentage( params )	--
    
        return 1000*self:GetStackCount()
    
end

--------------------------------------------------------------------------------

function modifier_cc:IsDebuff()
	return false
end

function modifier_cc:GetTexture( params )
    return "modifier_cc"
end
function modifier_cc:IsHidden()
	return false
	-- body
end
function modifier_cc:OnCreated( kv )
    if  IsServer() then
        self:SetStackCount(1)
    end
	
end

function modifier_cc:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


	