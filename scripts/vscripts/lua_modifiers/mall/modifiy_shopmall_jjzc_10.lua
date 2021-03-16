


modifiy_shopmall_jjzc_10 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_10:GetTexture()
	return "rune/shopmall_jjzc_10"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_10:IsHidden()
	return false
end
function modifiy_shopmall_jjzc_10:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_jjzc_10:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifiy_shopmall_jjzc_10:GetModifierAttackSpeedBonus_Constant( params )
	return  10
end
function modifiy_shopmall_jjzc_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end