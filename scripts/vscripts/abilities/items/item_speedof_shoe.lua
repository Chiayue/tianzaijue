LinkLuaModifier("modifier_item_speedOf_shoe", "abilities/items/item_speedOf_shoe.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_speedOf_shoe == nil then
	item_speedOf_shoe = class({}, nil, base_ability_attribute)
end
function item_speedOf_shoe:GetIntrinsicModifierName()
	return "modifier_item_speedOf_shoe"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_speedOf_shoe == nil then
	modifier_item_speedOf_shoe = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_speedOf_shoe:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_speedOf_shoe:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_speedOf_shoe:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_speedOf_shoe:DeclareFunctions()
	return {
	}
end
AbilityClassHook('modifier_item_speedOf_shoe', getfenv(1), 'abilities/items/modifier_item_speedOf_shoe.lua', { KeyValues.ItemsKv })