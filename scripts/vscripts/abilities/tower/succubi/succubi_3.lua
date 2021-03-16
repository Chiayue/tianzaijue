LinkLuaModifier("modifier_succubi_3", "abilities/tower/succubi/succubi_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_succubi_3_thinker", "abilities/tower/succubi/succubi_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_succbi_3_debuff", "abilities/tower/succubi/succubi_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if succubi_3 == nil then
	succubi_3 = class({})
end
function succubi_3:GetIntrinsicModifierName()
	return "modifier_succubi_3"
end

function succubi_3:OnSpellStart()

	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPositionCaster = hCaster:GetAbsOrigin()
	local vPositionTarget = hTarget:GetAbsOrigin()
	local vDirection = (vPositionTarget - vPositionCaster):Normalized()
	local distance = CalculateDistance(hCaster, hTarget) / 2

	local vLocation = vPositionCaster + distance * vDirection

	CreateModifierThinker(hCaster, self, "modifier_succubi_3_thinker", { duration = 50 }, vLocation, hCaster:GetTeamNumber(), false)
end

---------------------------------------------------------------------
---光环
if modifier_succubi_3_thinker == nil then
	modifier_succubi_3_thinker = class({}, nil, eom_modifier)
end
function modifier_succubi_3_thinker:IsAura()
	return true
end
function modifier_succubi_3_thinker:IsHidden()
	return true
end
function modifier_succubi_3_thinker:IsDebuff()
	return false
end
function modifier_succubi_3_thinker:IsPurgable()
	return false
end
function modifier_succubi_3_thinker:IsPurgeException()
	return false
end
function modifier_succubi_3_thinker:AllowIllusionDuplicate()
	return false
end
function modifier_succubi_3_thinker:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_succubi_3_thinker:IsStunDebuff()
	return false
end
function modifier_succubi_3_thinker:AllowIllusionDuplicate()
	return false
end

function modifier_succubi_3_thinker:GetAuraRadius()
	return RemapVal(self:GetElapsedTime(), 0, 50, 250, 500)
end

function modifier_succubi_3_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_succubi_3_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_succubi_3_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_succubi_3_thinker:GetModifierAura()
	return "modifier_succbi_3_debuff"
end
function modifier_succubi_3_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.radius_max = self:GetAbilitySpecialValueFor("radius_max")
	self.time = self:GetAbilitySpecialValueFor("time")
	self.strike_count_increase = self:GetAbilitySpecialValueFor("strike_count_increase")
	if IsServer() then
		self.damage = self:GetAbility():GetAbilityDamage()
		self:StartIntervalThink(2)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/succubi/succubi_3_arcana_sonic_wave_ground_dark.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_succubi_3_thinker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	end
end

function modifier_succubi_3_thinker:OnRefresh(params)
	self.strike_count_increase = self:GetAbilitySpecialValueFor("strike_count_increase")
	local radius_in_fact = RemapVal(self:GetElapsedTime(), 0, self.time, self.radius, self.radius_max)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/succubi/succubi_3_arcana_sonic_wave_ground_dark.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius_in_fact, radius_in_fact, radius_in_fact))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end

function modifier_succubi_3_thinker:OnIntervalThink()
	if not IsValid(self:GetCaster()) then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local radius_in_fact = RemapVal(self:GetElapsedTime(), 0, self.time, self.radius, self.radius_max)
	local tTargets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius_in_fact, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		-- if not hUnit:HasModifier("modifier_succubi_1_shadow_strike_debuff") then
		-- 	hUnit:AddNewModifier(hCaster, hAbility, "modifier_succubi_1_shadow_strike_debuff", {})
		-- 	hUnit:SetModifierStackCount("modifier_succubi_1_shadow_strike_debuff", hCaster, self.strike_count_increase)
		-- end
		-- local curStackCount = hUnit:GetModifierStackCount("modifier_succubi_1_shadow_strike_debuff", hCaster)
		-- hUnit:SetModifierStackCount("modifier_succubi_1_shadow_strike_debuff", hCaster, curStackCount + self.strike_count_increase)
		-- hUnit:AddNewModifier(hCaster, hAbility, "modifier_succbi_3_debuff", {})
		if not hUnit:HasModifier("modifier_poison") then
			hUnit:AddBuff(hCaster, BUFF_TYPE.POISON)
			-- hUnit:SetModifierStackCount("modifier_succubi_1_shadow_strike_debuff", hCaster, self.strike_count_increase)
		end
		local curStackCount = hUnit:FindModifierByName("modifier_poison"):GetStackCount()
		hUnit:SetModifierStackCount("modifier_poison", hCaster, curStackCount + self.strike_count_increase)
		hUnit:AddNewModifier(hCaster, hAbility, "modifier_succbi_3_debuff", {})
	end
end

function modifier_succubi_3_thinker:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_succubi_3_thinker:OnBattleEnd()
	self:Destroy()
end
---------------------------------------------------------------------
--debuff
if modifier_succbi_3_debuff == nil then
	modifier_succbi_3_debuff = class({}, nil, eom_modifier)
end
function modifier_succbi_3_debuff:OnCreated(params)
	self.movement_decrease_pct = self:GetAbilitySpecialValueFor("movement_decrease_pct")
	if IsServer() then
	end
end
function modifier_succbi_3_debuff:OnRefresh(params)
	self.movement_decrease_pct = self:GetAbilitySpecialValueFor("movement_decrease_pct")
	if IsServer() then
	end
end
function modifier_succbi_3_debuff:OnDestroy()
	if IsServer() then
	end
end

function modifier_succbi_3_debuff:EDeclareFunctions()
	return {
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.movement_decrease_pct,
	}
end

function modifier_succbi_3_debuff:GetMoveSpeedBonusPercentage()
	return -self.movement_decrease_pct
end

function modifier_succbi_3_debuff:IsDebuff()
	return true
end
function modifier_succbi_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_succbi_3_debuff:OnTooltip()
	return self.movement_decrease_pct
end

---------------------------------------------------------------------
--Modifiers
if modifier_succubi_3 == nil then
	modifier_succubi_3 = class({}, nil, eom_modifier)
end
function modifier_succubi_3:OnCreated(params)

	if IsServer() then
	end
end
function modifier_succubi_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_succubi_3:OnDestroy()
	if IsServer() then
	end
end

function modifier_succubi_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end

function modifier_succubi_3:OnInBattle()
	self:StartIntervalThink(1)
end
function modifier_succubi_3:OnBattleEnd()
	self:StartIntervalThink(-1)
end

function modifier_succubi_3:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local tTargets = Spawner:FindMissingInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, GetPlayerID(self:GetParent()))
		if IsValid(tTargets[1]) then
			self:GetParent():PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_TARGET, { hTarget = tTargets[1] })
		end
		self:StartIntervalThink(-1)
	end
end

function modifier_succubi_3:IsHidden()
	return true
end