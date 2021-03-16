LinkLuaModifier("modifier_item_luxifu_box", "abilities/items/item_luxifu_box.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--咯系系魔盒
if item_luxifu_box == nil then
	item_luxifu_box = class({})
end
function item_luxifu_box:GetIntrinsicModifierName()
	return "modifier_item_luxifu_box"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_luxifu_box == nil then
	modifier_item_luxifu_box = class({}, nil, eom_modifier)
end
function modifier_item_luxifu_box:OnCreated(params)
	self.attack_increase = self:GetAbilitySpecialValueFor("attack_increase")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_item_luxifu_box:OnRefresh(params)
	self.attack_increase = self:GetAbilitySpecialValueFor("attack_increase")
	if IsServer() then
	end
end
function modifier_item_luxifu_box:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_luxifu_box:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_MAGICAL_ATTACK_BONUS
	}
end
function modifier_item_luxifu_box:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_luxifu_box:OnTooltip()
	return self:GetStackCount() * self.attack_increase
end
function modifier_item_luxifu_box:OnInBattle()
	self:IncrementStackCount()
	self:GetAbility():Save("iStackCount", self:GetStackCount())
end
function modifier_item_luxifu_box:GetMagicalAttackBonus()
	return self:GetStackCount() * self.attack_increase
end