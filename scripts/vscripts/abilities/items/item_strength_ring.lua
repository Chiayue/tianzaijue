LinkLuaModifier("modifier_item_strength_ring", "abilities/items/item_strength_ring.lua", LUA_MODIFIER_MOTION_NONE)

--力量手环
if item_strength_ring == nil then
	item_strength_ring = class({}, nil, base_ability_attribute)
end

--Modifiers
if nil == modifier_item_strength_ring then
	modifier_item_strength_ring = class({}, nil, modifier_base_ability_attribute)
end

AbilityClassHook('item_strength_ring', getfenv(1), 'abilities/items/item_strength_ring.lua', { KeyValues.ItemsKv })