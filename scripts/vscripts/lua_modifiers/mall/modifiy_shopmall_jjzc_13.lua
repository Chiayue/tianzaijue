


modifiy_shopmall_jjzc_13 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_13:GetTexture()
	return "rune/shopmall_jjzc_13"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_13:IsHidden()
	return false
end
function modifiy_shopmall_jjzc_13:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_jjzc_13:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS ,
	}
	return funcs
end

function modifiy_shopmall_jjzc_13:GetModifierPhysicalArmorBonus( params )
	return  10
end
function modifiy_shopmall_jjzc_13:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end