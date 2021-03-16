modifier_hero_state_pro_str_per = class({})

----------------------------------------

function modifier_hero_state_pro_str_per:OnCreated( kv )
	
end
function modifier_hero_state_pro_str_per:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_hero_state_pro_str_per:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------
function modifier_hero_state_pro_str_per:GetModifierBonusStats_Strength( params )	--力量
	return self:GetStackCount()
end
function modifier_hero_state_pro_str_per:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end