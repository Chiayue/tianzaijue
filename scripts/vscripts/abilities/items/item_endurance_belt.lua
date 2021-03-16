LinkLuaModifier( "modifier_item_endurance_belt", "abilities/items/item_endurance_belt.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_endurance_belt == nil then
	item_endurance_belt = class({},nil,base_ability_attribute)
end
function item_endurance_belt:GetIntrinsicModifierName()
	return "modifier_item_endurance_belt"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_endurance_belt == nil then
	modifier_item_endurance_belt = class({},nil,modifier_base_ability_attribute)
end
function modifier_item_endurance_belt:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_endurance_belt:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_endurance_belt:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_endurance_belt:DeclareFunctions()
	return {
	}
end
AbilityClassHook('item_endurance_belt', getfenv(1), 'abilities/items/item_endurance_belt.lua', { KeyValues.ItemsKv })