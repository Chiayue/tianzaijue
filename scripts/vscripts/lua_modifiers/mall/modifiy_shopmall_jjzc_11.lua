


modifiy_shopmall_jjzc_11 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_11:GetTexture()
	return "rune/shopmall_jjzc_11"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_11:IsHidden()
	return false
end
function modifiy_shopmall_jjzc_11:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_jjzc_11:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifiy_shopmall_jjzc_11:GetModifierMoveSpeedBonus_Constant( params )
	return  5
end
function modifiy_shopmall_jjzc_11:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end