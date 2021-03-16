LinkLuaModifier("modifier_skywrath_mage_2", "abilities/tower/skywrath_mage/skywrath_mage_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skywrath_mage_2_buff", "abilities/tower/skywrath_mage/skywrath_mage_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if skywrath_mage_2 == nil then
	skywrath_mage_2 = class({})
end
function skywrath_mage_2:GetIntrinsicModifierName()
	return "modifier_skywrath_mage_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_skywrath_mage_2 == nil then
	modifier_skywrath_mage_2 = class({}, nil, BaseModifier)
end
function modifier_skywrath_mage_2:GetAuraEntityReject(hEntity)
	if hEntity:HasFlyMovementCapability() then
		return false
	end
	return true
end
function modifier_skywrath_mage_2:IsAura()
	return true
end
function modifier_skywrath_mage_2:GetAuraRadius()
	return -1
end
function modifier_skywrath_mage_2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end
function modifier_skywrath_mage_2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_skywrath_mage_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_skywrath_mage_2:GetModifierAura()
	return "modifier_skywrath_mage_2_buff"
end
function modifier_skywrath_mage_2:OnCreated(params)
	if IsServer() then
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_skywrath_mage_2_buff == nil then
	modifier_skywrath_mage_2_buff = class({}, nil, BaseModifier)
end
function modifier_skywrath_mage_2_buff:IsDebuff()
	if self:GetParent():IsFriendly(self:GetCaster()) then
		return false
	else
		return true
	end
end
function modifier_skywrath_mage_2_buff:OnCreated(params)
	self.damage_increase = self:GetAbilitySpecialValueFor("damage_increase")
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	if IsServer() then
	end
end
function modifier_skywrath_mage_2_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_skywrath_mage_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_skywrath_mage_2_buff:GetModifierPreAttack_BonusDamage()
	if self:GetParent():IsFriendly(self:GetCaster()) then
		return self.damage_increase
	else
		return -self.damage_reduce
	end
end