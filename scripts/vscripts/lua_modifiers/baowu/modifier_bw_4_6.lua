
modifier_bw_4_6 = class({})

--------------------------------------------------------------------------------

function modifier_bw_4_6:GetTexture()
	return "item_treasure/三元重戟"
end
--------------------------------------------------------------------------------
function modifier_bw_4_6:IsHidden()
	return true
end
function modifier_bw_4_6:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_4_6:OnRefresh()
	
end


function modifier_bw_4_6:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_4_6:GetModifierBonusStats_Intellect( params )
	return 6666
end
function modifier_bw_4_6:GetModifierBonusStats_Agility( params )
	return 6666
end
function modifier_bw_4_6:GetModifierBonusStats_Strength( params )
	return 6666
end
function modifier_bw_4_6:GetModifierAttackSpeedBonus_Constant( params )
	return 99
end
function modifier_bw_4_6:GetModifierMagicalResistanceBonus( params )
	return  50
end
function modifier_bw_4_6:GetModifierStatusResistanceStacking( params )
	return 30
end
function modifier_bw_4_6:GetModifierMoveSpeedBonus_Constant( params )
	return 50
end
function modifier_bw_4_6:GetModifierSpellAmplify_Percentage( params )
	return 99
end
function modifier_bw_4_6:GetModifierBaseDamageOutgoing_Percentage( params )
	return 99
end

function modifier_bw_4_6:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end