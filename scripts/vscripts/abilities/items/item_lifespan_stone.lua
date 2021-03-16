LinkLuaModifier("modifier_item_lifespan_stone", "abilities/items/item_lifespan_stone.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_lifespan_stone == nil then
	item_lifespan_stone = class({}, nil, base_ability_attribute)
end
function item_lifespan_stone:GetIntrinsicModifierName()
	return "modifier_item_lifespan_stone"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_lifespan_stone == nil then
	modifier_item_lifespan_stone = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_lifespan_stone:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_lifespan_stone:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_lifespan_stone:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_lifespan_stone:DeclareFunctions()
	return {
	}
end
AbilityClassHook('item_lifespan_stone', getfenv(1), 'abilities/items/item_lifespan_stone.lua', { KeyValues.ItemsKv })