
modifier_bw_all_9 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_9:GetTexture()
	return "item_treasure/孤注一掷"
end
--------------------------------------------------------------------------------
function modifier_bw_all_9:IsHidden()
	return true
end
function modifier_bw_all_9:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_9:OnRefresh()
	if IsServer() then
		
		local armor=self:GetParent():GetPhysicalArmorBaseValue()*30
		print("base"..armor)
		if self:GetParent():GetPrimaryAttribute()==2 then
			self:GetParent():ModifyIntellect(armor)
			--self:GetParent():SetPhysicalArmorBaseValue(self:GetParent():GetPhysicalArmorBaseValue()*-1)
		end
		if self:GetParent():GetPrimaryAttribute()==0 then
			self:GetParent():ModifyStrength(armor)
			--self:GetParent():SetPhysicalArmorBaseValue(self:GetParent():GetPhysicalArmorBaseValue()*-1)
		end
		if self:GetParent():GetPrimaryAttribute()==1 then
			self:GetParent():ModifyAgility(armor)
			--self:GetParent():SetPhysicalArmorBaseValue(self:GetParent():GetPhysicalArmorBaseValue()*-1)
		end
		
		
		
	end
end


function modifier_bw_all_9:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end