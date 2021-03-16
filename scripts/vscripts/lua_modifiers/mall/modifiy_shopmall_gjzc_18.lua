


modifiy_shopmall_gjzc_18 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_18:GetTexture()
	return "rune/shopmall_gjzc_18"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_18:IsHidden()
	return true
end


function modifiy_shopmall_gjzc_18:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifiy_shopmall_gjzc_18:GetModifierBonusStats_Strength( params )
	return  200
end
function modifiy_shopmall_gjzc_18:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end