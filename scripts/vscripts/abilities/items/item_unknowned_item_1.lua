LinkLuaModifier("modifier_item_unknowned_item_1", "abilities/items/item_unknowned_item_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_unknowned_item_1 == nil then
	item_unknowned_item_1 = class({})
end
function item_unknowned_item_1:GetIntrinsicModifierName()
	return "modifier_item_unknowned_item_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unknowned_item_1 == nil then
	modifier_item_unknowned_item_1 = class({}, nil, eom_modifier)
end
function modifier_item_unknowned_item_1:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_unknowned_item_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_unknowned_item_1:OnDestroy()
	if IsServer() then
	end
end