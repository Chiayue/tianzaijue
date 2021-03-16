


modifiy_shopmall_jjzc_22 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_22:GetTexture()
	return "rune/shopmall_jjzc_22"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_22:IsHidden()
	return true
end
function modifiy_shopmall_jjzc_22:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--伤害豁免
		temp["jqjc"] = 5
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_jjzc_22:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end