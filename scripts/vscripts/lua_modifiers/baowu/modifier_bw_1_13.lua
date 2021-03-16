
modifier_bw_1_13 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_13:GetTexture()
	return "item_treasure/基恩镜片"
end

function modifier_bw_1_13:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_1_13:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_1_13:OnRefresh()
	
end

--------------------------------------------------------------------------------

function modifier_bw_1_13:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
	return funcs
end
function modifier_bw_1_13:GetModifierConstantManaRegen( params )
	return 15
end
function modifier_bw_1_13:GetModifierManaBonus( params )
	return 150
end
function modifier_bw_1_13:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

