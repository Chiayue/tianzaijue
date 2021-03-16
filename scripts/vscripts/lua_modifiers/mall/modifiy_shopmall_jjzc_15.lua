


modifiy_shopmall_jjzc_15 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_15:GetTexture()
	return "rune/shopmall_jjzc_15"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_15:IsHidden()
	return false
end
function modifiy_shopmall_jjzc_15:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--暴击概率
		temp["wlbjgl"] = 2
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_jjzc_15:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end