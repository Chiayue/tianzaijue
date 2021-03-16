
modifier_bw_2_13 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_13:GetTexture()
	return "item_treasure/漩涡"
end
--------------------------------------------------------------------------------
function modifier_bw_2_13:IsHidden()
	return true
end
function modifier_bw_2_13:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_13:OnRefresh()
	
end


function modifier_bw_2_13:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_bw_2_13:GetModifierAttackSpeedBonus_Constant( params )
	return 40
end
function modifier_bw_2_13:OnAttackLanded(params)
    if IsServer() then
        -- play sounds and stuff
        if self:GetParent() == params.attacker then
            local hTarget = params.target
            if hTarget ~= nil and not self:GetParent():HasModifier("modifier_bw_3_11") then
			   if RollPercentage(25) and self:GetAbility():IsCooldownReady() then
				self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
                    self:GetAbility():CreateMoonGlaive(hTarget, {bounces_left = 4, damage = self:GetParent():GetPrimaryStatValue()*3,
                                              [tostring(hTarget:GetEntityIndex())] = 1,up=hTarget:GetEntityIndex()})
                end
            end
            
           
            
        end
    end

    return 0.0
end
function modifier_bw_2_13:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end