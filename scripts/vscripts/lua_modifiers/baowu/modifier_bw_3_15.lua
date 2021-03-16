
modifier_bw_3_15 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_15:GetTexture()
	return "item_treasure/恐鳌之心"
end
--------------------------------------------------------------------------------
function modifier_bw_3_15:IsHidden()
	return true
end
function modifier_bw_3_15:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_15:OnRefresh()
	
end


function modifier_bw_3_15:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end
function modifier_bw_3_15:GetModifierBonusStats_Strength( params )
	return 3000
end
function modifier_bw_3_15:GetModifierHealthRegenPercentage( params )
	return  5
end
function modifier_bw_3_15:GetModifierHealthBonus( params )
	return  50000
end

function modifier_bw_3_15:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end