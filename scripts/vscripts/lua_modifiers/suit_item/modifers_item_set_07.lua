
modifers_item_set_07 = class({})


function modifers_item_set_07:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifers_item_set_07:GetModifierHealthBonus( params )	--智力
	
	return 4500
end
function modifers_item_set_07:GetModifierBonusStats_Agility( params )	--智力
	
	return 195
end
function modifers_item_set_07:GetModifierBonusStats_Strength( params )	--智力
	
	return 195
end
function modifers_item_set_07:GetModifierBonusStats_Intellect( params )	--智力
	
	return 195
end
function modifers_item_set_07:GetModifierPhysicalArmorBonus( params )	--智力
	
	return 10
end
function modifers_item_set_07:GetModifierAttackSpeedBonus_Constant( params )	--智力
	
	return 60
end

--------------------------------------------------------------------------------

function modifers_item_set_07:IsDebuff()
	return false
end

function modifers_item_set_07:GetTexture( params )
   return "tz/漫天黄沙"
end
function modifers_item_set_07:IsHidden()
	return false
	-- body
end
function modifers_item_set_07:OnCreated( kv )
 

end

function modifers_item_set_07:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
