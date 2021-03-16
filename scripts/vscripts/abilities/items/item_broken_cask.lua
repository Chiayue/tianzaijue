LinkLuaModifier("modifier_item_broken_cask", "abilities/items/item_broken_cask.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_broken_cask == nil then
	item_broken_cask = class({})
end
function item_broken_cask:GetIntrinsicModifierName()
	return "modifier_item_broken_cask"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_broken_cask == nil then
	modifier_item_broken_cask = class({})
end
function modifier_item_broken_cask:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.black_damage = self:GetAbilitySpecialValueFor("black_damage")
	if IsServer() then
	end
end
function modifier_item_broken_cask:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.black_damage = self:GetAbilitySpecialValueFor("black_damage")
	if IsServer() then
	end
end
function modifier_item_broken_cask:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_broken_cask:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end
function modifier_item_broken_cask:GetModifierTotal_ConstantBlock(params)
	if DAMAGE_TYPE_PHYSICAL == params.damage_type and RollPercentage(self.chance) then
		return	self.black_damage
	end
end