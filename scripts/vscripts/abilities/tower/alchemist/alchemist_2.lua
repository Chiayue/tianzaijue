LinkLuaModifier("modifier_alchemist_2", "abilities/tower/alchemist/alchemist_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if alchemist_2 == nil then
	alchemist_2 = class({})
end
function alchemist_2:GetIntrinsicModifierName()
	return "modifier_alchemist_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_alchemist_2 == nil then
	modifier_alchemist_2 = class({}, nil, eom_modifier)
end
function modifier_alchemist_2:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_alchemist_2:OnCreated(params)
	self.attack = self:GetAbilitySpecialValueFor("attack")
	self.health = self:GetAbilitySpecialValueFor("health")
	self.armor = self:GetAbilitySpecialValueFor("armor")
	if IsServer() then
	end
end
function modifier_alchemist_2:OnRefresh(params)
	self.attack = self:GetAbilitySpecialValueFor("attack")
	self.health = self:GetAbilitySpecialValueFor("health")
	self.armor = self:GetAbilitySpecialValueFor("armor")
end
function modifier_alchemist_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_alchemist_2:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_alchemist_2:OnBattleEnd()
	self:SetStackCount(0)
end
function modifier_alchemist_2:GetPhysicalAttackBonus()
	return self.attack * self:GetStackCount()
end
function modifier_alchemist_2:GetStatusHealthBonus()
	return self.health * self:GetStackCount()
end
function modifier_alchemist_2:GetPhysicalArmorBonus()
	return self.armor * self:GetStackCount()
end
function modifier_alchemist_2:GetMagicalArmorBonus()
	return self.armor * self:GetStackCount()
end
function modifier_alchemist_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_alchemist_2:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 2
	if 0 == self.iTooltip then
		return self.attack * self:GetStackCount()
	elseif 1 == self.iTooltip then
		return self.armor * self:GetStackCount()
	end
	return self.health * self:GetStackCount()
end