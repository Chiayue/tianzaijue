-----------------------------------------------------------------
modifier_yxtfjn_lianjin = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_yxtfjn_lianjin:IsHidden()
	return false
end

function modifier_yxtfjn_lianjin:GetTexture()
	return "alchemist_chemical_rage"
end
function modifier_yxtfjn_lianjin:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf"
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_yxtfjn_lianjin:DeclareFunctions()
	local funcs = {
	
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS ,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end

function modifier_yxtfjn_lianjin:OnCreated( kv )
    self.bonus_movespeed = self:GetAbility():GetSpecialValueFor("bonus_movespeed") 
    self.smhf = self:GetAbility():GetSpecialValueFor("smhf") 
    self.base_attack_time = self:GetAbility():GetSpecialValueFor("base_attack_time") 
	
end
function modifier_yxtfjn_lianjin:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_movespeed
end
function modifier_yxtfjn_lianjin:GetModifierHealthRegenPercentage( params )
	return self.smhf
end
function modifier_yxtfjn_lianjin:GetModifierBaseAttackTimeConstant( params )
	return self.base_attack_time
end

function modifier_yxtfjn_lianjin:GetActivityTranslationModifiers( params )
	return "chemical_rage"
end
function modifier_yxtfjn_lianjin:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

-----------