LinkLuaModifier( "modifier_lanaya_3", "abilities/tower/lanaya/lanaya_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if lanaya_3 == nil then
	lanaya_3 = class({})
end
function lanaya_3:GetIntrinsicModifierName()
	return "modifier_lanaya_3"
end

function lanaya_3:OnSpellStart()
	local hCaster = self:GetCaster()
	-- local radius = self:GetSpecialValueFor('radius')
	-- local stun_duration = self:GetSpecialValueFor('stun_duration')
	self.critical_bonus_chance = self:GetSpecialValueFor("critical_bonus_chance")
	self.critical_bonus_damage_pct = self:GetSpecialValueFor("critical_bonus_damage_pct")
end

---------------------------------------------------------------------
--Modifiers
if modifier_lanaya_3 == nil then
	modifier_lanaya_3 = class({}, nil, eom_modifier)
end
function modifier_lanaya_3:OnCreated(params)
	self.critical_bonus_chance = self:GetAbility():GetSpecialValueFor("critical_bonus_chance")
	self.critical_bonus_damage_pct = self:GetAbility():GetSpecialValueFor("critical_bonus_damage_pct")
end
function modifier_lanaya_3:OnRefresh(params)
	self.critical_bonus_chance = self:GetAbility():GetSpecialValueFor("critical_bonus_chance")
	self.critical_bonus_damage_pct = self:GetAbility():GetSpecialValueFor("critical_bonus_damage_pct")
end

function modifier_lanaya_3:EDeclareFunctions()
	return {
		EMDF_DAMAGE_CRIT_BONUS,
		EMDF_EVENT_ON_ATTACK_HIT
	}
end

function modifier_lanaya_3:GetDamageCritBonus()
	return self.critical_bonus_damage_pct, self.critical_bonus_chance
end
function modifier_lanaya_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_lanaya_3:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 2
	if 0 == self.iTooltip then
		return self.critical_bonus_chance
	end
	return self.critical_bonus_damage_pct
end
-- function modifier_lanaya_3:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
-- 	if nil == hTarget
-- 	or tAttackInfo.attacker ~= self:GetParent()
-- 	or IsAttackMiss(tAttackInfo)
-- 	or self:GetParent():PassivesDisabled()
-- 	or not IsAttackCrit(tAttackInfo)
-- 	then return end
-- end
