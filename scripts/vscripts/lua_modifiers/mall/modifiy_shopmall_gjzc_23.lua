


modifiy_shopmall_gjzc_23 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_23:GetTexture()
	return "rune/shopmall_gjzc_23"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_23:IsHidden()
	return false
end
function modifiy_shopmall_gjzc_23:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--伤害豁免
		temp["jyjc"] = 20
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_gjzc_23:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end