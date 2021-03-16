LinkLuaModifier("modifier_razor_1_thinker", "abilities/tower/razor/razor_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_1_debuff", "abilities/tower/razor/razor_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if razor_1 == nil then
	razor_1 = class({ iOrderType = FIND_CLOSEST }, nil, ability_base_ai)
end
function razor_1:OnSpellStart(hTarget)
	local hCaster = self:GetCaster()
	local hTarget = hTarget or self:GetCursorTarget()
	-- 雷击伤害
	local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self:GetSpecialValueFor("lightning_damage") * 0.01
	hCaster:DealDamage(hTarget, self, flDamage)
	-- 等离子场
	CreateModifierThinker(hCaster, self, "modifier_razor_1_thinker", { duration = 1.5 }, hTarget:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hTarget:GetAbsOrigin() + Vector(0, 0, 4000))
	ParticleManager:SetParticleControl(iParticleID, 1, hTarget:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 音效
	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Zuus.LightningBolt", hCaster)
end
---------------------------------------------------------------------
-- Modifiers
if modifier_razor_1_thinker == nil then
	modifier_razor_1_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_razor_1_thinker:IsAura()
	return true
end
function modifier_razor_1_thinker:GetAuraRadius()
	if self:GetElapsedTime() < self:GetDuration() / 2 then
		return RemapVal(self:GetElapsedTime(), 0, self:GetDuration() / 2, 0, self.iRadius)
	else
		return RemapVal(self:GetElapsedTime(), self:GetDuration() / 2, self:GetDuration(), self.iRadius, 0)
	end
end
function modifier_razor_1_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_razor_1_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_razor_1_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_razor_1_thinker:GetModifierAura()
	return "modifier_razor_1_debuff"
end
function modifier_razor_1_thinker:GetAuraDuration()
	return self.reduce_duration
end
function modifier_razor_1_thinker:OnCreated(params)
	self.iRadius = self:GetAbilitySpecialValueFor("radius")
	self.iSpeed = 500 / self:GetDuration()
	self.reduce_duration = self:GetAbilitySpecialValueFor("reduce_duration")

	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:EmitSound("Ability.PlasmaField")
		self:StartIntervalThink(self:GetDuration() / 2)
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_plasmafield.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.iSpeed * 2, self.iRadius, 0))
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
	else
	end
end
function modifier_razor_1_thinker:OnIntervalThink()
	self:StartIntervalThink(-1)
	ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.iSpeed * 2, 0, 0))
end
---------------------------------------------------------------------
if modifier_razor_1_debuff == nil then
	modifier_razor_1_debuff = class({}, nil, eom_modifier)
end
function modifier_razor_1_debuff:IsDebuff()
	return true
end
function modifier_razor_1_debuff:OnCreated(params)
	self.movespeed_reduce_pct = self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
	self.plasma_damage = self:GetAbilitySpecialValueFor("plasma_damage")
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.plasma_damage * 0.01
		hCaster:DealDamage(hParent, self:GetAbility(), flDamage)
	end
end
function modifier_razor_1_debuff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = -self.movespeed_reduce_pct,
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.movespeed_reduce_pct,
	}
end
function modifier_razor_1_debuff:GetAttackSpeedPercentage()
	return -self.movespeed_reduce_pct
end
function modifier_razor_1_debuff:GetMoveSpeedBonusPercentage()
	return -self.movespeed_reduce_pct
end