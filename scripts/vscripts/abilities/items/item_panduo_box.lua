LinkLuaModifier("modifier_item_panduo_box", "abilities/items/item_panduo_box.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--潘多拉魔盒
if item_panduo_box == nil then
	item_panduo_box = class({})
end
function item_panduo_box:GetIntrinsicModifierName()
	return "modifier_item_panduo_box"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_panduo_box == nil then
	modifier_item_panduo_box = class({}, nil, eom_modifier)
end
function modifier_item_panduo_box:OnCreated(params)
	self.attack_increase = self:GetAbilitySpecialValueFor("attack_increase")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_item_panduo_box:OnRefresh(params)
	self.attack_increase = self:GetAbilitySpecialValueFor("attack_increase")
	if IsServer() then
	end
end
function modifier_item_panduo_box:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_panduo_box:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_PHYSICAL_ATTACK_BONUS_UNIQUE
	}
end
function modifier_item_panduo_box:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_panduo_box:OnInBattle()
	self:IncrementStackCount()
	self:GetAbility():Save("iStackCount", self:GetStackCount())
end
function modifier_item_panduo_box:GetPhysicalAttackBonusUnique()
	return self:GetStackCount() * self.attack_increase
end
function modifier_item_panduo_box:OnTooltip()
	return self:GetStackCount() * self.attack_increase
end