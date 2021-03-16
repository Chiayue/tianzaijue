
modifier_bw_3_3 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_3:GetTexture()
	return "item_treasure/巨神残铁"
end
--------------------------------------------------------------------------------
function modifier_bw_3_3:IsHidden()
	return true
end
function modifier_bw_3_3:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_3:OnRefresh()
	
end


function modifier_bw_3_3:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifier_bw_3_3:GetModifierStatusResistanceStacking( params )
	return 20
end
function modifier_bw_3_3:GetModifierMagicalResistanceBonus( params )
	return  40
end
function modifier_bw_3_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end