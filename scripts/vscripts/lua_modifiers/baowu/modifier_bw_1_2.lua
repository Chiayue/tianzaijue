
modifier_bw_1_2 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_2:GetTexture()
	return "item_treasure/治疗指环"
end

function modifier_bw_1_2:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_1_2:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_1_2:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end

--------------------------------------------------------------------------------

function modifier_bw_1_2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_1_2:GetModifierConstantHealthRegen( params )
	return self:GetStackCount()*200
end
function modifier_bw_1_2:GetModifierHealthRegenPercentage( params )
	return self:GetStackCount() *3
end

function modifier_bw_1_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

