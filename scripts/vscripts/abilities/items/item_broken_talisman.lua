LinkLuaModifier("modifier_item_broken_talisman", "abilities/items/item_broken_talisman.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--破碎的护符
if item_broken_talisman == nil then
	item_broken_talisman = class({})
end
function item_broken_talisman:GetIntrinsicModifierName()
	return "modifier_item_broken_talisman"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_broken_talisman == nil then
	modifier_item_broken_talisman = class({})
end
function modifier_item_broken_talisman:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.black_damage = self:GetAbilitySpecialValueFor("black_damage")
	if IsServer() then
	end
end
function modifier_item_broken_talisman:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.black_damage = self:GetAbilitySpecialValueFor("black_damage")
	if IsServer() then
	end
end
function modifier_item_broken_talisman:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_broken_talisman:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end
function modifier_item_broken_talisman:GetModifierTotal_ConstantBlock(params)
	if RollPercentage(self.chance) then
		return self.black_damage
	end
end