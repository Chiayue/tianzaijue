LinkLuaModifier( "modifier_item_sunshine_sword_2", "abilities/items/item_sunshine_sword_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_sunshine_sword_2 == nil then
	item_sunshine_sword_2 = class({})
end
function item_sunshine_sword_2:GetIntrinsicModifierName()
	return "modifier_item_sunshine_sword_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_sunshine_sword_2 == nil then
	modifier_item_sunshine_sword_2 = class({})
end
function modifier_item_sunshine_sword_2:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_sunshine_sword_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_sunshine_sword_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_sunshine_sword_2:DeclareFunctions()
	return {
	}
end