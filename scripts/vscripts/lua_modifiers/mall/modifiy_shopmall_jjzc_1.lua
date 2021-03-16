


modifiy_shopmall_jjzc_1 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_1:GetTexture()
	return "rune/shopmall_jjzc_1"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_1:IsHidden()
	return true
end
function modifiy_shopmall_jjzc_1:OnCreated( kv )
	if IsServer(  ) then
		
	end
end



function modifiy_shopmall_jjzc_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_BONUS ,
	}
	return funcs
end

function modifiy_shopmall_jjzc_1:GetModifierManaBonus( params )
	return  50
end
function modifiy_shopmall_jjzc_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end