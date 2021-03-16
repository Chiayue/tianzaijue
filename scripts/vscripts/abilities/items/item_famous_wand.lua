LinkLuaModifier("modifier_item_famous_wand", "abilities/items/item_famous_wand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_famous_wand == nil then
	item_famous_wand = class({})
end
function item_famous_wand:GetIntrinsicModifierName()
	return "modifier_item_famous_wand"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_famous_wand == nil then
	modifier_item_famous_wand = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_famous_wand:OnCreated(params)
	self.magical_helf = self:GetAbilitySpecialValueFor("magical_helf")
	self.magical_outgoing = self:GetAbilitySpecialValueFor("magical_outgoing")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_famous_wand:OnRefresh(params)
	self.magical_helf = self:GetAbilitySpecialValueFor("magical_helf")
	self.magical_outgoing = self:GetAbilitySpecialValueFor("magical_outgoing")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_famous_wand:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_famous_wand:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_OUTGOING_PERCENTAGE] = self.magical_outgoing,
		[EMDF_MAGICAL_HELF_BONUS_PERCENTAGE] = self:GetAbility():GetLevel() >= self.unlock_level and self.magical_outgoing or nil,
	}
end
-- function modifier_item_famous_wand:GetMagicalOutgoingPercentage()
-- 	return self.magical_outgoing
-- end
-- function modifier_item_famous_wand:GetMagicalHealBonusPercentage()
-- 	if self:GetAbility():GetLevel() >= self.unlock_level then
-- 		return self.magical_outgoing
-- 	end
-- end