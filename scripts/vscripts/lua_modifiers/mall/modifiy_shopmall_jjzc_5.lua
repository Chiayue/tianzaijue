


modifiy_shopmall_jjzc_5 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_5:GetTexture()
	return "rune/shopmall_jjzc_5"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_5:IsHidden()
	return false
end
function modifiy_shopmall_jjzc_5:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_jjzc_5:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

function modifiy_shopmall_jjzc_5:GetModifierConstantManaRegen( params )
	return  2
end
function modifiy_shopmall_jjzc_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end