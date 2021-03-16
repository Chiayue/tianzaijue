
modifier_bw_all_15 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_15:GetTexture()
	return "item_treasure/巨人化"
end
--------------------------------------------------------------------------------
function modifier_bw_all_15:IsHidden()
	return true
end


function modifier_bw_all_15:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
	return funcs
end
--function modifier_bw_all_15:GetModifierModelScale( params )
--	return 30
--end
function modifier_bw_all_15:GetModifierAttackSpeedBonus_Constant( params )
	return -80
end
function modifier_bw_all_15:GetModifierMoveSpeedBonus_Percentage( params )
	return  -30
end
function modifier_bw_all_15:GetModifierBaseDamageOutgoing_Percentage( params )
	return 200
end
function modifier_bw_all_15:GetModifierExtraHealthPercentage( params )
	return 100
end

function modifier_bw_all_15:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end