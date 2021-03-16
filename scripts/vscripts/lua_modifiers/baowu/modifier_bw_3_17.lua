
modifier_bw_3_17 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_17:GetTexture()
	return "item_treasure/血精石"
end

function modifier_bw_3_17:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_3_17:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_3_17:OnRefresh()

end

--------------------------------------------------------------------------------

function modifier_bw_3_17:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE

	}
	return funcs
end
function modifier_bw_3_17:GetModifierConstantManaRegen( params )
	return 30
end
function modifier_bw_3_17:GetModifierManaBonus( params )
	return 500
end
function modifier_bw_3_17:GetModifierHealthBonus( params )
	return 20000
end
function modifier_bw_3_17:GetModifierBonusStats_Intellect( params )
	return 2000
end
function modifier_bw_3_17:GetModifierSpellAmplify_Percentage( params )
	return 30
end


function modifier_bw_3_17:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

