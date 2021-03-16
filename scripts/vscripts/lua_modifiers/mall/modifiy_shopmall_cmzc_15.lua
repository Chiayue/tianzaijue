


modifiy_shopmall_cmzc_15 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_15:GetTexture()
	return "rune/shopmall_cmzc_15"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_15:IsHidden()
	return false
end
function modifiy_shopmall_cmzc_15:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物数量*2
		temp["jqjc"] = 100
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_cmzc_15:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end