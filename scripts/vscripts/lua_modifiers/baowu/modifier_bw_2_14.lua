
modifier_bw_2_14 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_14:GetTexture()
	return "item_treasure/幽冥披巾"
end
--------------------------------------------------------------------------------
function modifier_bw_2_14:IsHidden()
	return true
end
function modifier_bw_2_14:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_14:OnRefresh()
	
end


function modifier_bw_2_14:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_2_14:GetModifierPhysicalArmorBonus( params )
	return  -20
end
function modifier_bw_2_14:GetModifierMagicalResistanceBonus( params )
	return  30
end
function modifier_bw_2_14:GetModifierSpellAmplify_Percentage( params )
	return  40
end
function modifier_bw_2_14:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end