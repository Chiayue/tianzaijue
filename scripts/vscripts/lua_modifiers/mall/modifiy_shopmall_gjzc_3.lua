


modifiy_shopmall_gjzc_3 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_3:GetTexture()
	return "rune/shopmall_gjzc_3"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_3:IsHidden()
	return true
end
function modifiy_shopmall_gjzc_3:OnCreated( kv )
	if IsServer(  ) then
		
	end
end



function modifiy_shopmall_gjzc_3:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifiy_shopmall_gjzc_3:GetModifierBaseDamageOutgoing_Percentage( params )
	return  40
end
function modifiy_shopmall_gjzc_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end