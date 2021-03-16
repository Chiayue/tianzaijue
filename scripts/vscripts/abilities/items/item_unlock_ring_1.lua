LinkLuaModifier("modifier_item_unlock_ring_1", "abilities/items/item_unlock_ring_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_unlock_ring_1 == nil then
	item_unlock_ring_1 = class({}, nil, base_ability_attribute)
end
function item_unlock_ring_1:GetIntrinsicModifierName()
	return "modifier_item_unlock_ring_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unlock_ring_1 == nil then
	modifier_item_unlock_ring_1 = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_unlock_ring_1:OnCreated(params)
	self.incoming_reduce = self:GetAbilitySpecialValueFor("incoming_reduce")
	if IsServer() then
	end
end
function modifier_item_unlock_ring_1:OnRefresh(params)
	self.incoming_reduce = self:GetAbilitySpecialValueFor("incoming_reduce")
	if IsServer() then
	end
end
function modifier_item_unlock_ring_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_ring_1:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -self.incoming_reduce
	}
end
AbilityClassHook('item_unlock_ring_1', getfenv(1), 'abilities/items/item_unlock_ring_1.lua', { KeyValues.ItemsKv })