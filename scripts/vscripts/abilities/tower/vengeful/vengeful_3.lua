LinkLuaModifier("modifier_vengeful_3", "abilities/tower/vengeful/vengeful_3.lua", LUA_MODIFIER_MOTION_NONE)

if vengeful_3 == nil then
	vengeful_3 = class({})
end

function vengeful_3:GetIntrinsicModifierName()
	return "modifier_vengeful_3"
end

---------------------------------------------------------------------
--Modifiers
if modifier_vengeful_3 == nil then
	modifier_vengeful_3 = class({}, nil, eom_modifier)
end
function modifier_vengeful_3:IsHidden()
	return true
end
function modifier_vengeful_3:OnCreated(params)
	self.magical_armor_increase = self:GetAbilitySpecialValueFor("magical_armor_increase")
	self.physical_armor_increase = self:GetAbilitySpecialValueFor("physical_armor_increase")
	if IsServer() then
		self.flDamageRecord = 0
	end
end
function modifier_vengeful_3:OnRefresh(params)
	self.magical_armor_increase = self:GetAbilitySpecialValueFor("magical_armor_increase")
	self.physical_armor_increase = self:GetAbilitySpecialValueFor("physical_armor_increase")
	if IsServer() then
	end
end
function modifier_vengeful_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_vengeful_3:OnTakeDamage(params)
	local caster = params.unit
	if caster == self:GetParent() and self:GetAbility():IsCooldownReady() then
		self:IncrementStackCount()
		self:GetAbility():UseResources(false, false, true)
	end
end
function modifier_vengeful_3:DeclareFunctions()
	return {
	}
end
function modifier_vengeful_3:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {},
	}
end
function modifier_vengeful_3:GetPhysicalArmorBonus()
	return self.physical_armor_increase * self:GetStackCount()
end
function modifier_vengeful_3:GetMagicalArmorBonus()
	return self.magical_armor_increase * self:GetStackCount()
end