


modifiy_shopmall_jjzc_19 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_19:GetTexture()
	return "rune/shopmall_jjzc_19"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_19:IsHidden()
	return false
end


function modifiy_shopmall_jjzc_19:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifiy_shopmall_jjzc_19:GetModifierBonusStats_Agility( params )
	return  50
end
function modifiy_shopmall_jjzc_19:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end