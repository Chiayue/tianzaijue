
modifier_bw_3_16_buff = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_16_buff:GetTexture()
	return "item_treasure/modifier_bw_3_16_buff"
end
--------------------------------------------------------------------------------

function modifier_bw_3_16_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_16_buff:OnRefresh()
	
end


function modifier_bw_3_16_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_3_16_buff:GetModifierPhysicalArmorBonus( params )
	return 20
end
function modifier_bw_3_16_buff:GetModifierAttackSpeedBonus_Constant( params )
	return 50
end
function modifier_bw_3_16_buff:GetModifierBaseDamageOutgoing_Percentage( params )
	return 30
end
