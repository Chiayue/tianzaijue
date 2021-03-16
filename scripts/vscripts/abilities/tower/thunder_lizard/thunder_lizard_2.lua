LinkLuaModifier("modifier_thunder_lizard_2", "abilities/tower/thunder_lizard/thunder_lizard_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_thunder_lizard_2_thinker", "abilities/tower/thunder_lizard/thunder_lizard_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_thunder_lizard_2_slow", "abilities/tower/thunder_lizard/thunder_lizard_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if thunder_lizard_2 == nil then
	thunder_lizard_2 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_LINE_TARGET }, nil, ability_base_ai)
end
function thunder_lizard_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function thunder_lizard_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	hCaster:AddNewModifier(hCaster, self, "modifier_thunder_lizard_2_thinker", { duration = self:GetDuration(), vDirection = vDirection })
end
function thunder_lizard_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget ~= nil then
		local vDirection = Vector(ExtraData.vDirX, ExtraData.vDirY, 0)
		self:GetCaster():DealDamage(hTarget, self)
		if hTarget:IsCreep() then
			self:GetCaster():KnockBack(hTarget:GetAbsOrigin() - vDirection, hTarget, self:GetSpecialValueFor("pull_distance"), 0, 0.25, false)
		end
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_thunder_lizard_2_slow", { duration = self:GetSpecialValueFor("slow_duration") })
	end
end
function thunder_lizard_2:GetIntrinsicModifierName()
	return "modifier_thunder_lizard_2"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_thunder_lizard_2 == nil then
	modifier_thunder_lizard_2 = class({}, nil, ModifierHidden)
end
function modifier_thunder_lizard_2:OnCreated(params)
	if IsServer() then
		self.distance = self:GetAbility():GetCastRange(vec3_invalid, nil)
		self:StartIntervalThink(1)
	end
end
function modifier_thunder_lizard_2:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility())
		if IsValid(tTargets[1]) then
			local vPosition = hParent:GetAbsOrigin() + CalculateDirection(tTargets[1], hParent) * self.distance
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, self:GetAbility(), vPosition)
			-- hParent:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_POSITION, {vPosition = vPosition})
		end
	end
end
---------------------------------------------------------------------
if modifier_thunder_lizard_2_thinker == nil then
	modifier_thunder_lizard_2_thinker = class({}, nil, ModifierHidden)
end
function modifier_thunder_lizard_2_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.collision_radius = self:GetAbilitySpecialValueFor("collision_radius")
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.counts_per_sec = self:GetAbilitySpecialValueFor("counts_per_sec")
	if IsServer() then
		self:StartIntervalThink(1 / self.counts_per_sec)
		self.vDirection = StringToVector(params.vDirection)
	end
end
function modifier_thunder_lizard_2_thinker:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	if not IsValid(hAbility) and not IsValid(hCaster) then
		self:Destroy()
		return
	end
	local hParent = self:GetParent()
	local vPosition = hParent:GetAbsOrigin()

	local vStartPosition = vPosition - self.vDirection * self.radius + Rotation2D(self.vDirection, math.rad(90)) * RandomFloat(-self.radius, self.radius)

	local tInfo = {
		Ability = hAbility,
		Source = hCaster,
		EffectName = "particles/units/heroes/thunder_lizard/thunder_lizard_2.vpcf",
		vSpawnOrigin = vStartPosition,
		vVelocity = self.vDirection * self.speed,
		fDistance = self.distance,
		fStartRadius = self.collision_radius,
		fEndRadius = self.collision_radius,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		ExtraData = {
			vDirX = self.vDirection.x,
			vDirY = self.vDirection.y
		}
	}
	ProjectileManager:CreateLinearProjectile(tInfo)
end
---------------------------------------------------------------------
if modifier_thunder_lizard_2_slow == nil then
	modifier_thunder_lizard_2_slow = class({}, nil, eom_modifier)
end
function modifier_thunder_lizard_2_slow:IsDebuff()
	return true
end
function modifier_thunder_lizard_2_slow:IsPurgable()
	return true
end
function modifier_thunder_lizard_2_slow:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf"
end
function modifier_thunder_lizard_2_slow:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end
function modifier_thunder_lizard_2_slow:OnCreated(params)
	self.slow_pct = self:GetAbilitySpecialValueFor("slow_pct")
	if IsServer() then
	end
end
function modifier_thunder_lizard_2_slow:EDeclareFunctions()
	return {
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.slow_pct,
	}
end
function modifier_thunder_lizard_2_slow:GetMoveSpeedBonusPercentage()
	return -self.slow_pct
end