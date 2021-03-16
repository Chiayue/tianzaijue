


modifiy_shopmall_gjzc_5 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_5:GetTexture()
	return "rune/shopmall_gjzc_5"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_5:IsHidden()
	return true
end
function modifiy_shopmall_gjzc_5:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_gjzc_5:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

function modifiy_shopmall_gjzc_5:GetModifierConstantManaRegen( params )
	return  8
end
function modifiy_shopmall_gjzc_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end