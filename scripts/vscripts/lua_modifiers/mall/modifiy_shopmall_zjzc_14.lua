


modifiy_shopmall_zjzc_14 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_14:GetTexture()
	return "rune/shopmall_zjzc_14"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_14:IsHidden()
	return true
end
function modifiy_shopmall_zjzc_14:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_zjzc_14:DeclareFunctions()
	local funcs = 
	{
		
	}
	return funcs
end

function modifiy_shopmall_zjzc_14:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end