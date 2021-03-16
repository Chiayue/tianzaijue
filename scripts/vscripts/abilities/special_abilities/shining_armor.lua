LinkLuaModifier("modifier_shining_armor", "abilities/special_abilities/shining_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shining_armor_buff", "abilities/special_abilities/shining_armor.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if shining_armor == nil then
	shining_armor = class({})
end
function shining_armor:GetIntrinsicModifierName()
	return "modifier_shining_armor"
end
---------------------------------------------------------------------
--Modifiers
if modifier_shining_armor == nil then
	modifier_shining_armor = class({})
end
function modifier_shining_armor:IsAura()
	return true
end
function modifier_shining_armor:GetAuraDuration()
	return 0.5
end
function modifier_shining_armor:GetAuraRadius()
	return self.radius
end
function modifier_shining_armor:GetModifierAura()
	return "modifier_shining_armor_buff"
end
function modifier_shining_armor:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_shining_armor:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_shining_armor:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_shining_armor:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_shining_armor:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_shining_armor:OnDestroy()
	if IsServer() then
	end
end

------------------------------------------------------------------------------
if modifier_shining_armor_buff == nil then
	modifier_shining_armor_buff = class({}, nil, eom_modifier)
end
function modifier_shining_armor_buff:OnCreated(params)
	self.physical_armor_bonus = self:GetAbilitySpecialValueFor("physical_armor_bonus")
end
function modifier_shining_armor_buff:OnRefresh(params)
	self.physical_armor_bonus = self:GetAbilitySpecialValueFor("physical_armor_bonus")
end
function modifier_shining_armor_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.physical_armor_bonus
	}
end
function modifier_shining_armor_buff:GetPhysicalArmorBonus()
	return self.physical_armor_bonus
end