
modifers_item_set_11_aura_debuff = class({})


function modifers_item_set_11_aura_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifers_item_set_11_aura_debuff:GetModifierMagicalResistanceBonus( params )	--智力
	
	return -25
end
--------------------------------------------------------------------------------

function modifers_item_set_11_aura_debuff:IsDebuff()
	return true
end

function modifers_item_set_11_aura_debuff:GetTexture( params )
   return "tz/幽魂"
end
function modifers_item_set_11_aura_debuff:IsHidden()
	return false
	-- body
end
function modifers_item_set_11_aura_debuff:OnCreated( kv )
 

end

function modifers_item_set_11_aura_debuff:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
