


modifiy_shopmall_gjzc_22 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_22:GetTexture()
	return "rune/shopmall_gjzc_22"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_22:IsHidden()
	return false
end
function modifiy_shopmall_gjzc_22:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--伤害豁免
		temp["jqjc"] = 20
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_gjzc_22:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end