LinkLuaModifier( "modifier_item_unknowned_item_4", "abilities/items/item_unknowned_item_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_unknowned_item_4 == nil then
	item_unknowned_item_4 = class({})
end
function item_unknowned_item_4:GetIntrinsicModifierName()
	return "modifier_item_unknowned_item_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unknowned_item_4 == nil then
	modifier_item_unknowned_item_4 = class({})
end
function modifier_item_unknowned_item_4:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_unknowned_item_4:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_unknowned_item_4:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unknowned_item_4:DeclareFunctions()
	return {
	}
end