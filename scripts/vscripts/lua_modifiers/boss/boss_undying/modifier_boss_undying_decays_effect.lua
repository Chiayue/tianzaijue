
modifier_boss_undying_decays_effect = class({})


function modifier_boss_undying_decays_effect:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
	return funcs
end
function modifier_boss_undying_decays_effect:GetModifierExtraHealthPercentage( params )	--
    
        return 5000*self:GetStackCount()
    
end
function modifier_boss_undying_decays_effect:GetModifierDamageOutgoing_Percentage( params )	--
    
        return 1000*self:GetStackCount()
    
end

--------------------------------------------------------------------------------

function modifier_boss_undying_decays_effect:IsDebuff()
	return false
end

function modifier_boss_undying_decays_effect:GetTexture( params )
    return "modifier_boss_undying_decays_effect"
end
function modifier_boss_undying_decays_effect:IsHidden()
	return false
	-- body
end
function modifier_boss_undying_decays_effect:OnCreated( kv )
    if  IsServer() then
        self:SetStackCount(1)
    end
	
end

function modifier_boss_undying_decays_effect:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


	