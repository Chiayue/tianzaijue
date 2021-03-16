


modifiy_shopmall_jjzc_14 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_14:GetTexture()
	return "rune/shopmall_jjzc_14"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_14:IsHidden()
	return false
end
function modifiy_shopmall_jjzc_14:OnCreated( kv )
	if IsServer(  ) then
	end
end



function modifiy_shopmall_jjzc_14:DeclareFunctions()
	local funcs = 
	{
		
	}
	return funcs
end

function modifiy_shopmall_jjzc_14:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end