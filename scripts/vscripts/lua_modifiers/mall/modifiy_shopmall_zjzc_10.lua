


modifiy_shopmall_zjzc_10 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_10:GetTexture()
	return "rune/shopmall_zjzc_10"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_10:IsHidden()
	return true
end
function modifiy_shopmall_zjzc_10:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_zjzc_10:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifiy_shopmall_zjzc_10:GetModifierAttackSpeedBonus_Constant( params )
	return  20
end
function modifiy_shopmall_zjzc_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end