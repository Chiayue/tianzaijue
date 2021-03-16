LinkLuaModifier("modifier_item_mana_ring", "abilities/items/item_mana_ring.lua", LUA_MODIFIER_MOTION_NONE)

--力量手环
if item_mana_ring == nil then
	item_mana_ring = class({}, nil, base_ability_attribute)
end

--Modifiers
if nil == modifier_item_mana_ring then
	modifier_item_mana_ring = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_mana_ring:IsHidden()
	return true
end

AbilityClassHook('item_mana_ring', getfenv(1), 'abilities/items/item_mana_ring.lua', { KeyValues.ItemsKv })