
modifier_boss_undying_flesh_golem_effect_buff = class({})


function modifier_boss_undying_flesh_golem_effect_buff:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_boss_undying_flesh_golem_effect_buff:GetModifierAttackSpeedBonus_Constant( params )	--
    
    return self.cc
        
    
end
function modifier_boss_undying_flesh_golem_effect_buff:GetModifierMoveSpeedBonus_Percentage( params )	--
    
    return self.cc
        
    
end
function modifier_boss_undying_flesh_golem_effect_buff:GetModifierDamageOutgoing_Percentage( params )	--
    
    return self.cc
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect_buff:IsDebuff()
	return false
end

function modifier_boss_undying_flesh_golem_effect_buff:GetTexture( params )
    return "modifier_boss_undying_flesh_golem_effect_buff"
end
function modifier_boss_undying_flesh_golem_effect_buff:IsHidden()
	return false
	-- body
end

function modifier_boss_undying_flesh_golem_effect_buff:IsDebuff()
   
       
            return false
       
    
	
	-- body
end

function modifier_boss_undying_flesh_golem_effect_buff:OnCreated( kv )
    self.cc= 20
    if  self:GetCaster():HasModifier("modifier_boss_undying_tombstone_zombie_night") then
        self.cc= 40
    end
    
	
end

function modifier_boss_undying_flesh_golem_effect_buff:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


	