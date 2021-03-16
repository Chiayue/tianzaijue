
modifier_bw_all_22 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_22:GetTexture()
	return "item_treasure/提升攻击"
end
--------------------------------------------------------------------------------
function modifier_bw_all_22:IsHidden()
	return true
end
function modifier_bw_all_22:OnCreated( kv )

	self:OnRefresh()
end


function modifier_bw_all_22:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end


function modifier_bw_all_22:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_all_22:GetModifierBaseDamageOutgoing_Percentage( params )
	return 50*self:GetStackCount()
end

function modifier_bw_all_22:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end