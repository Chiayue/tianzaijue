


modifiy_shopmall_tszc_9 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_9:GetTexture()
	return "rune/shopmall_cmzc_17"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_tszc_9:IsHidden()
	return true
end
function modifiy_shopmall_tszc_9:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--召唤物数量*2
		temp["jnmjts"] = 0.6
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_tszc_9:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end