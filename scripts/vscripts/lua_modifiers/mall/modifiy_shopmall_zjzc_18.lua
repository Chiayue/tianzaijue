


modifiy_shopmall_zjzc_18 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_18:GetTexture()
	return "rune/shopmall_zjzc_18"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_18:IsHidden()
	return false
end


function modifiy_shopmall_zjzc_18:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifiy_shopmall_zjzc_18:GetModifierBonusStats_Strength( params )
	return  100
end
function modifiy_shopmall_zjzc_18:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end