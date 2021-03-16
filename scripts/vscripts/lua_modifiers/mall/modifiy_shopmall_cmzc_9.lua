


modifiy_shopmall_cmzc_9 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_9:GetTexture()
	return "rune/shopmall_cmzc_9"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_9:IsHidden()
	return true
end
function modifiy_shopmall_cmzc_9:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物数量*2
		temp["zhwslbs"] = 1
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_cmzc_9:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end