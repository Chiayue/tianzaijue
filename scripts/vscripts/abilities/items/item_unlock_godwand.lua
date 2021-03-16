LinkLuaModifier("modifier_item_unlock_godwand", "abilities/items/item_unlock_godwand.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_unlock_godwand_buff", "abilities/items/item_unlock_godwand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--封印的神之杖
if item_unlock_godwand == nil then
	item_unlock_godwand = class({}, nil, base_ability_attribute)
end
function item_unlock_godwand:GetIntrinsicModifierName()
	return "modifier_item_unlock_godwand"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unlock_godwand == nil then
	modifier_item_unlock_godwand = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_unlock_godwand:IsHidden()
	return false
end
function modifier_item_unlock_godwand:GetTexture()
	return "item_trident"
end
function modifier_item_unlock_godwand:OnCreated(params)
	self.unlock_count = self:GetAbilitySpecialValueFor("unlock_count")
	if IsServer() then
	end
end
function modifier_item_unlock_godwand:OnRefresh(params)
	self.unlock_count = self:GetAbilitySpecialValueFor("unlock_count")
	if IsServer() then
	end
end
function modifier_item_unlock_godwand:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_godwand:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
	}
end


function modifier_item_unlock_godwand:OnDeath(params)
	if params.attacker == self:GetParent() then
		self:IncrementStackCount()
		if self:GetStackCount() == self.unlock_count then
			local itemID = self:GetAbility():entindex()
			local tItemData = Items:GetItemDataByItemEntIndex(itemID, self:GetParent():GetPlayerOwnerID())
			Items:RemoveItem(self:GetParent():GetPlayerOwnerID(), tItemData.iItemID)
			Items:AddItem(self:GetParent():GetPlayerOwnerID(), "item_unlock_godwand_1")
		end
	end
end
function modifier_item_unlock_godwand:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_unlock_godwand:OnTooltip()
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
if modifier_item_unlock_godwand_buff == nil then
	modifier_item_unlock_godwand_buff = class({}, nil, eom_modifier)
end
function modifier_item_unlock_godwand_buff:OnCreated(params)
	self.magical_damage_up = self:GetAbilitySpecialValueFor("magical_damage_up")
	if IsServer() then
	end
end
function modifier_item_unlock_godwand_buff:OnRefresh(params)
	self.magical_damage_up = self:GetAbilitySpecialValueFor("magical_damage_up")
	if IsServer() then
	end
end
function modifier_item_unlock_godwand_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_godwand_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_OUTGOING_PERCENTAGE
	}
end

function modifier_item_unlock_godwand_buff:GetMagicalOutgoingPercentage()
	return self.magical_damage_up + 100
end



AbilityClassHook('item_unlock_godwand', getfenv(1), 'abilities/items/item_unlock_godwand.lua', { KeyValues.ItemsKv })