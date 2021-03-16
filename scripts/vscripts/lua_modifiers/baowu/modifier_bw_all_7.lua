
modifier_bw_all_7 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_7:GetTexture()
	return "item_treasure/智力偏科"
end
--------------------------------------------------------------------------------
function modifier_bw_all_7:IsHidden()
	return true
end
function modifier_bw_all_7:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_7:OnRefresh()
	if IsServer() then
		self:GetParent():ModifyIntellect(self:GetParent():GetBaseIntellect()*0.6)
			
		self:GetParent():ModifyStrength(-self:GetParent():GetBaseStrength()*0.2)
			
		self:GetParent():ModifyAgility(-self:GetParent():GetBaseAgility()*0.2)
	end
end

function modifier_bw_all_7:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end