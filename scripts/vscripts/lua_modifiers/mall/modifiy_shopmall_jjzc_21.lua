


modifiy_shopmall_jjzc_21 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_21:GetTexture()
	return "rune/shopmall_jjzc_21"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_21:IsHidden()
	return false
end
function modifiy_shopmall_jjzc_21:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--伤害豁免
		temp["shhm"] = 1
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_jjzc_21:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end