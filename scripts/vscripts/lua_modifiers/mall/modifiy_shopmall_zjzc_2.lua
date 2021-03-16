


modifiy_shopmall_zjzc_2 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_2:GetTexture()
	return "rune/shopmall_zjzc_2"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_2:IsHidden()
	return true
end
function modifiy_shopmall_zjzc_2:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物伤害
		temp["zhwsh"] = 20
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_zjzc_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end