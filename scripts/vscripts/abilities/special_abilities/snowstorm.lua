LinkLuaModifier("modifier_snowstorm", "abilities/special_abilities/snowstorm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_snowstorm_thinker", "abilities/special_abilities/snowstorm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_snowstorm_debuff", "abilities/special_abilities/snowstorm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_snowstorm_effect", "abilities/special_abilities/snowstorm.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if snowstorm == nil then
	snowstorm = class({})
end
function snowstorm:GetIntrinsicModifierName()
	return "modifier_snowstorm"
end
---------------------------------------------------------------------
--Modifiers
if modifier_snowstorm == nil then
	modifier_snowstorm = class({}, nil, eom_modifier)
end
function modifier_snowstorm:OnCreated(params)
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:StartIntervalThink(1)
		end
	end
end
function modifier_snowstorm:OnRefresh(params)
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:StartIntervalThink(1)
		end
	end
end
function modifier_snowstorm:OnDestroy()
	self:StartIntervalThink(-1)
	if IsServer() then
	end
end
function modifier_snowstorm:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()

		if not IsValid(hAbility)
		or not IsValid(hCaster) then
			self:Destroy()
			return
		end

		local hAbility = self:GetAbility()
		if hAbility:IsCooldownReady() then
			StartCooldown(hAbility)
			self.hThinker = CreateModifierThinker(hCaster, hAbility, "modifier_snowstorm_thinker", { duration = hAbility:GetDuration() }, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
		end
	end
end
function modifier_snowstorm:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_snowstorm:OnInBattle()
	self:StartIntervalThink(1)
end
function modifier_snowstorm:OnBattleEnd()
	self:StartIntervalThink(-1)
	if IsValid(self.hThinker) then
		UTIL_Remove(self.hThinker)
	end
end

------------------------------------------------------------------------------
if modifier_snowstorm_thinker == nil then
	modifier_snowstorm_thinker = class({}, nil, BaseModifier)
end
function modifier_snowstorm_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		self.hThinkerEffect = CreateModifierThinker(hCaster, hAbility, "modifier_snowstorm_effect", { duration = hAbility:GetDuration() }, hParent:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
		self:StartIntervalThink(1)
	end
	if IsClient() then
		-- particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf
		-- local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", self:GetCaster()), PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_snowstorm_thinker:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	if IsServer() then
	end
end
function modifier_snowstorm_thinker:OnDestroy(params)
	if IsServer() then
		if self.hThinkerEffect then
			self.hThinkerEffect:RemoveModifierByName("modifier_snowstorm_effect")
		end
	end
end
function modifier_snowstorm_thinker:OnIntervalThink()
	local hCaster = self:GetCaster()
	if not IsValid(hCaster) then
		return
	end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hEnemies = FindUnitsInRadius(
	hCaster:GetTeamNumber(),
	hParent:GetAbsOrigin(),
	nil,
	self.radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_DAMAGE_FLAG_NONE,
	FIND_ANY_ORDER,
	false)

	for _, hUnit in pairs(hEnemies) do
		local tDamage = {
			ability = hAbility,
			attacker = hCaster,
			victim = hUnit,
			damage = hAbility:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_CUSTOM
		}
		ApplyDamage(tDamage)

		if hUnit:IsAlive() then
			local duration = GetStatusDebuffDuration(self.slow_duration, hUnit, hCaster)
			hUnit:AddNewModifier(hCaster, hAbility, "modifier_snowstorm_debuff", { duration = duration })
		end
	end
end
------------------------------------------------------------------------------
if modifier_snowstorm_effect == nil then
	modifier_snowstorm_effect = class({}, nil, BaseModifier)
end
function modifier_snowstorm_effect:OnCreated(params)
	if IsServer() then

	end
end
function modifier_snowstorm_effect:OnRefresh(params)
	if IsClient() then
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_snowstorm_effect:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_snowstorm_effect:DeclareFunctions()
	return {
	}
end
function modifier_snowstorm_effect:CheckState()
	return {
	}
end
------------------------------------------------------------------------------
if modifier_snowstorm_debuff == nil then
	modifier_snowstorm_debuff = class({})
end
function modifier_snowstorm_debuff:IsDebuff()
	return true
end
function modifier_snowstorm_debuff:OnCreated(params)
	self.speed_slow_pct = self:GetAbilitySpecialValueFor("speed_slow_pct")
	if IsClient()	then
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_frost.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_snowstorm_debuff:OnRefresh(params)
	self.speed_slow_pct = self:GetAbilitySpecialValueFor("speed_slow_pct")
end
function modifier_snowstorm_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end
function modifier_snowstorm_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.speed_slow_pct
end