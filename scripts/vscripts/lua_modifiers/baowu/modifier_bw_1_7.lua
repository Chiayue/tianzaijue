
modifier_bw_1_7 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_7:GetTexture()
	return "item_treasure/王冠"
end

function modifier_bw_1_7:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_1_7:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_1_7:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end
--------------------------------------------------------------------------------

function modifier_bw_1_7:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
	}
	return funcs
end
function modifier_bw_1_7:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount()*300
end
function modifier_bw_1_7:GetModifierBonusStats_Agility( params )
	return self:GetStackCount()*300
end
function modifier_bw_1_7:GetModifierBonusStats_Strength( params )
	return self:GetStackCount()*300
end
function modifier_bw_1_7:GetBonusDayVision( params )
	return self:GetStackCount()*300
end
function modifier_bw_1_7:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

