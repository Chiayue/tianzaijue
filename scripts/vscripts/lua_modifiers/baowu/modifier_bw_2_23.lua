
modifier_bw_2_23 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_23:GetTexture()
	return "item_treasure/暗淡胸针"
end

function modifier_bw_2_23:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_2_23:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_2_23:OnRefresh()

end

--------------------------------------------------------------------------------

function modifier_bw_2_23:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT

	}
	return funcs
end
function modifier_bw_2_23:GetModifierMoveSpeedBonus_Constant( params )
	return 30
end
function modifier_bw_2_23:GetModifierPercentageManacost( params )  
	return 10
end


function modifier_bw_2_23:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

