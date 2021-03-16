LinkLuaModifier("modifier_item_ground_sick_sword1", "abilities/items/item_ground_sick_sword1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ground_sick_sword1_buff", "abilities/items/item_ground_sick_sword1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_ground_sick_sword1 == nil then
	item_ground_sick_sword1 = class({})
end
function item_ground_sick_sword1:GetIntrinsicModifierName()
	return "modifier_item_ground_sick_sword1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ground_sick_sword1 == nil then
	modifier_item_ground_sick_sword1 = class({}, nil, eom_modifier)
end
function modifier_item_ground_sick_sword1:OnCreated(params)
	if IsServer() then
	else
	end
end
function modifier_item_ground_sick_sword1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_ground_sick_sword1:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_ground_sick_sword1:EDeclareFunctions()
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
function modifier_item_ground_sick_sword1:OnInBattle()

	local itemID = self:GetAbility():entindex()
	local hParent = self:GetParent()
	hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_ground_sick_sword1_buff", {})

	local tItemData = Items:GetItemDataByItemEntIndex(itemID, hParent:GetPlayerOwnerID())
	Items:RemoveItem(hParent:GetPlayerOwnerID(), tItemData.iItemID)
end
function modifier_item_ground_sick_sword1:OnBattleEnd()
	self:Destroy()
end


---------------------------------------------------------------------
--Modifiers
if modifier_item_ground_sick_sword1_buff == nil then
	modifier_item_ground_sick_sword1_buff = class({}, nil, eom_modifier)
end
function modifier_item_ground_sick_sword1_buff:OnCreated(params)
	self.attacktemp = self:GetAbilitySpecialValueFor("attacktemp")
	if IsServer() then
	else
	end
end
function modifier_item_ground_sick_sword1_buff:IsHidden()
	return true
end
function modifier_item_ground_sick_sword1_buff:OnRefresh(params)
	self.attacktemp = self:GetAbilitySpecialValueFor("attacktemp")
	if IsServer() then
	end
end
function modifier_item_ground_sick_sword1_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_ground_sick_sword1_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_INCOMING_PERCENTAGE,
		[EMDF_PHYSICAL_ATTACK_BONUS] = self.attacktemp,
	}
end
-- function modifier_item_ground_sick_sword1_buff:GetPhysicalAttackBonus()
-- 	return self.attacktemp
-- end
function modifier_item_ground_sick_sword1_buff:OnBattleEnd()
	self:Destroy()
end