LinkLuaModifier("modifier_item_broken_bean", "abilities/items/item_broken_bean.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_broken_bean_buff", "abilities/items/item_broken_bean.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_broken_bean == nil then
	item_broken_bean = class({})
end
function item_broken_bean:GetIntrinsicModifierName()
	return "modifier_item_broken_bean"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_broken_bean == nil then
	modifier_item_broken_bean = class({}, nil, eom_modifier)
end
function modifier_item_broken_bean:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_IN_BATTLE,
	}
end
function modifier_item_broken_bean:OnInBattle()

	local itemID = self:GetAbility():entindex()
	local hParent = self:GetParent()
	hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_broken_bean_buff", {})

	local tItemData = Items:GetItemDataByItemEntIndex(itemID, hParent:GetPlayerOwnerID())
	Items:RemoveItem(hParent:GetPlayerOwnerID(), tItemData.iItemID)
end
function modifier_item_broken_bean:OnBattleEnd()
	self:Destroy()
end


---------------------------------------------------------------------
--Modifiers
if modifier_item_broken_bean_buff == nil then
	modifier_item_broken_bean_buff = class({}, nil, eom_modifier)
end
function modifier_item_broken_bean_buff:IsHidden()
	return true
end
function modifier_item_broken_bean_buff:OnCreated(params)
	self.bonus_pct = self:GetAbilitySpecialValueFor("bonus_pct")
end
function modifier_item_broken_bean_buff:OnRefresh(params)
	self.bonus_pct = self:GetAbilitySpecialValueFor("bonus_pct")
end
function modifier_item_broken_bean_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.bonus_pct,
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.bonus_pct,
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.bonus_pct,
		[EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE] = self.bonus_pct,
		[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAG] = self.bonus_pct
	}
end
function modifier_item_broken_bean_buff:OnBattleEnd()
	self:Destroy()
end