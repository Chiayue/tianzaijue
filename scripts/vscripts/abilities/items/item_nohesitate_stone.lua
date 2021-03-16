LinkLuaModifier("modifier_item_nohesitate_stone", "abilities/items/item_nohesitate_stone.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_nohesitate_stone == nil then
	item_nohesitate_stone = class({}, nil, base_ability_attribute)
end
function item_nohesitate_stone:GetIntrinsicModifierName()
	return "modifier_item_nohesitate_stone"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_nohesitate_stone == nil then
	modifier_item_nohesitate_stone = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_nohesitate_stone:OnCreated(params)
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
end
function modifier_item_nohesitate_stone:OnRefresh(params)
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
end
function modifier_item_nohesitate_stone:GetModifierCooldownReduction_Constant()
	return self.cooldown_reduce
end
function modifier_item_nohesitate_stone:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT
	}
end
AbilityClassHook('item_nohesitate_stone', getfenv(1), 'abilities/items/item_nohesitate_stone.lua', { KeyValues.ItemsKv })