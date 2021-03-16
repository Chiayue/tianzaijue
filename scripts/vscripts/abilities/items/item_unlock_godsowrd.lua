LinkLuaModifier("modifier_item_unlock_godsowrd", "abilities/items/item_unlock_godsowrd.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_unlock_godsowrd_buff", "abilities/items/item_unlock_godsowrd.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--恐鳌之戒
if item_unlock_godsowrd == nil then
	item_unlock_godsowrd = class({}, nil, base_ability_attribute)
end
function item_unlock_godsowrd:GetIntrinsicModifierName()
	return "modifier_item_unlock_godsowrd"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unlock_godsowrd == nil then
	modifier_item_unlock_godsowrd = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_unlock_godsowrd:IsHidden()
	return false
end
function modifier_item_unlock_godsowrd:OnCreated(params)
	self.unlock_count = self:GetAbilitySpecialValueFor("unlock_count")
	if IsServer() then
	end
end
function modifier_item_unlock_godsowrd:OnRefresh(params)
	self.unlock_count = self:GetAbilitySpecialValueFor("unlock_count")
	if IsServer() then
	end
end
function modifier_item_unlock_godsowrd:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_godsowrd:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
	}
end

function modifier_item_unlock_godsowrd:OnDeath(params)
	if params.attacker == self:GetParent() then
		self:IncrementStackCount()
		if self:GetStackCount() == self.unlock_count then
			local itemID = self:GetAbility():entindex()
			local tItemData = Items:GetItemDataByItemEntIndex(itemID, self:GetParent():GetPlayerOwnerID())
			Items:RemoveItem(self:GetParent():GetPlayerOwnerID(), tItemData.iItemID)
			Items:AddItem(self:GetParent():GetPlayerOwnerID(), "item_unlock_godsowrd_1")
		end
	end
end
function modifier_item_unlock_godsowrd:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_unlock_godsowrd:OnTooltip()
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
---------------------------------------------------------------------
--Modifiers
if modifier_item_unlock_godsowrd_buff == nil then
	modifier_item_unlock_godsowrd_buff = class({}, nil, eom_modifier)
end
function modifier_item_unlock_godsowrd_buff:OnCreated(params)
	self.physical_damage_up = self:GetAbilitySpecialValueFor("physical_damage_up")
	if IsServer() then
	end
end
function modifier_item_unlock_godsowrd_buff:OnRefresh(params)
	self.physical_damage_up = self:GetAbilitySpecialValueFor("physical_damage_up")
	if IsServer() then
	end
end
function modifier_item_unlock_godsowrd_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_godsowrd_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_OUTGOING_PERCENTAGE
	}
end

function modifier_item_unlock_godsowrd_buff:GetPhysicalOutgoingPercentage()
	-- return 10000
	return 100 + self.physical_damage_up
end



AbilityClassHook('item_unlock_godsowrd', getfenv(1), 'abilities/items/item_unlock_godsowrd.lua', { KeyValues.ItemsKv })