
modifier_bw_2_17 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_17:GetTexture()
	return "item_treasure/崎岖外衣"
end
--------------------------------------------------------------------------------
function modifier_bw_2_17:IsHidden()
	return true
end
function modifier_bw_2_17:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_17:OnRefresh()
	
end


function modifier_bw_2_17:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_bw_2_17:GetModifierPhysicalArmorBonus( params )
	return  50
end
function modifier_bw_2_17:GetModifierAttackSpeedBonus_Constant( params )
	return -50
end
function modifier_bw_2_17:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end