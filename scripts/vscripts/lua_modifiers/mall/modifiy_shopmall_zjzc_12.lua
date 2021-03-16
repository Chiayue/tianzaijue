


modifiy_shopmall_zjzc_12 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_12:GetTexture()
	return "rune/shopmall_zjzc_12"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_12:IsHidden()
	return true
end
function modifiy_shopmall_zjzc_12:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_zjzc_12:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifiy_shopmall_zjzc_12:GetModifierMagicalResistanceBonus( params )
	return  6
end
function modifiy_shopmall_zjzc_12:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end