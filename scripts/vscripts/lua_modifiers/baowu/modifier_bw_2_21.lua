
modifier_bw_2_21 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_21:GetTexture()
	return "item_treasure/EUL的神圣法杖"
end

function modifier_bw_2_21:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_2_21:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_2_21:OnRefresh()

end

--------------------------------------------------------------------------------

function modifier_bw_2_21:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT

	}
	return funcs
end
function modifier_bw_2_21:GetModifierConstantManaRegen( params )
	return 15
end

function modifier_bw_2_21:GetModifierBonusStats_Intellect( params )
	return 900
end
function modifier_bw_2_21:GetModifierMoveSpeedBonus_Constant( params )
	return 40
end


function modifier_bw_2_21:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

