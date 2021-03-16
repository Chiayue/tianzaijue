


modifiy_shopmall_gjzc_1 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_1:GetTexture()
	return "rune/shopmall_gjzc_1"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_1:IsHidden()
	return false
end
function modifiy_shopmall_gjzc_1:OnCreated( kv )
	if IsServer(  ) then
		
	end
end



function modifiy_shopmall_gjzc_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_BONUS ,
	}
	return funcs
end

function modifiy_shopmall_gjzc_1:GetModifierManaBonus( params )
	return  200
end
function modifiy_shopmall_gjzc_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end