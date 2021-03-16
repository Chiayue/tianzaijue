
modifier_bw_3_12 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_12:GetTexture()
	return "item_treasure/蝴蝶"
end
--------------------------------------------------------------------------------
function modifier_bw_3_12:IsHidden()
	return true
end
function modifier_bw_3_12:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_12:OnRefresh()
	
end


function modifier_bw_3_12:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
	return funcs
end
function modifier_bw_3_12:GetModifierBonusStats_Agility( params )
	return 1500
end
function modifier_bw_3_12:GetModifierPreAttack_BonusDamage( params )
	
	return 8000
end
function modifier_bw_3_12:GetModifierMoveSpeedBonus_Percentage( params )
	return 15
end
function modifier_bw_3_12:GetModifierEvasion_Constant( params )
	return 35
end
function modifier_bw_3_12:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end