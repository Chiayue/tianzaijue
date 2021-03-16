
modifier_bw_5_7_buff = class({})

--------------------------------------------------------------------------------

function modifier_bw_5_7_buff:GetTexture()
	return "item_treasure/bw_all_45"
end

function modifier_bw_5_7_buff:IsHidden()
	return false
end
function modifier_bw_5_7_buff:IsDebuff()
	return true
end
function modifier_bw_5_7_buff:IsPurgable()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_5_7_buff:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_5_7_buff:OnRefresh()
	
end
--------------------------------------------------------------------------------
function modifier_bw_5_7_buff:GetEffectName()
	return "particles/items4_fx/spirit_vessel_damage.vpcf"
end
function modifier_bw_5_7_buff:DeclareFunctions()
	local funcs = {
		
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,

	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bw_5_7_buff:GetModifierHealAmplify_PercentageTarget( params )
	return -30
end

--------------------------------------------------------------------------------

function modifier_bw_5_7_buff:GetModifierHPRegenAmplify_Percentage( params )
	return -30
end

--------------------------------------------------------------------------------

function modifier_bw_5_7_buff:GetModifierLifestealRegenAmplify_Percentage( params )
	return -30
end

--------------------------------------------------------------------------------

function modifier_bw_5_7_buff:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return -30
end
function modifier_bw_5_7_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

