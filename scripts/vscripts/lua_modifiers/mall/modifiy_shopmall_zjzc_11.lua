


modifiy_shopmall_zjzc_11 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_11:GetTexture()
	return "rune/shopmall_zjzc_11"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_11:IsHidden()
	return true
end
function modifiy_shopmall_zjzc_11:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_zjzc_11:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifiy_shopmall_zjzc_11:GetModifierMoveSpeedBonus_Constant( params )
	return  10
end
function modifiy_shopmall_zjzc_11:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end