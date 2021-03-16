
modifier_bw_all_35 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_35:GetTexture()
	return "item_treasure/奥术节能"
end

function modifier_bw_all_35:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_all_35:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_all_35:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end

--------------------------------------------------------------------------------

function modifier_bw_all_35:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,

	}
	return funcs
end

function modifier_bw_all_35:GetModifierPercentageManacost( params )  
	return self:GetStackCount() * 10
end


function modifier_bw_all_35:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

