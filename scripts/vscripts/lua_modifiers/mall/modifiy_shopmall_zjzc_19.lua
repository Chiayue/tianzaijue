


modifiy_shopmall_zjzc_19 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_19:GetTexture()
	return "rune/shopmall_zjzc_19"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_19:IsHidden()
	return false
end


function modifiy_shopmall_zjzc_19:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifiy_shopmall_zjzc_19:GetModifierBonusStats_Agility( params )
	return  100
end
function modifiy_shopmall_zjzc_19:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end