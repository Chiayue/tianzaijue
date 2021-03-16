
modifier_bw_3_11 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_11:GetTexture()
	return "item_treasure/雷神之锤"
end
--------------------------------------------------------------------------------
function modifier_bw_3_11:IsHidden()
	return true
end
function modifier_bw_3_11:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_11:OnRefresh()
	
end


function modifier_bw_3_11:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_bw_3_11:GetModifierAttackSpeedBonus_Constant( params )
	return 80
end
function modifier_bw_3_11:OnAttackLanded(params)
    if IsServer() then
        -- play sounds and stuff
        if self:GetParent() == params.attacker then
            local hTarget = params.target
            if hTarget ~= nil then
			   if RollPercentage(25) and self:GetAbility():IsCooldownReady() then
				self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
                    self:GetAbility():CreateMoonGlaive(hTarget, {bounces_left = 8, damage = self:GetParent():GetPrimaryStatValue()*10,
                                              [tostring(hTarget:GetEntityIndex())] = 1,up=hTarget:GetEntityIndex()})
                end
            end
            
           
            
        end
    end

    return 0.0
end
function modifier_bw_3_11:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end