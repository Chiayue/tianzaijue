


modifiy_shopmall_zjzc_8 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_zjzc_8:GetTexture()
	return "rune/shopmall_zjzc_8"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_zjzc_8:IsHidden()
	return true
end
function modifiy_shopmall_zjzc_8:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--百分比提升基础敏捷
		temp["bfbtsmj"] = 20
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_zjzc_8:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end