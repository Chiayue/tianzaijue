
modifier_bw_all_16 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_16:GetTexture()
	return "item_treasure/快速恢复"
end
--------------------------------------------------------------------------------
function modifier_bw_all_16:IsHidden()
	return true
end
function modifier_bw_all_16:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_16:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end


function modifier_bw_all_16:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_all_16:GetModifierHealthRegenPercentage( params )
	return 6*self:GetStackCount()
end
function modifier_bw_all_16:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end