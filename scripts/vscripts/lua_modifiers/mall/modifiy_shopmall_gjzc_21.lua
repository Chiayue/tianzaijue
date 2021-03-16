


modifiy_shopmall_gjzc_21 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_21:GetTexture()
	return "rune/shopmall_gjzc_21"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_21:IsHidden()
	return true
end
function modifiy_shopmall_gjzc_21:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--伤害豁免
		temp["shhm"] = 4
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_gjzc_21:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end