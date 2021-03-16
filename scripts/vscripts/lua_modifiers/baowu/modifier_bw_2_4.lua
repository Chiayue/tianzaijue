
modifier_bw_2_4 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_4:GetTexture()
	return "item_treasure/慧光"
end
--------------------------------------------------------------------------------

function modifier_bw_2_4:IsHidden()
	return true
end
function modifier_bw_2_4:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_4:OnRefresh()
	
end
function modifier_bw_2_4:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_2_4:GetModifierBonusStats_Intellect( params )
	return 600
end
function modifier_bw_2_4:GetModifierSpellAmplify_Percentage( params )
	return 30
end
function modifier_bw_2_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end