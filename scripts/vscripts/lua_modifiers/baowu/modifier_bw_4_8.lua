
modifier_bw_4_8 = class({})

--------------------------------------------------------------------------------

function modifier_bw_4_8:GetTexture()
	return "item_treasure/先哲之石"
end

function modifier_bw_4_8:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_4_8:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_4_8:OnRefresh()

end

--------------------------------------------------------------------------------

function modifier_bw_4_8:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE

	}
	return funcs
end
function modifier_bw_4_8:GetModifierConstantManaRegen( params )
	return 60
end
function modifier_bw_4_8:GetModifierBonusStats_Intellect( params )
	return 7777
end
function modifier_bw_4_8:GetModifierSpellAmplify_Percentage( params )
	return 100
end


function modifier_bw_4_8:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

