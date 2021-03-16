


modifiy_shopmall_tszc_3 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_3:GetTexture()
	return "rune/shopmall_tszc_3"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_tszc_3:IsHidden()
	return true
end
function modifiy_shopmall_tszc_3:OnCreated( kv )
	if IsServer(  ) then
		
	end
end



function modifiy_shopmall_tszc_3:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

function modifiy_shopmall_tszc_3:GetModifierStatusResistanceStacking( params )
	return  100
end
function modifiy_shopmall_tszc_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end