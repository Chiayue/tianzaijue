LinkLuaModifier("modifier_item_tiny_magicbox", "abilities/items/item_tiny_magicbox.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_tiny_magicbox == nil then
	item_tiny_magicbox = class({})
end
function item_tiny_magicbox:GetIntrinsicModifierName()
	return "modifier_item_tiny_magicbox"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_tiny_magicbox == nil then
	modifier_item_tiny_magicbox = class({}, nil, eom_modifier)
end
function modifier_item_tiny_magicbox:OnCreated(params)
	self.mana_boost = self:GetAbilitySpecialValueFor("mana_boost")
	if IsServer() then
	end
end
function modifier_item_tiny_magicbox:OnRefresh(params)
	self.mana_boost = self:GetAbilitySpecialValueFor("mana_boost")
	if IsServer() then
	end
end
function modifier_item_tiny_magicbox:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_tiny_magicbox:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE
	}
end
function modifier_item_tiny_magicbox:OnInBattle()
	self:GetParent():GiveMana(self.mana_boost)
end
function modifier_item_tiny_magicbox:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_tiny_magicbox:OnTooltip()
	return self.mana_boost
end