


modifiy_shopmall_zjzc_6 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_6:GetTexture()
	return "rune/shopmall_zjzc_6"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_6:IsHidden()
	return true
end
function modifiy_shopmall_zjzc_6:OnCreated( kv )
	if IsServer(  ) then
		
	end
end



function modifiy_shopmall_zjzc_6:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE ,
	}
	return funcs
end

function modifiy_shopmall_zjzc_6:GetModifierExtraHealthPercentage( params )
	return  10
end
function modifiy_shopmall_zjzc_6:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end