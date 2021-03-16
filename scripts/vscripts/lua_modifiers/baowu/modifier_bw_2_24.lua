
modifier_bw_2_24 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_24:GetTexture()
	return "item_treasure/海洋之心"
end

function modifier_bw_2_24:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_2_24:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_2_24:OnRefresh()

end

--------------------------------------------------------------------------------

function modifier_bw_2_24:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS

	}
	return funcs
end
function modifier_bw_2_24:GetModifierTotalPercentageManaRegen( params )
	return 2
end
function modifier_bw_2_24:GetModifierHealthRegenPercentage( params )
	return 5
end
function modifier_bw_2_24:GetModifierBonusStats_Intellect( params )
	return 250
end
function modifier_bw_2_24:GetModifierBonusStats_Agility( params )
	return 250
end
function modifier_bw_2_24:GetModifierBonusStats_Strength( params )
	return 250
end


function modifier_bw_2_24:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------


