LinkLuaModifier("modifier_vengeful_spirit_3", "abilities/tower/vengeful_spirit/vengeful_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vengeful_spirit_3_physical_armor", "abilities/tower/vengeful_spirit/vengeful_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vengeful_spirit_3_magical_armor", "abilities/tower/vengeful_spirit/vengeful_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if vengeful_spirit_3 == nil then
	vengeful_spirit_3 = class({})
end
function vengeful_spirit_3:GetIntrinsicModifierName()
	return "modifier_vengeful_spirit_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_vengeful_spirit_3 == nil then
	modifier_vengeful_spirit_3 = class({}, nil, eom_modifier)
end
function modifier_vengeful_spirit_3:IsHidden()
	return true
end
function modifier_vengeful_spirit_3:OnCreated(params)
	if IsServer() then
		self.hModifierPhysical = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_vengeful_spirit_3_physical_armor", {})
		self.hModifierMagical = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_vengeful_spirit_3_magical_armor", {})
	end
end
function modifier_vengeful_spirit_3:OnRefresh(params)
	if IsServer() then
		self.hModifierPhysical = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_vengeful_spirit_3_physical_armor", {})
		self.hModifierMagical = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_vengeful_spirit_3_magical_armor", {})
	end
end
function modifier_vengeful_spirit_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_vengeful_spirit_3:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_EVENT_ON_PREPARATION,
		EMDF_EVENT_ON_IN_BATTLE
	}
end
function modifier_vengeful_spirit_3:OnTakeDamage(params)
	if params.unit ~= self:GetParent()
	or not self:GetParent():IsAlive() then
		return
	end

	if self:GetAbility():IsCooldownReady() then
		if params.damage_type == DAMAGE_TYPE_MAGICAL then
			self.hModifierMagical = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_vengeful_spirit_3_magical_armor", {})
			self:GetAbility():UseResources(false, false, true)
		elseif params.damage_type == DAMAGE_TYPE_PHYSICAL then
			self.hModifierPhysical = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_vengeful_spirit_3_physical_armor", {})
			self:GetAbility():UseResources(false, false, true)
		end
	end
end
function modifier_vengeful_spirit_3:OnPreparation()
	-- 备战阶段清0护甲buff
	if IsValid(self.hModifierPhysical) then
		self.hModifierPhysical:SetStackCount(0)
	end
	if IsValid(self.hModifierMagical) then
		self.hModifierMagical:SetStackCount(0)
	end
end
function modifier_vengeful_spirit_3:OnInBattle()
	-- 备战阶段清0护甲buff
	if IsValid(self.hModifierPhysical) then
		self.hModifierPhysical:SetStackCount(0)
	end
	if IsValid(self.hModifierMagical) then
		self.hModifierMagical:SetStackCount(0)
	end
end

------------------------------------------------------------------------------
if modifier_vengeful_spirit_3_physical_armor == nil then
	modifier_vengeful_spirit_3_physical_armor = class({}, nil, eom_modifier)
end
function modifier_vengeful_spirit_3_physical_armor:OnCreated(params)
	self.physical_armor_bonus = self:GetAbilitySpecialValueFor("physical_armor_bonus")
end
function modifier_vengeful_spirit_3_physical_armor:OnRefresh(params)
	self.physical_armor_bonus = self:GetAbilitySpecialValueFor("physical_armor_bonus")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_vengeful_spirit_3_physical_armor:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_vengeful_spirit_3_physical_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_vengeful_spirit_3_physical_armor:GetPhysicalArmorBonus()
	return self.physical_armor_bonus * self:GetStackCount()
end
function modifier_vengeful_spirit_3_physical_armor:OnTooltip()
	return self.physical_armor_bonus * self:GetStackCount()
end

------------------------------------------------------------------------------
if modifier_vengeful_spirit_3_magical_armor == nil then
	modifier_vengeful_spirit_3_magical_armor = class({}, nil, eom_modifier)
end
function modifier_vengeful_spirit_3_magical_armor:OnCreated(params)
	self.magical_armor_bonus = self:GetAbilitySpecialValueFor("magical_armor_bonus")
end
function modifier_vengeful_spirit_3_magical_armor:OnRefresh(params)
	self.magical_armor_bonus = self:GetAbilitySpecialValueFor("magical_armor_bonus")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_vengeful_spirit_3_magical_armor:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ARMOR_BONUS
	}
end
function modifier_vengeful_spirit_3_magical_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_vengeful_spirit_3_magical_armor:GetMagicalArmorBonus()
	return self.magical_armor_bonus * self:GetStackCount()
end
function modifier_vengeful_spirit_3_magical_armor:OnTooltip()
	return self.magical_armor_bonus * self:GetStackCount()
end