


modifiy_shopmall_gjzc_9 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_9:GetTexture()
	return "rune/shopmall_gjzc_9"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_9:IsHidden()
	return false
end
function modifiy_shopmall_gjzc_9:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--百分比提升基础智力
		temp["bfbtszl"] = 40
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_gjzc_9:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end