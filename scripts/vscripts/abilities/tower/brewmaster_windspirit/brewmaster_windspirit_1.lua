LinkLuaModifier("modifier_brewmaster_windspirit_1", "abilities/tower/brewmaster_windspirit/brewmaster_windspirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brewmaster_windspirit_1_target", "abilities/tower/brewmaster_windspirit/brewmaster_windspirit_1.lua", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_brewmaster_windspirit_3_buff", "abilities/tower/brewmaster_windspirit/brewmaster_windspirit_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if brewmaster_windspirit_1 == nil then
	brewmaster_windspirit_1 = class({iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_LINE_TARGET}, nil, ability_base_ai)
end
function brewmaster_windspirit_1:GetAOERadius()
	return self:GetSpecialValueFor("width")
end
function brewmaster_windspirit_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flWidth = self:GetSpecialValueFor("width")
	local flDistance = self:GetSpecialValueFor("distance")
	local flSpeed = self:GetSpecialValueFor("speed")
	local vDirection = CalculateDirection(vPosition, hCaster)
	local tProjectileInfo =	{
		Ability				= self,
		EffectName			= "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
		vSpawnOrigin		= hCaster:GetAbsOrigin(),
		fDistance			= flDistance,
		fStartRadius		= flWidth,
		fEndRadius			= flWidth,
		Source				= hCaster,
		iUnitTargetTeam		= self:GetAbilityTargetTeam(),
		iUnitTargetFlags	= self:GetAbilityTargetFlags(),
		iUnitTargetType		= self:GetAbilityTargetType(),
		vVelocity			= vDirection * flSpeed,
		bProvidesVision		= false,
	}
	ProjectileManager:CreateLinearProjectile(tProjectileInfo)

	local hAbility_3 = hCaster:FindAbilityByName("brewmaster_windspirit_3")
	local bValid = (IsValid(hAbility_3) and hAbility_3:GetLevel() > 0) and true or false
	if bValid then
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, 12000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, hUnit in pairs(tTargets) do
			hUnit:AddNewModifier(hCaster, hAbility_3, "modifier_brewmaster_windspirit_3_buff", nil)
		end
	end
end
function brewmaster_windspirit_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		hTarget:AddNewModifier(hCaster, self, "modifier_brewmaster_windspirit_1_target", { duration = self:GetDuration() * hTarget:GetStatusResistanceFactor() })
	end
end
function brewmaster_windspirit_1:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
-- Modifiers
if modifier_brewmaster_windspirit_1 == nil then
	modifier_brewmaster_windspirit_1 = class({}, nil, BaseModifier)
end
function modifier_brewmaster_windspirit_1:OnCreated(params)
	if IsServer() then
		self.distance = self:GetAbility():GetCastRange(vec3_invalid, nil)
		self:StartIntervalThink(1)
	end
end
function modifier_brewmaster_windspirit_1:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if IsValid(tTargets[1]) then
			ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_POSITION, nil, self:GetAbility(), tTargets[1]:GetAbsOrigin())
		end
	end
end
-----------------------------------------
if modifier_brewmaster_windspirit_1_target == nil then
	modifier_brewmaster_windspirit_1_target = class({})
end
function modifier_brewmaster_windspirit_1_target:IsHidden()
	return true
end
function modifier_brewmaster_windspirit_1_target:IsDebuff()
	return true
end
function modifier_brewmaster_windspirit_1_target:IsPurgable()
	return false
end
function modifier_brewmaster_windspirit_1_target:IsPurgeException()
	return true
end
function modifier_brewmaster_windspirit_1_target:IsStunDebuff()
	return false
end
function modifier_brewmaster_windspirit_1_target:AllowIllusionDuplicate()
	return false
end
function modifier_brewmaster_windspirit_1_target:OnCreated()
	if IsServer() then
		local pos = self:GetParent():GetAbsOrigin()
		pos.z = GetGroundHeight(pos, self:GetParent())
		self:GetParent():SetAbsOrigin(pos)
		self:StartIntervalThink(1)
		-- 
		self.rate = 1
		self.flRiseTime = 0.3
		self.vVelocity = 1000
		self.vForward = self:GetParent():GetForwardVector()
		self.fAge = 0
		self.fMax = 30
		self.fSpeed = self.fMax
		self.fSpeedAge = 300
		if not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items_fx/cyclone.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_brewmaster_windspirit_1_target:OnRefresh(params)
	if IsServer() then
		local pos = self:GetParent():GetAbsOrigin()
		pos.z = GetGroundHeight(pos, self:GetParent())
		self:GetParent():SetAbsOrigin(pos)
	end
end
function modifier_brewmaster_windspirit_1_target:UpdateVerticalMotion(me, dt)
	if IsServer() then
		local vPos = me:GetAbsOrigin()
		if self:GetElapsedTime() < self.flRiseTime then
			vPos = me:GetAbsOrigin() + Vector(0, 0, self.vVelocity * dt)
		elseif self:GetElapsedTime() > self:GetDuration() - self.flRiseTime then
			vPos = me:GetAbsOrigin() - Vector(0, 0, self.vVelocity * dt)
		else
			local vForward = RotatePosition(Vector(0, 0, 0), QAngle(math.sin(math.rad(self.fAge * 5)) * 5, self.fAge, 0), self.vForward)
			local angle = VectorToAngles(vForward:Normalized())
			me:SetLocalAngles(0, angle[2], 0)
			self.fAge = (self.fAge + self.fSpeedAge * dt) % 360

			local fSpeed = 360 * math.sin(math.rad(self.fAge))
			vPos = Vector(0, 0, fSpeed) * dt + me:GetAbsOrigin()
		end
		me:SetAbsOrigin(vPos)
	end
end
function modifier_brewmaster_windspirit_1_target:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_brewmaster_windspirit_1_target:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local pos = hParent:GetAbsOrigin()
		pos.z = GetGroundHeight(pos, self:GetCaster())
		hParent:SetAbsOrigin(pos)

		self:GetParent():RemoveVerticalMotionController(self)
	end
end
function modifier_brewmaster_windspirit_1_target:OnIntervalThink()
	if self:GetAbility() then
		local damageInfo =	{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetAbility():GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
		}
		ApplyDamage(damageInfo)
	end
end
function modifier_brewmaster_windspirit_1_target:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	-- MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
end
function modifier_brewmaster_windspirit_1_target:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
-- function modifier_brewmaster_windspirit_1_target:GetVisualZDelta(params)
-- 	return self.visual_zdelta
-- end
function modifier_brewmaster_windspirit_1_target:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end