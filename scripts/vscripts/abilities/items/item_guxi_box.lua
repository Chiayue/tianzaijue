LinkLuaModifier("modifier_item_guxi_box", "abilities/items/item_guxi_box.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--古西利魔盒
if item_guxi_box == nil then
	item_guxi_box = class({})
end
function item_guxi_box:GetIntrinsicModifierName()
	return "modifier_item_guxi_box"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_guxi_box == nil then
	modifier_item_guxi_box = class({}, nil, eom_modifier)
end
function modifier_item_guxi_box:OnCreated(params)
	self.armor_increase = self:GetAbilitySpecialValueFor("armor_increase")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_item_guxi_box:OnRefresh(params)
	self.armor_increase = self:GetAbilitySpecialValueFor("armor_increase")
	if IsServer() then
	end
end
function modifier_item_guxi_box:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_guxi_box:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_item_guxi_box:OnInBattle()
	self:IncrementStackCount()
	self:GetAbility():Save("iStackCount", self:GetStackCount())
end
function modifier_item_guxi_box:GetPhysicalArmorBonus()
	return self:GetStackCount() * self.armor_increase
end


function modifier_item_guxi_box:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_guxi_box:OnTooltip()
	return self:GetStackCount() * self.armor_increase
end