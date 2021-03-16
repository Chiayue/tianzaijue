
modifier_ch_1_1 = class({})

--------------------------------------------------------------------------------

function modifier_ch_1_1:GetTexture()
	return "item_treasure/力量护腕"
end

function modifier_ch_1_1:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_ch_1_1:OnCreated( kv )
	self:OnRefresh()
end
--------------------------------------------------------------------------------

function modifier_ch_1_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end
function modifier_ch_1_1:GetModifierBonusStats_Strength( params )
	return 20
end
function modifier_ch_1_1:GetModifierBonusStats_Agility( params )
	return 20
end
function modifier_ch_1_1:GetModifierBonusStats_Intellect( params )
	return 20
end

function modifier_ch_1_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

