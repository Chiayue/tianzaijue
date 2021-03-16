
modifier_bw_all_10 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_10:GetTexture()
	return "item_treasure/保命要紧"
end
--------------------------------------------------------------------------------
function modifier_bw_all_10:IsHidden()
	return true
end
function modifier_bw_all_10:OnCreated( kv )
	
	if IsServer() then
		print("base"..self:GetParent():GetPhysicalArmorBaseValue())
		self:GetParent():SetPhysicalArmorBaseValue(self:GetParent():GetPhysicalArmorBaseValue()*0.5)
		print("baseup"..self:GetParent():GetPhysicalArmorBaseValue())
		self:GetParent():ModifyStrength(-self:GetParent():GetBaseStrength()*0.2)
		self:GetParent():ModifyAgility(-self:GetParent():GetBaseAgility()*0.2)
		self:GetParent():ModifyIntellect(-self:GetParent():GetBaseIntellect()*0.2)
	end
end





function modifier_bw_all_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end