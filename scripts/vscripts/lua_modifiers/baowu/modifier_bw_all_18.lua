
modifier_bw_all_18 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_18:GetTexture()
	return "item_treasure/提升体质"
end
--------------------------------------------------------------------------------
function modifier_bw_all_18:IsHidden()
	return true
end
function modifier_bw_all_18:OnCreated( kv )
	self:OnRefresh()
end


function modifier_bw_all_18:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end


function modifier_bw_all_18:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_all_18:GetModifierExtraHealthPercentage( params )
	
	return 30*self:GetStackCount()
end
function modifier_bw_all_18:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end