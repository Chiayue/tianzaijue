LinkLuaModifier("modifier_item_speed_hand", "abilities/items/item_speed_hand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_speed_hand == nil then
	item_speed_hand = class({}, nil, base_ability_attribute)
end
function item_speed_hand:GetIntrinsicModifierName()
	return "modifier_item_speed_hand"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_speed_hand == nil then
	modifier_item_speed_hand = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_speed_hand:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_speed_hand:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_speed_hand:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_speed_hand:DeclareFunctions()
	return {
	}
end
AbilityClassHook('item_speed_hand', getfenv(1), 'abilities/items/item_speed_hand.lua', { KeyValues.ItemsKv })