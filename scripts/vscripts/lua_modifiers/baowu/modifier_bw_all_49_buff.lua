
modifier_bw_all_49_buff = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_49_buff:GetTexture()
	return "item_treasure/bw_all_49"
end

function modifier_bw_all_49_buff:IsHidden()
	return false
end
--------------------------------------------------------------------------------

function modifier_bw_all_49_buff:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_all_49_buff:OnRefresh()
	
end
--------------------------------------------------------------------------------

function modifier_bw_all_49_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifier_bw_all_49_buff:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount()
end
function modifier_bw_all_49_buff:GetModifierBonusStats_Agility( params )
	return self:GetStackCount()
end
function modifier_bw_all_49_buff:GetModifierBonusStats_Strength( params )
	return self:GetStackCount()
end
function modifier_bw_all_49_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

