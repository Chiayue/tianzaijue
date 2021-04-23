


modifiy_shopmall_tszc_2 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_2:GetTexture()
	return "rune/shopmall_cmzc_17"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_tszc_2:IsHidden()
	return true
end
function modifiy_shopmall_tszc_2:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物数量*2
		temp["slbs"] = 0.5
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_tszc_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end