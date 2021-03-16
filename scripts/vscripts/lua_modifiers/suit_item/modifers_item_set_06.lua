
modifers_item_set_06 = class({})


function modifers_item_set_06:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs
end
function modifers_item_set_06:GetModifierTotalPercentageManaRegen( params )	--智力
	
	return -1
end
function modifers_item_set_06:GetModifierSpellAmplify_Percentage( params )	--智力
	
	return 200
end
function modifers_item_set_06:GetModifierPercentageManaRegen( params )	--智力
	
	return -100
end
function modifers_item_set_06:GetModifierPercentageManacost( params )	--智力
	
	return -50
end

--------------------------------------------------------------------------------

function modifers_item_set_06:IsDebuff()
	return false
end

function modifers_item_set_06:GetTexture( params )
   return "tz/法力流失"
end
function modifers_item_set_06:IsHidden()
	return false
	-- body
end
function modifers_item_set_06:OnCreated( kv )
 

end

function modifers_item_set_06:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
