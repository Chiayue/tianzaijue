LinkLuaModifier( "modifier_item_perfect_ring", "abilities/items/item_perfect_ring.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_perfect_ring == nil then
	item_perfect_ring = class({},nil,base_ability_attribute)
end
function item_perfect_ring:GetIntrinsicModifierName()
	return "modifier_item_perfect_ring"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_perfect_ring == nil then
	modifier_item_perfect_ring = class({},nil,modifier_base_ability_attribute)
end
function modifier_item_perfect_ring:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_perfect_ring:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_perfect_ring:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_perfect_ring:DeclareFunctions()
	return {
	}
end