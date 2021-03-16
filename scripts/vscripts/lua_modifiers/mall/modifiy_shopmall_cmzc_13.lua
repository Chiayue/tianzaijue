


modifiy_shopmall_cmzc_13 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_13:GetTexture()
	return "rune/shopmall_cmzc_11"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_13:IsHidden()
	return true
end
function modifiy_shopmall_cmzc_13:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物强度+100
		temp["zhwsh"] = 100
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_cmzc_13:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end