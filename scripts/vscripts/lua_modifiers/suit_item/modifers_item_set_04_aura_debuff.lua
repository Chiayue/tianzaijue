
modifers_item_set_04_aura_debuff = class({})


function modifers_item_set_04_aura_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
function modifers_item_set_04_aura_debuff:GetModifierAttackSpeedBonus_Constant( params )	--智力
	
	return -20
end
function modifers_item_set_04_aura_debuff:GetModifierMoveSpeedBonus_Percentage( params )	--智力
	
	return -20
end
--------------------------------------------------------------------------------

function modifers_item_set_04_aura_debuff:IsDebuff()
	return true
end

function modifers_item_set_04_aura_debuff:GetTexture( params )
    return "tz/冰霜亡灵"
end
function modifers_item_set_04_aura_debuff:IsHidden()
	return false
	-- body
end
function modifers_item_set_04_aura_debuff:OnCreated( kv )
 

end

function modifers_item_set_04_aura_debuff:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
