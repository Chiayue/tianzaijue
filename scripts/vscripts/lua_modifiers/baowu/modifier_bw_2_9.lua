
modifier_bw_2_9 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_9:GetTexture()
	return "item_treasure/动力鞋"
end
--------------------------------------------------------------------------------
function modifier_bw_2_9:IsHidden()
	return true
end
function modifier_bw_2_9:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_9:OnRefresh()
	
end


function modifier_bw_2_9:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifier_bw_2_9:GetModifierMoveSpeedBonus_Constant( params )
	return 60
end

function modifier_bw_2_9:GetModifierBonusStats_Intellect( params )
	return 300
end
function modifier_bw_2_9:GetModifierBonusStats_Agility( params )
	return 300
end
function modifier_bw_2_9:GetModifierBonusStats_Strength( params )
	return 300
end
function modifier_bw_2_9:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end