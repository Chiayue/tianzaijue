modifier_hero_state_pro_agi_per = class({})

----------------------------------------

function modifier_hero_state_pro_agi_per:OnCreated( kv )
	
end
function modifier_hero_state_pro_agi_per:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_hero_state_pro_agi_per:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_hero_state_pro_agi_per:GetModifierBonusStats_Agility( params )
	return self:GetStackCount()
end
function modifier_hero_state_pro_agi_per:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end