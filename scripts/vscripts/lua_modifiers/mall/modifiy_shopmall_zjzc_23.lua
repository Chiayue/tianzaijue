


modifiy_shopmall_zjzc_23 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_23:GetTexture()
	return "rune/shopmall_zjzc_23"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_23:IsHidden()
	return false
end
function modifiy_shopmall_zjzc_23:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--伤害豁免
		temp["jyjc"] = 20
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_zjzc_23:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end