LinkLuaModifier("modifier_item_unlock_sowrd", "abilities/items/item_unlock_sowrd.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_unlock_sowrd_buff", "abilities/items/item_unlock_sowrd.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--恐鳌之戒
if item_unlock_sowrd == nil then
	item_unlock_sowrd = class({}, nil, base_ability_attribute)
end
function item_unlock_sowrd:GetIntrinsicModifierName()
	return "modifier_item_unlock_sowrd"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_unlock_sowrd == nil then
	modifier_item_unlock_sowrd = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_unlock_sowrd:OnCreated(params)
	self.unlock_count = self:GetAbilitySpecialValueFor("unlock_count")
	self.unlock_physical_attack = self:GetAbilitySpecialValueFor("unlock_physical_attack")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_item_unlock_sowrd:IsHidden()
	return false
end
function modifier_item_unlock_sowrd:OnRefresh(params)
	self.unlock_count = self:GetAbilitySpecialValueFor("unlock_count")
	self.unlock_physical_attack = self:GetAbilitySpecialValueFor("unlock_physical_attack")
	if IsServer() then
	end
end
function modifier_item_unlock_sowrd:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_sowrd:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
	}
end
function modifier_item_unlock_sowrd:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_unlock_sowrd:OnTooltip()
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

function modifier_item_unlock_sowrd:OnDeath(params)
	if params.attacker == self:GetParent() then
		self:IncrementStackCount()
		self:GetAbility():Save("iStackCount", self:GetStackCount())
		if self:GetStackCount() == self.unlock_count then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_unlock_sowrd_buff", {})
		end
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_item_unlock_sowrd_buff == nil then
	modifier_item_unlock_sowrd_buff = class({}, nil, eom_modifier)
end
function modifier_item_unlock_sowrd_buff:OnCreated(params)
	self.unlock_physical_attack = self:GetAbilitySpecialValueFor("unlock_physical_attack")
	if IsServer() then
	end
end
function modifier_item_unlock_sowrd_buff:OnRefresh(params)
	self.unlock_physical_attack = self:GetAbilitySpecialValueFor("unlock_physical_attack")
	if IsServer() then
	end
end
function modifier_item_unlock_sowrd_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_unlock_sowrd_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_UNIQUE
	}
end

function modifier_item_unlock_sowrd_buff:GetPhysicalAttackBonusUnique()
	return self.unlock_physical_attack
end



AbilityClassHook('item_unlock_sowrd', getfenv(1), 'abilities/items/item_unlock_sowrd.lua', { KeyValues.ItemsKv })