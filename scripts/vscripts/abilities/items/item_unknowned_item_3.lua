LinkLuaModifier( "modifier_item_unknowned_item_3", "abilities/items/item_unknowned_item_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_unknowned_item_3 == nil then
	item_unknowned_item_3 = class({})
end
function item_unknowned_item_3:GetIntrinsicModifierName()
	return "modifier_item_unknowned_item_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unknowned_item_3 == nil then
	modifier_item_unknowned_item_3 = class({})
end
function modifier_item_unknowned_item_3:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_unknowned_item_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_unknowned_item_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unknowned_item_3:DeclareFunctions()
	return {
	}
end