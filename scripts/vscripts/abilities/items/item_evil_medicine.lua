LinkLuaModifier("modifier_item_evil_medicine", "abilities/items/item_evil_medicine.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_evil_medicine_buff", "abilities/items/item_evil_medicine.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_evil_medicine == nil then
	item_evil_medicine = class({})
end
function item_evil_medicine:GetIntrinsicModifierName()
	return "modifier_item_evil_medicine"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_evil_medicine == nil then
	modifier_item_evil_medicine = class({}, nil, eom_modifier)
end
function modifier_item_evil_medicine:OnCreated(params)
	self.incoming_reduce = self:GetAbilitySpecialValueFor("incoming_reduce")
	if IsServer() then
	else
	end
end
function modifier_item_evil_medicine:OnRefresh(params)
	self.incoming_reduce = self:GetAbilitySpecialValueFor("incoming_reduce")
	if IsServer() then
	end
end
function modifier_item_evil_medicine:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_evil_medicine:EDeclareFunctions()
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
function modifier_item_evil_medicine:OnInBattle()

	local itemID = self:GetAbility():entindex()
	local hParent = self:GetParent()
	hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_evil_medicine_buff", {})

	local tItemData = Items:GetItemDataByItemEntIndex(itemID, hParent:GetPlayerOwnerID())
	Items:RemoveItem(hParent:GetPlayerOwnerID(), tItemData.iItemID)
end
function modifier_item_evil_medicine:OnBattleEnd()
	self:Destroy()
end


---------------------------------------------------------------------
--Modifiers
if modifier_item_evil_medicine_buff == nil then
	modifier_item_evil_medicine_buff = class({}, nil, eom_modifier)
end
function modifier_item_evil_medicine_buff:OnCreated(params)
	self.incoming_reduce = self:GetAbilitySpecialValueFor("incoming_reduce")
	if IsServer() then
	else
	end
end
function modifier_item_evil_medicine_buff:IsHidden()
	return true
end
function modifier_item_evil_medicine_buff:OnRefresh(params)
	self.incoming_reduce = self:GetAbilitySpecialValueFor("incoming_reduce")
	if IsServer() then
	end
end
function modifier_item_evil_medicine_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_evil_medicine_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_INCOMING_PERCENTAGE
	}
end

function modifier_item_evil_medicine_buff:GetIncomingPercentage()
	return -self.incoming_reduce
end

function modifier_item_evil_medicine_buff:OnBattleEnd()
	self:Destroy()
end