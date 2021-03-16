


modifiy_shopmall_cmzc_1 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_1:GetTexture()
	return "rune/shopmall_cmzc_1"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_1:IsHidden()
	return false
end
function modifiy_shopmall_cmzc_1:OnCreated( kv )
	if IsServer(  ) then
		
	end
end
function modifiy_shopmall_cmzc_1:OnRefresh()
	
end



function modifiy_shopmall_cmzc_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end