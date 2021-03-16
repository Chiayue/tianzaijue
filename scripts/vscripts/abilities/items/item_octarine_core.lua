---玲珑心
if nil == item_octarine_core then
	item_octarine_core = class({}, nil, base_ability_attribute)
end
function item_octarine_core:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_octarine_core then
	modifier_item_octarine_core = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_octarine_core:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_octarine_core:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_octarine_core:UpdateValues()
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.cooldown_reduction = self:GetAbilitySpecialValueFor('cooldown_reduction')
end
function modifier_item_octarine_core:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end
function modifier_item_octarine_core:GetModifierPercentageCooldown()
	return self.cooldown_reduction
end
AbilityClassHook('item_octarine_core', getfenv(1), 'abilities/items/item_octarine_core.lua', { KeyValues.ItemsKv })