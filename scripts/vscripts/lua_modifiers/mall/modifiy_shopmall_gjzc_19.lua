


modifiy_shopmall_gjzc_19 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_19:GetTexture()
	return "rune/shopmall_gjzc_19"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_19:IsHidden()
	return false
end


function modifiy_shopmall_gjzc_19:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifiy_shopmall_gjzc_19:GetModifierBonusStats_Agility( params )
	return  200
end
function modifiy_shopmall_gjzc_19:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end