


modifiy_shopmall_zjzc_22 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_22:GetTexture()
	return "rune/shopmall_zjzc_22"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_22:IsHidden()
	return true
end
function modifiy_shopmall_zjzc_22:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--伤害豁免
		temp["jqjc"] = 10
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_zjzc_22:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end