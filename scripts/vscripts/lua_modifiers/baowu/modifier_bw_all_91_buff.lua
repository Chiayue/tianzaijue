
modifier_bw_all_91_buff = class({})
function modifier_bw_all_91_buff:GetTexture()
	return "item_treasure/modifier_bw_all_91_buff"
end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_bw_all_91_buff:GetEffectName()
	return "particles/items4_fx/spirit_vessel_damage.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bw_all_91_buff:OnCreated( kv )
	self:OnRefresh()
end


--------------------------------------------------------------------------------

function modifier_bw_all_91_buff:OnRefresh( kv )
	
end

--------------------------------------------------------------------------------

function modifier_bw_all_91_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_bw_all_91_buff:GetModifierHealAmplify_PercentageTarget( params )
	return -50
end

--------------------------------------------------------------------------------

function modifier_bw_all_91_buff:GetModifierHPRegenAmplify_Percentage( params )
	return -50
end

--------------------------------------------------------------------------------

function modifier_bw_all_91_buff:GetModifierLifestealRegenAmplify_Percentage( params )
	return -50
end

--------------------------------------------------------------------------------

function modifier_bw_all_91_buff:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return -50
end