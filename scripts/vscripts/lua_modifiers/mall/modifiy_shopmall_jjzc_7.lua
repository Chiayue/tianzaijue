


modifiy_shopmall_jjzc_7 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_7:GetTexture()
	return "rune/shopmall_jjzc_7"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_7:IsHidden()
	return true
end
function modifiy_shopmall_jjzc_7:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物伤害
		temp["bfbtsll"] = 10
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_jjzc_7:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end