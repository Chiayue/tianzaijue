LinkLuaModifier( "modifier_item_courage_medallion", "abilities/items/item_courage_medallion.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_courage_medallion_buff", "abilities/items/item_courage_medallion.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_courage_medallion == nil then
	item_courage_medallion = class({})
end
function item_courage_medallion:GetIntrinsicModifierName()
	return "modifier_item_courage_medallion"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_courage_medallion == nil then
	modifier_item_courage_medallion = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_courage_medallion:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attack_pct = self:GetAbilitySpecialValueFor("attack_pct")
	self.armor_pct = self:GetAbilitySpecialValueFor("armor_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_courage_medallion:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_courage_medallion:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_courage_medallion:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_item_courage_medallion:OnInBattle()
	local hParent = self:GetParent()
	hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_courage_medallion_buff", {duration = self.duration})
end
function modifier_item_courage_medallion:OnDeath(params)
	local hParent = self:GetParent()
	if self:GetAbility():GetLevel() >= self.unlock_level and (hParent == params.attacker or params.unit:IsFriendly(hParent)) then
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_courage_medallion_buff", {duration = self.duration})
	end
end
---------------------------------------------------------------------
if modifier_item_courage_medallion_buff == nil then
	modifier_item_courage_medallion_buff = class({}, nil, eom_modifier)
end
function modifier_item_courage_medallion_buff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attack_pct = self:GetAbilitySpecialValueFor("attack_pct")
	self.armor_pct = self:GetAbilitySpecialValueFor("armor_pct")
	self.move_bonus = 0
	self.attack_bonus = 0
	self.armor_bonus = 0
	if IsServer() then
	end
end
function modifier_item_courage_medallion_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_courage_medallion_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_courage_medallion_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
		EMDF_MOVEMENT_SPEED_BONUS
	}
end
function modifier_item_courage_medallion_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_item_courage_medallion_buff:GetPhysicalAttackBonusPercentage()
	self.attack_bonus =RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), self.attack_pct, 0) 
	return self.attack_bonus or 0
end
function modifier_item_courage_medallion_buff:GetPhysicalArmorBonusPercentage()
	self.armor_bonus =RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), self.armor_pct, 0) 
	return self.armor_bonus or 0
end
function modifier_item_courage_medallion_buff:GetMoveSpeedBonus()
	self.move_bonus =RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), self.movespeed, 0) 
	return self.move_bonus or 0
end
function modifier_item_courage_medallion_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_item_courage_medallion_buff:OnTooltip()
	local hParent = self:GetParent()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 3
	if 0 == self._iTooltip then
		return self.move_bonus
	elseif 1 == self._iTooltip then
		return self.attack_bonus
	elseif 2 == self._iTooltip then
		return self.armor_bonus
	end
end