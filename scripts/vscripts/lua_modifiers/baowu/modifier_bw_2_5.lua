
modifier_bw_2_5 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_5:GetTexture()
	return "item_treasure/夜叉"
end
--------------------------------------------------------------------------------

function modifier_bw_2_5:IsHidden()
	return true
end
function modifier_bw_2_5:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_5:OnRefresh()
	
end

function modifier_bw_2_5:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_bw_2_5:GetModifierBonusStats_Agility( params )
	return 600
end
function modifier_bw_2_5:GetModifierAttackSpeedBonus_Constant( params )
	return 50
end
function modifier_bw_2_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end