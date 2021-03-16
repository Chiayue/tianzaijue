
modifier_bw_all_4 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_4:GetTexture()
	return "item_treasure/内家拳"
end
--------------------------------------------------------------------------------
function modifier_bw_all_4:IsHidden()
	return true
end
function modifier_bw_all_4:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 60 )
	end
	self:OnRefresh()
end


function modifier_bw_all_4:OnRefresh()
	
end

function modifier_bw_all_4:OnIntervalThink()
	if IsServer() then
		self:GetParent():ModifyIntellect(self:GetParent():GetBaseIntellect()*0.05)
			
		self:GetParent():ModifyStrength(self:GetParent():GetBaseStrength()*0.05)
			
		self:GetParent():ModifyAgility(self:GetParent():GetBaseAgility()*0.05)
	end
end

function modifier_bw_all_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end