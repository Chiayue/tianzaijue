-----------------------------------------------------------------
llyx_sx = class({})

--------------------------------------------------------------------------------
-- Classifications
function llyx_sx:IsHidden()
	return false
end

function llyx_sx:GetTexture()
	return "spirit_breaker_empowering_haste"
end



function llyx_sx:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}

	return funcs
end
--------------------------------------------------------------------------------
function llyx_sx:GetModifierStatusResistanceStacking( params )
	return 50
end

function llyx_sx:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
---


