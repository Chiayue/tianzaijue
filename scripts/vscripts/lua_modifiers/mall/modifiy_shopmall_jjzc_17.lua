


modifiy_shopmall_jjzc_17 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_17:GetTexture()
	return "rune/shopmall_jjzc_17"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_17:IsHidden()
	return false
end


function modifiy_shopmall_jjzc_17:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifiy_shopmall_jjzc_17:GetModifierHealthRegenPercentage( params )
	return  1
end
function modifiy_shopmall_jjzc_17:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end