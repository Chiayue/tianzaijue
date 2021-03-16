
modifers_item_set_01 = class({})


function modifers_item_set_01:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifers_item_set_01:GetModifierHealthBonus( params )	--智力
	
	return 2000
end
function modifers_item_set_01:GetModifierBonusStats_Agility( params )	--智力
	
	return 100
end
function modifers_item_set_01:GetModifierBonusStats_Strength( params )	--智力
	
	return 100
end
function modifers_item_set_01:GetModifierBonusStats_Intellect( params )	--智力
	
	return 100
end
function modifers_item_set_01:GetModifierMoveSpeedBonus_Constant( params )	--智力
	
	return 30
end

function modifers_item_set_01:OnAttackLanded( params )
	if IsServer() then
		
		if params.attacker == self:GetParent() then			
			local damage = params.damage * 0.06

  			self:GetParent():Heal(damage, nil)
		end
	end
	
	return 0
end

--------------------------------------------------------------------------------

function modifers_item_set_01:IsDebuff()
	return false
end

function modifers_item_set_01:GetTexture( params )
    return "tz/金镶玉"
end
function modifers_item_set_01:IsHidden()
	return false
	-- body
end
function modifers_item_set_01:OnCreated( kv )
 

end

function modifers_item_set_01:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
