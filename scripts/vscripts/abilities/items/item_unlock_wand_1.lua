LinkLuaModifier("modifier_item_unlock_wand_1", "abilities/items/item_unlock_wand_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_unlock_wand_1 == nil then
	item_unlock_wand_1 = class({}, nil, base_ability_attribute)
end
function item_unlock_wand_1:GetIntrinsicModifierName()
	return "modifier_item_unlock_wand_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unlock_wand_1 == nil then
	modifier_item_unlock_wand_1 = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_unlock_wand_1:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_unlock_wand_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_unlock_wand_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_wand_1:DeclareFunctions()
	return {
	}
end
AbilityClassHook('item_unlock_wand_1', getfenv(1), 'abilities/items/item_unlock_wand_1.lua', { KeyValues.ItemsKv })