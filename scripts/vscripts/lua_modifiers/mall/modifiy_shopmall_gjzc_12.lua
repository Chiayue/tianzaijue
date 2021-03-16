


modifiy_shopmall_gjzc_12 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_12:GetTexture()
	return "rune/shopmall_gjzc_12"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_12:IsHidden()
	return false
end
function modifiy_shopmall_gjzc_12:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_gjzc_12:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifiy_shopmall_gjzc_12:GetModifierMagicalResistanceBonus( params )
	return  12
end
function modifiy_shopmall_gjzc_12:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end