modifers_item_set_05 = class({})


function modifers_item_set_05:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end
function modifers_item_set_05:GetModifierHealthBonus( params )	--智力
	
	return 5000
end
function modifers_item_set_05:GetModifierBonusStats_Agility( params )	--智力
	
	return 220
end
function modifers_item_set_05:GetModifierBonusStats_Strength( params )	--智力
	
	return 220
end
function modifers_item_set_05:GetModifierBonusStats_Intellect( params )	--智力
	
	return 220
end
function modifers_item_set_05:GetModifierPhysicalArmorBonus( params )	--智力
	
	return 25
end
function modifers_item_set_05:GetModifierHealthRegenPercentage( params )	--智力
	
	return 2
end

--------------------------------------------------------------------------------

function modifers_item_set_05:IsDebuff()
	return false
end

function modifers_item_set_05:GetTexture( params )
   return "tz/大地脉动"
end
function modifers_item_set_05:IsHidden()
	return false
	-- body
end
function modifers_item_set_05:OnCreated( kv )
 

end

function modifers_item_set_05:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
