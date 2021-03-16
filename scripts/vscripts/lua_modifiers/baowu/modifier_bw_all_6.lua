
modifier_bw_all_6 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_6:GetTexture()
	return "item_treasure/敏捷偏科"
end
--------------------------------------------------------------------------------
function modifier_bw_all_6:IsHidden()
	return true
end
function modifier_bw_all_6:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_6:OnRefresh()
	if IsServer() then
		self:GetParent():ModifyIntellect(-self:GetParent():GetBaseIntellect()*0.2)
			
		self:GetParent():ModifyStrength(-self:GetParent():GetBaseStrength()*0.2)
			
		self:GetParent():ModifyAgility(self:GetParent():GetBaseAgility()*0.6)
	end
end


function modifier_bw_all_6:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end