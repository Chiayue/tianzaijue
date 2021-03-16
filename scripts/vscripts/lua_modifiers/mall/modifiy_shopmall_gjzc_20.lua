


modifiy_shopmall_gjzc_20 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_20:GetTexture()
	return "rune/shopmall_gjzc_20"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_20:IsHidden()
	return false
end


function modifiy_shopmall_gjzc_20:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifiy_shopmall_gjzc_20:GetModifierBonusStats_Intellect( params )
	return  200
end
function modifiy_shopmall_gjzc_20:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end