LinkLuaModifier("modifier_item_voodo_mask", "abilities/items/item_voodo_mask.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_voodo_mask == nil then
	item_voodo_mask = class({})
end
function item_voodo_mask:GetIntrinsicModifierName()
	return "modifier_item_voodo_mask"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_voodo_mask == nil then
	modifier_item_voodo_mask = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_voodo_mask:OnCreated(params)
	self.magical_helf = self:GetAbilitySpecialValueFor("magical_helf")
	if IsServer() then
	end
end
function modifier_item_voodo_mask:OnRefresh(params)
	self.magical_helf = self:GetAbilitySpecialValueFor("magical_helf")
	if IsServer() then
	end
end
function modifier_item_voodo_mask:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_voodo_mask:GetMagicalHealBonusPercentage()
	return	self.magical_helf
end
function modifier_item_voodo_mask:EDeclareFunctions()
	return {
		EMDF_MAGICAL_HELF_BONUS_PERCENTAGE
	}
end