LinkLuaModifier("modifier_item_iron_shield", "abilities/items/item_iron_shield.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--精钢盾牌
if item_iron_shield == nil then
	item_iron_shield = class({}, nil, base_ability_attribute)
end
function item_iron_shield:GetIntrinsicModifierName()
	return "modifier_item_iron_shield"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_iron_shield == nil then
	modifier_item_iron_shield = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_iron_shield:OnCreated(params)
	self.deduce_damage_pct = self:GetAbilitySpecialValueFor("deduce_damage_pct")
	if IsServer() then
	end
end
function modifier_item_iron_shield:OnRefresh(params)
	self.deduce_damage_pct = self:GetAbilitySpecialValueFor("deduce_damage_pct")
	if IsServer() then
	end
end
function modifier_item_iron_shield:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_iron_shield:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -self.deduce_damage_pct,
	}
end


AbilityClassHook('item_iron_shield', getfenv(1), 'abilities/items/item_iron_shield.lua', { KeyValues.ItemsKv })