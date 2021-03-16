
modifier_bw_2_6 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_6:GetTexture()
	return "item_treasure/散华"
end
--------------------------------------------------------------------------------

function modifier_bw_2_6:IsHidden()
	return true
end
function modifier_bw_2_6:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_6:OnRefresh()
	
end


function modifier_bw_2_6:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifier_bw_2_6:GetModifierBonusStats_Strength( params )
	return 600
end
function modifier_bw_2_6:GetModifierMagicalResistanceBonus( params )
	return  20
end
function modifier_bw_2_6:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end