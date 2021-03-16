


modifiy_shopmall_jjzc_18 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_18:GetTexture()
	return "rune/shopmall_jjzc_18"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_18:IsHidden()
	return true
end


function modifiy_shopmall_jjzc_18:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifiy_shopmall_jjzc_18:GetModifierBonusStats_Strength( params )
	return  50
end
function modifiy_shopmall_jjzc_18:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end