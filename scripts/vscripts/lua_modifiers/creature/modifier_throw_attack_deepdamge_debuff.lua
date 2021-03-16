modifier_throw_attack_deepdamge_debuff = class({})
--------------------------------------------------------------------------------

function modifier_throw_attack_deepdamge_debuff:IsDebuff()
	return true
end
function modifier_throw_attack_deepdamge_debuff:IsHidden()
	return false
end

function modifier_throw_attack_deepdamge_debuff:GetTexture( params )
    return "sword/stun_modifier"
end
function modifier_throw_attack_deepdamge_debuff:OnCreated( kv )
    if IsServer() then
        
           
    end
    
end
function modifier_throw_attack_deepdamge_debuff:OnRefresh( kv )
    if IsServer() then
       --self:SetStackCount(self:GetStackCount()+1)
      
    end
end
function modifier_throw_attack_deepdamge_debuff:OnDestroy()
	if IsServer() then
		
	end
end

--------------------------------------------------------------------------------

function modifier_throw_attack_deepdamge_debuff:DeclareFunctions()
	local funcs = {
        
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_throw_attack_deepdamge_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
function modifier_throw_attack_deepdamge_debuff:GetModifierIncomingDamage_Percentage( params )
	return 10
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
