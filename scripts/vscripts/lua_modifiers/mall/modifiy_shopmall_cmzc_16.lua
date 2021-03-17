


modifiy_shopmall_cmzc_16 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_16:GetTexture()
	return "rune/shopmall_cmzc_9"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_16:IsHidden()
	return true
end
function modifiy_shopmall_cmzc_16:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物数量*2
		temp["tmz"] = 40
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_cmzc_16:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end