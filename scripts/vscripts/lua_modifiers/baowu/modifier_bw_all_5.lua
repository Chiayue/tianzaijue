
modifier_bw_all_5 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_5:GetTexture()
	return "item_treasure/力量偏科"
end
--------------------------------------------------------------------------------
function modifier_bw_all_5:IsHidden()
	return true
end
function modifier_bw_all_5:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_5:OnRefresh()
	if IsServer() then
		self:GetParent():ModifyIntellect(-self:GetParent():GetBaseIntellect()*0.2)	
		self:GetParent():ModifyStrength(self:GetParent():GetBaseStrength()*0.6)
		self:GetParent():ModifyAgility(-self:GetParent():GetBaseAgility()*0.2)
	end
end


function modifier_bw_all_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end