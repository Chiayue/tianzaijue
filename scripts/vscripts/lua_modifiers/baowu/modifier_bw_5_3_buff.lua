
modifier_bw_5_3_buff = class({})

--------------------------------------------------------------------------------

function modifier_bw_5_3_buff:GetTexture()
	return "item_treasure/bw_all_45"
end

function modifier_bw_5_3_buff:IsHidden()
	return false
end
--------------------------------------------------------------------------------

function modifier_bw_5_3_buff:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_5_3_buff:OnRefresh()
	
end
--------------------------------------------------------------------------------

function modifier_bw_5_3_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifier_bw_5_3_buff:GetModifierSpellAmplify_Percentage	( params )
	return self:GetStackCount() * 3
end

function modifier_bw_5_3_buff:GetModifierBonusStats_Strength( params )
	return self:GetStackCount() *200
end
function modifier_bw_5_3_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

