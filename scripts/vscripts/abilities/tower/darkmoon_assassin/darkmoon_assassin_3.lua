LinkLuaModifier("modifier_darkmoon_assassin_3", "abilities/tower/darkmoon_assassin/darkmoon_assassin_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if darkmoon_assassin_3 == nil then
	darkmoon_assassin_3 = class({})
end
function darkmoon_assassin_3:GetCritValue(flDamage)
	if RollPercentage(self:GetSpecialValueFor("crit_chance")) then
		return flDamage * self:GetSpecialValueFor("crit_damage_pct") * 0.01
	end
	return flDamage
end
function darkmoon_assassin_3:GetIntrinsicModifierName()
	return "modifier_darkmoon_assassin_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_darkmoon_assassin_3 == nil then
	modifier_darkmoon_assassin_3 = class({}, nil, eom_modifier)
end
function modifier_darkmoon_assassin_3:IsHidden()
	return true
end
function modifier_darkmoon_assassin_3:OnCreated(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor("crit_damage_pct")
end
function modifier_darkmoon_assassin_3:OnRefresh(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor("crit_damage_pct")
end
function modifier_darkmoon_assassin_3:GetAttackCritBonus()
	return self.crit_damage_pct, self.crit_chance
end
function modifier_darkmoon_assassin_3:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS
	}
end