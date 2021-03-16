
modifier_bw_5_6_buff = class({})
function modifier_bw_5_6_buff:GetTexture()
	return "item_treasure/modifier_bw_5_6_buff"
end
--------------------------------------------------------------------------------

function modifier_bw_5_6_buff:OnCreated( kv )
	if IsServer() then
		--print( "test" )
	end
end

--------------------------------------------------------------------------------

function modifier_bw_5_6_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,

	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bw_5_6_buff:GetModifierBaseDamageOutgoing_Percentage( params )
	return 100
end

--------------------------------------------------------------------------------
function modifier_bw_5_6_buff:GetModifierAttackSpeedBonus_Constant( params )
	return 100
end

function modifier_bw_5_6_buff:GetModifierAttackSpeedBonus_Constant( params )
	return 100
end

function modifier_bw_5_6_buff:GetModifierMoveSpeedBonus_Percentage( params )
	return 20
end
function modifier_bw_5_6_buff:GetModifierAttackRangeBonus( params )
	return 200
end

function modifier_bw_5_6_buff:GetModifierSpellAmplify_Percentage( params )
	return 100
end

--------------------------------------------------------------------------------

function modifier_bw_5_6_buff:GetModifierHPRegenAmplify_Percentage( params )
	return 25
end

--------------------------------------------------------------------------------

function modifier_bw_5_6_buff:GetModifierLifestealRegenAmplify_Percentage( params )
	return 25
end

--------------------------------------------------------------------------------

function modifier_bw_5_6_buff:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return 25
end