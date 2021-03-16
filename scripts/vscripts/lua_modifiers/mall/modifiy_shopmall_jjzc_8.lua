


modifiy_shopmall_jjzc_8 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_8:GetTexture()
	return "rune/shopmall_jjzc_8"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_8:IsHidden()
	return false
end
function modifiy_shopmall_jjzc_8:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--百分比提升基础敏捷
		temp["bfbtsmj"] = 10
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_jjzc_8:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end