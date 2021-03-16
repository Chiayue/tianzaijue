


modifiy_shopmall_tszc_2 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_2:GetTexture()
	return "rune/shopmall_tszc_2"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_tszc_2:IsHidden()
	return true
end
function modifiy_shopmall_tszc_2:OnCreated( kv )
	if IsServer(  ) then
		
	end
end



function modifiy_shopmall_tszc_2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end

function modifiy_shopmall_tszc_2:GetModifierBaseAttackTimeConstant( params )
	return  0.5
end
function modifiy_shopmall_tszc_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end