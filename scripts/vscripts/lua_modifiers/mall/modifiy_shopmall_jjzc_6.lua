


modifiy_shopmall_jjzc_6 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_6:GetTexture()
	return "rune/shopmall_jjzc_6"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_6:IsHidden()
	return true
end
function modifiy_shopmall_jjzc_6:OnCreated( kv )
	if IsServer(  ) then
		
	end
end



function modifiy_shopmall_jjzc_6:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE ,
	}
	return funcs
end

function modifiy_shopmall_jjzc_6:GetModifierExtraHealthPercentage( params )
	return  5
end
function modifiy_shopmall_jjzc_6:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end