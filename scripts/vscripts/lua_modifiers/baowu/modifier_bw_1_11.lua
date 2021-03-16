
modifier_bw_1_11 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_11:GetTexture()
	return "item_treasure/扫帚柄"
end

function modifier_bw_1_11:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_1_11:OnCreated( kv )
	
end
function modifier_bw_1_11:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_bw_1_11:GetModifierBaseDamageOutgoing_Percentage( params )
	return 30
end
function modifier_bw_1_11:GetModifierAttackSpeedBonus_Constant( params )
	return 30
end
function modifier_bw_1_11:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
