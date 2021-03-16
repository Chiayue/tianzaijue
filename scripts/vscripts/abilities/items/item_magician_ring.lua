LinkLuaModifier( "modifier_item_magician_ring", "abilities/items/item_magician_ring.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_magician_ring == nil then
	item_magician_ring = class({},nil,base_ability_attribute)
end
function item_magician_ring:GetIntrinsicModifierName()
	return "modifier_item_magician_ring"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_magician_ring == nil then
	modifier_item_magician_ring = class({},nil,modifier_base_ability_attribute)
end
function modifier_item_magician_ring:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_magician_ring:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_magician_ring:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_magician_ring:DeclareFunctions()
	return {
	}
end
AbilityClassHook('item_magician_ring', getfenv(1), 'abilities/items/item_magician_ring.lua', { KeyValues.ItemsKv })