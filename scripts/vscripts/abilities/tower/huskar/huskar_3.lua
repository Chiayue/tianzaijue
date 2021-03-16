LinkLuaModifier("modifier_huskar_3", "abilities/tower/huskar/huskar_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huskar_3_buff", "abilities/tower/huskar/huskar_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if huskar_3 == nil then
	huskar_3 = class({})
end
function huskar_3:GetIntrinsicModifierName()
	return "modifier_huskar_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_huskar_3 == nil then
	modifier_huskar_3 = class({}, nil, eom_modifier)
end
function modifier_huskar_3:IsHidden()
	return false
end
function modifier_huskar_3:IsDebuff()
	return false
end
function modifier_huskar_3:IsPurgable()
	return false
end
function modifier_huskar_3:IsPurgeException()
	return false
end
function modifier_huskar_3:IsStunDebuff()
	return false
end
function modifier_huskar_3:OnCreated(params)
	self.hp_threshold_max = self:GetAbilitySpecialValueFor("hp_threshold_max")
	self.maximum_attack_speed = self:GetAbilitySpecialValueFor("maximum_attack_speed")
	self.maximum_attack_percent = self:GetAbilitySpecialValueFor("maximum_attack_percent")
	if IsClient() then
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_berserker_blood_hero_effect.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(self.iParticleID, false, false, 100, true, false)

		self:StartIntervalThink(0)
	end
end
function modifier_huskar_3:OnRefresh(params)
	self.hp_threshold_max = self:GetAbilitySpecialValueFor("hp_threshold_max")
	self.maximum_attack_speed = self:GetAbilitySpecialValueFor("maximum_attack_speed")
	self.maximum_attack_percent = self:GetAbilitySpecialValueFor("maximum_attack_percent")
end
function modifier_huskar_3:OnIntervalThink()
	if IsClient() then
		local fPercent = RemapValClamped(self:GetParent():GetHealthPercent(), 100, self.hp_threshold_max, 0, 14)
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(fPercent, fPercent, fPercent))
		self:StartIntervalThink(0)
	end
end
function modifier_huskar_3:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_HEALTH_REGEN_BONUS,
		EMDF_ATTACKT_SPEED_BONUS
	}
end
function modifier_huskar_3:GetPhysicalAttackBonusPercentage()
	return RemapValClamped(self:GetParent():GetHealthPercent(), 100, self.hp_threshold_max, 0, self.maximum_attack_percent)
end
function modifier_huskar_3:GetAttackSpeedBonus()
	return RemapValClamped(self:GetParent():GetHealthPercent(), 100, self.hp_threshold_max, 0, self.maximum_attack_speed)
end
function modifier_huskar_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_huskar_3:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:GetPhysicalAttackBonusPercentage()
	elseif self._tooltip == 2 then
		return self:GetAttackSpeedBonus()
	end
end