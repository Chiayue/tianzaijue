
modifier_jyg_14_buff = class({})

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function modifier_jyg_14_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_jyg_14_buff:GetEffectName()
	return "particles/items4_fx/spirit_vessel_damage.vpcf"
end

--------------------------------------------------------------------------------
function modifier_jyg_14_buff:OnCreated( kv )
	self.smhf = self:GetAbility():GetSpecialValueFor("smhf")
	self:OnRefresh()
end


--------------------------------------------------------------------------------

function modifier_jyg_14_buff:OnRefresh( kv )
	
end

function modifier_jyg_14_buff:IsDebuff()
	return true
	
end

--------------------------------------------------------------------------------

function modifier_jyg_14_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,   	--降低魔法回复效率
		MODIFIER_PROPERTY_MP_RESTORE_AMPLIFY_PERCENTAGE,	--降低给予魔法的效率
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_jyg_14_buff:GetModifierHealAmplify_PercentageTarget( params )
	return self.smhf
end

--------------------------------------------------------------------------------

function modifier_jyg_14_buff:GetModifierHPRegenAmplify_Percentage( params )
	return self.smhf
end

--------------------------------------------------------------------------------

function modifier_jyg_14_buff:GetModifierLifestealRegenAmplify_Percentage( params )
	return self.smhf
end

--------------------------------------------------------------------------------

function modifier_jyg_14_buff:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return self.smhf
end

function modifier_jyg_14_buff:GetModifierMPRegenAmplify_Percentage()
	return self.smhf
end
function modifier_jyg_14_buff:GetModifierMPRestoreAmplify_Percentage()
	return self.smhf
end