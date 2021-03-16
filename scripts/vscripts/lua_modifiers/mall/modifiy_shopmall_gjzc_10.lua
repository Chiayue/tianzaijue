


modifiy_shopmall_gjzc_10 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_10:GetTexture()
	return "rune/shopmall_gjzc_10"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_10:IsHidden()
	return false
end
function modifiy_shopmall_gjzc_10:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_gjzc_10:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifiy_shopmall_gjzc_10:GetModifierAttackSpeedBonus_Constant( params )
	return  40
end
function modifiy_shopmall_gjzc_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end