LinkLuaModifier("modifier_omni_knight_2", "abilities/tower/omni_knight/omni_knight_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omni_knight_2_buff", "abilities/tower/omni_knight/omni_knight_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if omni_knight_2 == nil then
	omni_knight_2 = class({})
end
function omni_knight_2:GetIntrinsicModifierName()
	return "modifier_omni_knight_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_omni_knight_2 == nil then
	modifier_omni_knight_2 = class({}, nil, ModifierHidden)
end
function modifier_omni_knight_2:OnCreated(params)
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_omni_knight_2:OnIntervalThink()
	if self:GetAbility():IsAbilityReady() then
		EachUnits(GetPlayerID(self:GetParent()), function(hFriend)
			if hFriend:GetHealthPercent() <= self.threshold and self:GetAbility():IsAbilityReady() then
				self:GetAbility():UseResources(false, false, true)
				hFriend:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_omni_knight_2_buff", { duration = self:GetAbility():GetDuration() })
			end
		end, UnitType.Building)
	end
end
---------------------------------------------------------------------
if modifier_omni_knight_2_buff == nil then
	modifier_omni_knight_2_buff = class({}, nil, eom_modifier)
end
function modifier_omni_knight_2_buff:OnCreated(params)
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
	self.lifesteal_pct = self:GetAbilitySpecialValueFor("lifesteal_pct")
	if IsServer() then
		self:GetParent():EmitSound("Hero_Omniknight.Repel")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_omni_knight_2_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ARMOR_BONUS] = self.bonus_armor,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.bonus_armor,
		[EMDF_DAMAGE_HELF_BONUS_PERCENTAGE] = self.lifesteal_pct,
	}
end
function modifier_omni_knight_2_buff:GetMagicalArmorBonus()
	return self.bonus_armor
end
function modifier_omni_knight_2_buff:GetPhysicalArmorBonus()
	return self.bonus_armor
end
function modifier_omni_knight_2_buff:GetDamageHealBonusPercentage()
	return self.lifesteal_pct
end
function modifier_omni_knight_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_omni_knight_2_buff:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 2
	if 0 == self.iTooltip then
		return self.bonus_armor
	end
	return self.lifesteal_pct
end