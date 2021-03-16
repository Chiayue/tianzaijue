LinkLuaModifier("modifier_item_unlock_wand", "abilities/items/item_unlock_wand.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_unlock_wand_buff", "abilities/items/item_unlock_wand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_unlock_wand == nil then
	item_unlock_wand = class({}, nil, base_ability_attribute)
end
function item_unlock_wand:GetIntrinsicModifierName()
	return "modifier_item_unlock_wand"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unlock_wand == nil then
	modifier_item_unlock_wand = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_unlock_wand:OnCreated(params)
	self.unlock_count = self:GetAbilitySpecialValueFor("unlock_count")
	if IsServer() then
	end
end
function modifier_item_unlock_wand:IsHidden()
	return false
end
-- function modifier_item_unlock_wand:GetTexture()
-- 	return "item_" .. self:GetAbilityTextureName()
-- end
function modifier_item_unlock_wand:OnRefresh(params)
	self.unlock_count = self:GetAbilitySpecialValueFor("unlock_count")
	if IsServer() then
	end
end
function modifier_item_unlock_wand:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_wand:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
	}
end
function modifier_item_unlock_wand:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_unlock_wand:OnTooltip()
	local hParent = self:GetParent()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 2
	if 0 == self._iTooltip then
		if self:GetStackCount() <= self.unlock_count then
			return self:GetStackCount()
		else
			return self.unlock_count
		end
	elseif 1 == self._iTooltip then
		return self.unlock_count
	end
end

function modifier_item_unlock_wand:OnDeath(params)
	local hParent = self:GetParent()
	if params.attacker == self:GetParent() then
		self:IncrementStackCount()
		if self:GetStackCount() == self.unlock_count then
			-- 物品解封
			local itemID = self:GetAbility():entindex()
			local tItemData = Items:GetItemDataByItemEntIndex(itemID, hParent:GetPlayerOwnerID())
			Items:RemoveItem(hParent:GetPlayerOwnerID(), tItemData.iItemID)
			Items:AddItem(hParent:GetPlayerOwnerID(), "item_unlock_wand_1")
		end
	end
end




AbilityClassHook('item_unlock_wand', getfenv(1), 'abilities/items/item_unlock_wand.lua', { KeyValues.ItemsKv })