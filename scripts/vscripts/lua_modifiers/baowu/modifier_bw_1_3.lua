
modifier_bw_1_3 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_3:GetTexture()
	return "item_treasure/虚无宝石"
end

function modifier_bw_1_3:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_1_3:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_1_3:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end

--------------------------------------------------------------------------------

function modifier_bw_1_3:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_1_3:GetModifierConstantManaRegen( params )
	return self:GetStackCount()*10
end
function modifier_bw_1_3:GetModifierTotalPercentageManaRegen( params )
	return self:GetStackCount()
end
function modifier_bw_1_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

