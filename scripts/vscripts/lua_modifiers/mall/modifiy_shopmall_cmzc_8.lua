


modifiy_shopmall_cmzc_8 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_8:GetTexture()
	return "rune/shopmall_cmzc_8"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_8:IsHidden()
	return false
end
function modifiy_shopmall_cmzc_8:OnCreated( kv )
	if IsServer(  ) then
	
	end
end




function modifiy_shopmall_cmzc_8:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end