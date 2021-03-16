


modifiy_shopmall_zjzc_17 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_17:GetTexture()
	return "rune/shopmall_zjzc_17" 
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_17:IsHidden()
	return true
end


function modifiy_shopmall_zjzc_17:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifiy_shopmall_zjzc_17:GetModifierHealthRegenPercentage( params )
	return  2
end
function modifiy_shopmall_zjzc_17:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end