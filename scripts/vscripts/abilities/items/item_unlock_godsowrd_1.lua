LinkLuaModifier("modifier_item_unlock_godsowrd_1", "abilities/items/item_unlock_godsowrd_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_unlock_godsowrd_1 == nil then
	item_unlock_godsowrd_1 = class({}, nil, base_ability_attribute)
end
function item_unlock_godsowrd_1:GetIntrinsicModifierName()
	return "modifier_item_unlock_godsowrd_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unlock_godsowrd_1 == nil then
	modifier_item_unlock_godsowrd_1 = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_unlock_godsowrd_1:OnCreated(params)
	self.physical_damage_up = self:GetAbilitySpecialValueFor("physical_damage_up")
	if IsServer() then
	end
end
function modifier_item_unlock_godsowrd_1:OnRefresh(params)
	self.physical_damage_up = self:GetAbilitySpecialValueFor("physical_damage_up")
	if IsServer() then
	end
end
function modifier_item_unlock_godsowrd_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_godsowrd_1:IsHidden()
	return true
end
function modifier_item_unlock_godsowrd_1:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_OUTGOING_PERCENTAGE] = self.physical_damage_up,
	}
end
AbilityClassHook('item_unlock_godsowrd_1', getfenv(1), 'abilities/items/item_unlock_godsowrd_1.lua', { KeyValues.ItemsKv })