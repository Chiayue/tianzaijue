LinkLuaModifier("modifier_item_blood_suck", "abilities/items/item_blood_suck.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_blood_suck == nil then
	item_blood_suck = class({}, nil, base_ability_attribute)
end
function item_blood_suck:GetIntrinsicModifierName()
	return "modifier_item_blood_suck"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_blood_suck == nil then
	modifier_item_blood_suck = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_blood_suck:OnCreated(params)
	self.blood_suck = self:GetAbilitySpecialValueFor("blood_suck")
end
function modifier_item_blood_suck:OnRefresh(params)
	self.blood_suck = self:GetAbilitySpecialValueFor("blood_suck")
end
function modifier_item_blood_suck:EDeclareFunctions()
	return {
		[EMDF_ATTACK_HELF_BONUS_PERCENTAGE] = self.blood_suck,
	}
end
AbilityClassHook('item_blood_suck', getfenv(1), 'abilities/items/item_blood_suck.lua', { KeyValues.ItemsKv })