


modifiy_shopmall_cmzc_3 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_3:GetTexture()
	return "rune/shopmall_cmzc_3"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_3:IsHidden()
	return true
end
function modifiy_shopmall_cmzc_3:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		--多重施法次数+1
		temp["dcsfcs"] = 1
		AttributesSet(self:GetParent(),temp)
	end
end




function modifiy_shopmall_cmzc_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end