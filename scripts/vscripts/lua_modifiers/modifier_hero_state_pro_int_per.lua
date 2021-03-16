modifier_hero_state_pro_int_per = class({})

----------------------------------------

function modifier_hero_state_pro_int_per:OnCreated( kv )
	
end
function modifier_hero_state_pro_int_per:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_hero_state_pro_int_per:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------
function modifier_hero_state_pro_int_per:GetModifierBonusStats_Intellect( params )	--智力
	return self:GetStackCount()
end
function modifier_hero_state_pro_int_per:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end