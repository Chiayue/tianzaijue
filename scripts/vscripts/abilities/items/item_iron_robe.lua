LinkLuaModifier("modifier_item_iron_robe", "abilities/items/item_iron_robe.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--制式长矛
if item_iron_robe == nil then
	item_iron_robe = class({}, nil, base_ability_attribute)
end
function item_iron_robe:GetIntrinsicModifierName()
	return "modifier_item_iron_robe"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_iron_robe == nil then
	modifier_item_iron_robe = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_iron_robe:OnCreated(params)
	self.magical_ingoing_damage = self:GetAbilitySpecialValueFor("magical_ingoing_damage")
	if IsServer() then
	end
end
function modifier_item_iron_robe:OnRefresh(params)
	self.magical_ingoing_damage = self:GetAbilitySpecialValueFor("magical_ingoing_damage")
	if IsServer() then
	end
end
function modifier_item_iron_robe:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_iron_robe:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_INCOMING_PERCENTAGE] = -self.magical_ingoing_damage
	}
end

AbilityClassHook('item_iron_robe', getfenv(1), 'abilities/items/item_iron_robe.lua', { KeyValues.ItemsKv })