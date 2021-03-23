-----------------------------------------------------------------
llyx_sx2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function llyx_sx2:IsHidden()
	return false
end

function llyx_sx2:GetTexture()
	return "spirit_breaker_empowering_haste"
end



function llyx_sx2:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}

	return funcs
end
--------------------------------------------------------------------------------
function llyx_sx2:GetModifierStatusResistanceStacking( params )

	return 90
end

function llyx_sx2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
---


