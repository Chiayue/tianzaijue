
modifier_bw_2_22 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_22:GetTexture()
	return "item_treasure/以太之境"
end

function modifier_bw_2_22:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_2_22:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_2_22:OnRefresh()

end

--------------------------------------------------------------------------------

function modifier_bw_2_22:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
	

	}
	return funcs
end
function modifier_bw_2_22:GetModifierConstantManaRegen( params )
	return 12
end
function modifier_bw_2_22:GetModifierManaBonus( params )
	return 300
end

function modifier_bw_2_22:GetModifierCastRangeBonus( params )
	return 300
end



function modifier_bw_2_22:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

