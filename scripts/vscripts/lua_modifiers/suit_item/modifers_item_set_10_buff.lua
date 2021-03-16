modifers_item_set_10_buff = class({})


function modifers_item_set_10_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,

	}
	return funcs
end

function modifers_item_set_10_buff:GetModifierBonusStats_Agility( params )	--智力
	
	return 600
end
function modifers_item_set_10_buff:GetModifierBonusStats_Strength( params )	--智力
	
	return 600
end
function modifers_item_set_10_buff:GetModifierBonusStats_Intellect( params )	--智力
	
	return 600
end
function modifers_item_set_10_buff:GetModifierMoveSpeedBonus_Constant( params )	--智力
	
	return 30
end
function modifers_item_set_10_buff:GetModifierAttackSpeedBonus_Constant( params )	--智力
	
	return 60
end
function modifers_item_set_10_buff:GetModifierSpellAmplify_Percentage( params )	--智力
	
	return 30
end
function modifers_item_set_10_buff:GetModifierHealthRegenPercentage( params )	--智力
	
	return 2
end
--------------------------------------------------------------------------------

function modifers_item_set_10_buff:IsDebuff()
	return false
end

function modifers_item_set_10_buff:GetTexture( params )
    return "tz/海王"
end
function modifers_item_set_10_buff:IsHidden()
	return false
	-- body
end
function modifers_item_set_10_buff:OnCreated( kv )
 
if IsServer() then
 		
 	end
end

function modifers_item_set_10_buff:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
