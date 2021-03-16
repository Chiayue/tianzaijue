LinkLuaModifier("modifier_item_magic_armor", "abilities/items/item_magic_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_magic_armor_buff", "abilities/items/item_magic_armor.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_magic_armor == nil then
	item_magic_armor = class({})
end
function item_magic_armor:GetIntrinsicModifierName()
	return "modifier_item_magic_armor"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_magic_armor == nil then
	modifier_item_magic_armor = class({}, nil, eom_modifier)
end
function modifier_item_magic_armor:OnCreated(params)
	self.armor_increase = self:GetAbilitySpecialValueFor("armor_increase")
	if IsServer() then
	else
	end
end
function modifier_item_magic_armor:OnRefresh(params)
	self.armor_increase = self:GetAbilitySpecialValueFor("armor_increase")
	if IsServer() then
	end
end
function modifier_item_magic_armor:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_magic_armor:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE
	}
end
function modifier_item_magic_armor:OnInBattle()

	local itemID = self:GetAbility():entindex()
	local hParent = self:GetParent()
	hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_magic_armor_buff", {})

	local tItemData = Items:GetItemDataByItemEntIndex(itemID, hParent:GetPlayerOwnerID())
	Items:RemoveItem(hParent:GetPlayerOwnerID(), tItemData.iItemID)
end
function modifier_item_magic_armor:OnBattleEnd()
	self:Destroy()
end


---------------------------------------------------------------------
--Modifiers
if modifier_item_magic_armor_buff == nil then
	modifier_item_magic_armor_buff = class({}, nil, eom_modifier)
end
function modifier_item_magic_armor_buff:OnCreated(params)
	self.armor_increase = self:GetAbilitySpecialValueFor("armor_increase")
	if IsServer() then
	else
	end
end
function modifier_item_magic_armor_buff:IsHidden()
	return true
end
function modifier_item_magic_armor_buff:OnRefresh(params)
	self.armor_increase = self:GetAbilitySpecialValueFor("armor_increase")
	if IsServer() then
	end
end
function modifier_item_magic_armor_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_magic_armor_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE] = self.armor_increase,
		[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE] = self.armor_increase,
	}
end
function modifier_item_magic_armor_buff:OnBattleEnd()
	self:Destroy()
end