


modifiy_shopmall_jjzc_16 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_16:GetTexture()
	return "rune/shopmall_jjzc_16"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_16:IsHidden()
	return false
end
function modifiy_shopmall_jjzc_16:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--暴击伤害
		temp["bjsh"] = 10
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_jjzc_16:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end