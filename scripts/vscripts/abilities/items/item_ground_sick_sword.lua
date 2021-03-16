LinkLuaModifier("modifier_item_ground_sick_sword", "abilities/items/item_ground_sick_sword.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ground_sick_sword_buff", "abilities/items/item_ground_sick_sword.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_ground_sick_sword == nil then
	item_ground_sick_sword = class({})
end
function item_ground_sick_sword:GetIntrinsicModifierName()
	return "modifier_item_ground_sick_sword"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ground_sick_sword == nil then
	modifier_item_ground_sick_sword = class({}, nil, eom_modifier)
end
function modifier_item_ground_sick_sword:OnCreated(params)
	if IsServer() then
	else
	end
end
function modifier_item_ground_sick_sword:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_ground_sick_sword:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_ground_sick_sword:EDeclareFunctions()
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
function modifier_item_ground_sick_sword:OnInBattle()

	local itemID = self:GetAbility():entindex()
	local hParent = self:GetParent()
	hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_ground_sick_sword_buff", {})

	local tItemData = Items:GetItemDataByItemEntIndex(itemID, hParent:GetPlayerOwnerID())
	Items:RemoveItem(hParent:GetPlayerOwnerID(), tItemData.iItemID)
end
function modifier_item_ground_sick_sword:OnBattleEnd()
	self:Destroy()
end


---------------------------------------------------------------------
--Modifiers
if modifier_item_ground_sick_sword_buff == nil then
	modifier_item_ground_sick_sword_buff = class({}, nil, eom_modifier)
end
function modifier_item_ground_sick_sword_buff:OnCreated(params)
	self.attacktemp = self:GetAbilitySpecialValueFor("attacktemp")
	if IsServer() then
	else
	end
end
function modifier_item_ground_sick_sword_buff:IsHidden()
	return true
end
function modifier_item_ground_sick_sword_buff:OnRefresh(params)
	self.attacktemp = self:GetAbilitySpecialValueFor("attacktemp")
	if IsServer() then
	end
end
function modifier_item_ground_sick_sword_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_ground_sick_sword_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_INCOMING_PERCENTAGE,
		[EMDF_MAGICAL_ATTACK_BONUS] = self.attacktemp,
	}
end
-- function modifier_item_ground_sick_sword_buff:GetMagicalAttackBonusUnique()
-- 	return self.attacktemp
-- end
function modifier_item_ground_sick_sword_buff:OnBattleEnd()
	self:Destroy()
end