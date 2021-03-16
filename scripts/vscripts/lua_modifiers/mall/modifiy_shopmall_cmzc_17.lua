


modifiy_shopmall_cmzc_17 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_17:GetTexture()
	return "rune/shopmall_cmzc_17"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_17:IsHidden()
	return true
end
function modifiy_shopmall_cmzc_17:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物数量*2
		temp["jyjc"] = 100
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_cmzc_17:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end