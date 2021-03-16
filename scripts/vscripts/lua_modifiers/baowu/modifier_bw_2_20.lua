
modifier_bw_2_20 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_20:GetTexture()
	return "item_treasure/精华指环"
end

function modifier_bw_2_20:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_2_20:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_2_20:OnRefresh()
	
end

--------------------------------------------------------------------------------

function modifier_bw_2_20:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
	return funcs
end
function modifier_bw_2_20:GetModifierConstantManaRegen( params )
	return 10
end
function modifier_bw_2_20:GetModifierManaBonus( params )
	return 200
end
function modifier_bw_2_20:GetModifierHealthBonus( params )
	return 10000
end
function modifier_bw_2_20:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

