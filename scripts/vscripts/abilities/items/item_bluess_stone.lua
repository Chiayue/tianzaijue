--Abilities
--恐鳌之戒
if item_bluess_stone == nil then
	item_bluess_stone = class({}, nil, base_ability_attribute)
end
AbilityClassHook('item_bluess_stone', getfenv(1), 'abilities/items/item_bluess_stone.lua', { KeyValues.ItemsKv })