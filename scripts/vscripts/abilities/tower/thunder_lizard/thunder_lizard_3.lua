LinkLuaModifier("modifier_thunder_lizard_3", "abilities/tower/thunder_lizard/thunder_lizard_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_thunder_lizard_3_debuff", "abilities/tower/thunder_lizard/thunder_lizard_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if thunder_lizard_3 == nil then
	thunder_lizard_3 = class({})
end
function thunder_lizard_3:GetIntrinsicModifierName()
	return "modifier_thunder_lizard_3"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_thunder_lizard_3 == nil then
	modifier_thunder_lizard_3 = class({}, nil, eom_modifier)
end
function modifier_thunder_lizard_3:IsHidden()
	return true
end
function modifier_thunder_lizard_3:OnCreated(params)
	local hCaster = self:GetCaster()
	self.armor_bonus_pct = self:GetAbilitySpecialValueFor("armor_bonus_pct")
	if IsServer() then
		hCaster.ReduceMagicalArmor = function(hCaster, hTarget)
			if IsValid(self:GetAbility()) then
				hTarget:AddNewModifier(hCaster, self:GetAbility(), "modifier_thunder_lizard_3_debuff", { duration = self:GetAbility():GetDuration() })
			end
		end
	end
end
function modifier_thunder_lizard_3:OnRefresh(params)
	self.armor_bonus_pct = self:GetAbilitySpecialValueFor("armor_bonus_pct")
end
function modifier_thunder_lizard_3:OnDestroy()
	local hCaster = self:GetCaster()
	if IsServer() then
		hCaster.ReduceMagicalArmor = nil
	end
end
function modifier_thunder_lizard_3:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ARMOR_BONUS] = self.armor_bonus_pct,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.armor_bonus_pct,
	}
end
function modifier_thunder_lizard_3:GetPhysicalArmorBonus()
	return self.armor_bonus_pct
end
function modifier_thunder_lizard_3:GetMagicalArmorBonus()
	return self.armor_bonus_pct
end
---------------------------------------------------------------------
if modifier_thunder_lizard_3_debuff == nil then
	modifier_thunder_lizard_3_debuff = class({}, nil, eom_modifier)
end
function modifier_thunder_lizard_3_debuff:IsDebuff()
	return true
end
function modifier_thunder_lizard_3_debuff:OnCreated(params)
	self.physical_armor_reduce = self:GetAbilitySpecialValueFor("physical_armor_reduce")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_thunder_lizard_3_debuff:OnRefresh(params)
	self.physical_armor_reduce = self:GetAbilitySpecialValueFor("physical_armor_reduce")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_thunder_lizard_3_debuff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ARMOR_BONUS,
	}
end
function modifier_thunder_lizard_3_debuff:GetPhysicalArmorBonus()
	return -self:GetStackCount() * self.physical_armor_reduce
end
function modifier_thunder_lizard_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_thunder_lizard_3_debuff:OnTooltip()
	return self:GetStackCount() * self.physical_armor_reduce
end