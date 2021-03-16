LinkLuaModifier("modifier_item_unlock_ring", "abilities/items/item_unlock_ring.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_unlock_ring_buff", "abilities/items/item_unlock_ring.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--恐鳌之戒
if item_unlock_ring == nil then
	item_unlock_ring = class({}, nil, base_ability_attribute)
end
function item_unlock_ring:GetIntrinsicModifierName()
	return "modifier_item_unlock_ring"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unlock_ring == nil then
	modifier_item_unlock_ring = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_unlock_ring:IsHidden()
	return false
end
function modifier_item_unlock_ring:OnCreated(params)
	self.unlock_count = self:GetAbilitySpecialValueFor("unlock_count")
	if IsServer() then
	end
end
function modifier_item_unlock_ring:OnRefresh(params)
	self.unlock_count = self:GetAbilitySpecialValueFor("unlock_count")
	if IsServer() then
	end
end
function modifier_item_unlock_ring:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_ring:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
	}
end


function modifier_item_unlock_ring:OnDeath(params)
	if params.attacker == self:GetParent() then
		self:IncrementStackCount()
		if self:GetStackCount() == self.unlock_count then
			local itemID = self:GetAbility():entindex()
			local tItemData = Items:GetItemDataByItemEntIndex(itemID, self:GetParent():GetPlayerOwnerID())
			Items:RemoveItem(self:GetParent():GetPlayerOwnerID(), tItemData.iItemID)
			Items:AddItem(self:GetParent():GetPlayerOwnerID(), "item_unlock_ring_1")
		end
	end
end

function modifier_item_unlock_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_unlock_ring:OnTooltip()
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


AbilityClassHook('item_unlock_ring', getfenv(1), 'abilities/items/item_unlock_ring.lua', { KeyValues.ItemsKv })