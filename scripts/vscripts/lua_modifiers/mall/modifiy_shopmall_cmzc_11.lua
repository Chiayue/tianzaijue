


modifiy_shopmall_cmzc_11 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_11:GetTexture()
	return "rune/shopmall_cmzc_11"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_11:IsHidden()
	return true
end
function modifiy_shopmall_cmzc_11:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物数量*2
		temp["wlbjgl"] = 20
		temp["wlbjsh"] = 100
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_cmzc_11:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end