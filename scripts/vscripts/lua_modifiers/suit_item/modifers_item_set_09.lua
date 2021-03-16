
modifers_item_set_09 = class({})


function modifers_item_set_09:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end
function modifers_item_set_09:GetModifierHealthBonus( params )	--智力
	
	return 15000
end
function modifers_item_set_09:GetModifierBonusStats_Strength( params )	--智力
	
	return 2000
end
function modifers_item_set_09:GetModifierPhysicalArmorBonus( params )	--智力
	
	return 40
end
function modifers_item_set_09:GetModifierMagicalResistanceBonus( params )	--智力
	
	return 20
end
--------------------------------------------------------------------------------

function modifers_item_set_09:IsDebuff()
	return false
end

function modifers_item_set_09:GetTexture( params )
    return "tz/泰坦"
end
function modifers_item_set_09:IsHidden()
	return false
	-- body
end
function modifers_item_set_09:OnCreated( kv )
 if IsServer() then
 		
 	end
end

function modifers_item_set_09:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
