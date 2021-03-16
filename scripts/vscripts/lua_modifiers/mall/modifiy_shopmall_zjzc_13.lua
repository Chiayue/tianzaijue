


modifiy_shopmall_zjzc_13 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_13:GetTexture()
	return "rune/shopmall_zjzc_13"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_13:IsHidden()
	return true
end
function modifiy_shopmall_zjzc_13:OnCreated( kv )
	if IsServer() then
	end
end



function modifiy_shopmall_zjzc_13:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS ,
	}
	return funcs
end

function modifiy_shopmall_zjzc_13:GetModifierPhysicalArmorBonus( params )
	return  20
end
function modifiy_shopmall_zjzc_13:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end