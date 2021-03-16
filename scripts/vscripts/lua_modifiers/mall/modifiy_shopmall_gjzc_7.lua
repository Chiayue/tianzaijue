


modifiy_shopmall_gjzc_7 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_7:GetTexture()
	return "rune/shopmall_gjzc_7"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_7:IsHidden()
	return false
end
function modifiy_shopmall_gjzc_7:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--百分比提升基础力量
		temp["bfbtsll"] = 40
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_gjzc_7:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end