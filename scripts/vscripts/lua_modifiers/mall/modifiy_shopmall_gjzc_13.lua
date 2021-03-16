


modifiy_shopmall_gjzc_13 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_13:GetTexture()
	return "rune/shopmall_gjzc_13"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_13:IsHidden()
	return true
end
function modifiy_shopmall_gjzc_13:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_gjzc_13:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS ,
	}
	return funcs
end

function modifiy_shopmall_gjzc_13:GetModifierPhysicalArmorBonus( params )
	return  40
end
function modifiy_shopmall_gjzc_13:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end