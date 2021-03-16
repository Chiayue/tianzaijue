


modifiy_shopmall_zjzc_7 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_7:GetTexture()
	return "rune/shopmall_zjzc_7"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_7:IsHidden()
	return true
end
function modifiy_shopmall_zjzc_7:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物伤害
		temp["bfbtsll"] = 20
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_zjzc_7:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end