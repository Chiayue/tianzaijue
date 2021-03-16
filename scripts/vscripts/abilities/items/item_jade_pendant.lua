LinkLuaModifier("modifier_item_jade_pendant", "abilities/items/item_jade_pendant.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_jade_pendant == nil then
	item_jade_pendant = class({}, nil, base_ability_attribute)
end
function item_jade_pendant:GetIntrinsicModifierName()
	return "modifier_item_jade_pendant"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_jade_pendant == nil then
	modifier_item_jade_pendant = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_jade_pendant:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_item_jade_pendant:OnCreated(params)
	self.base_health_regen = self:GetAbilitySpecialValueFor("base_health_regen")
	self.health_regen_everystack = self:GetAbilitySpecialValueFor("health_regen_everystack")
	self.health_everystack = self:GetAbilitySpecialValueFor("health_everystack")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	self.health_restriction = self:GetAbilitySpecialValueFor("health_restriction")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_item_jade_pendant:OnRefresh(params)
	self.base_health_regen = self:GetAbilitySpecialValueFor("base_health_regen")
	self.health_regen_everystack = self:GetAbilitySpecialValueFor("health_regen_everystack")
	self.health_everystack = self:GetAbilitySpecialValueFor("health_everystack")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	self.health_restriction = self:GetAbilitySpecialValueFor("health_restriction")
	if IsServer() then
	end
end
function modifier_item_jade_pendant:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_jade_pendant:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_STATUS_HEALTH_BONUS
	}
end
function modifier_item_jade_pendant:GetStatusHealthBonus()
	return self.health_everystack * self:GetStackCount()
end
function modifier_item_jade_pendant:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_item_jade_pendant:OnTooltip()
	return self.health_everystack * self:GetStackCount()
end
function modifier_item_jade_pendant:OnBattleEnd()
	if self:GetAbility():GetLevel() >= self.unlock_level and self:GetParent():GetHealth() / self:GetParent():GetMaxHealth() >= 0.01 * self.health_restriction then
		self:IncrementStackCount()
		self:ForceRefresh()
		self:GetAbility():Save("iStackCount", self:GetStackCount())
	end
end