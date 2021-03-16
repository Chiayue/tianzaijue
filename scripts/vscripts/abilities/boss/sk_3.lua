LinkLuaModifier( "modifier_sk_3", "abilities/boss/sk_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sk_3_thinker", "abilities/boss/sk_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sk_3_debuff", "abilities/boss/sk_3.lua", LUA_MODIFIER_MOTION_NONE )

--Abilities
if sk_3 == nil then
	sk_3 = class({})
end
function sk_3:OnSpellStart()
	self.hThinker = CreateModifierThinker(self:GetCaster(), self, "modifier_sk_3_thinker", {duration = self:GetDuration()}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end
function sk_3:GetIntrinsicModifierName()
	return "modifier_sk_3"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_sk_3 == nil then
	modifier_sk_3 = class({}, nil, BaseModifier)
end
function modifier_sk_3:OnCreated(params)
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_sk_3:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) and self:GetParent():GetHealthPercent() < self.threshold then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self:GetAbility():entindex(),
			})
		end
	end
end
function modifier_sk_3:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_sk_3_thinker == nil then
	modifier_sk_3_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_sk_3_thinker:IsAura()
	return true
end
function modifier_sk_3_thinker:GetAuraRadius()
	return self.radius
end
function modifier_sk_3_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_sk_3_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_sk_3_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_sk_3_thinker:GetModifierAura()
	return "modifier_sk_3_debuff"
end
function modifier_sk_3_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.damage = self:GetAbility():GetAbilityDamage()
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( iParticleID, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( iParticleID, 1, Vector(self.radius, self.radius, self.radius) )
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sk_3_thinker:OnIntervalThink()
	if not IsValid(self:GetCaster()) then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		local damageInfo = 
		{
			victim = hUnit,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = hAbility:GetAbilityDamageType(),
			ability = hAbility,
		}
		ApplyDamage( damageInfo )
	end
	if not self:GetCaster():IsPositionInRange(self:GetParent():GetAbsOrigin(), self.radius) then
		self:Destroy()
	end
end
---------------------------------------------------------------------
if modifier_sk_3_debuff == nil then
	modifier_sk_3_debuff = class({}, nil, BaseModifier)
end
function modifier_sk_3_debuff:IsDebuff()
	return true
end
function modifier_sk_3_debuff:OnCreated()
	self.miss = self:GetAbilitySpecialValueFor("miss")
end
function modifier_sk_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}
end
function modifier_sk_3_debuff:GetModifierMiss_Percentage(params)
	return self.miss
end