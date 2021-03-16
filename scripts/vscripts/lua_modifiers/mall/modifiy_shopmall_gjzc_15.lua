


modifiy_shopmall_gjzc_15 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_15:GetTexture()
	return "rune/shopmall_gjzc_15"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_15:IsHidden()
	return true
end
function modifiy_shopmall_gjzc_15:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--暴击概率
		temp["wlbjgl"] = 6
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_gjzc_15:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end