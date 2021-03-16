modifier_hero_state_pro = class({})

----------------------------------------

function modifier_hero_state_pro_maxhealth:OnCreated( kv )
	
end

--------------------------------------------------------------------------------

function modifier_hero_state_pro_maxhealth:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_hero_state_pro_maxhealth:GetModifierHealthBonus( params )
	return self:GetStackCount()
end
function modifier_hero_state_pro_agi_per:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end