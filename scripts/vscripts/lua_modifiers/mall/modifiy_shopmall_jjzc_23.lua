


modifiy_shopmall_jjzc_23 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_23:GetTexture()
	return "rune/shopmall_jjzc_23"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_23:IsHidden()
	return true
end
function modifiy_shopmall_jjzc_23:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--伤害豁免
		temp["jyjc"] = 5
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_jjzc_23:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end