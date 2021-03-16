LinkLuaModifier("modifier_kingkong_8", "abilities/boss/kingkong_8.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingkong_8_rush", "abilities/boss/kingkong_8.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if kingkong_8 == nil then
	kingkong_8 = class({})
end
function kingkong_8:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local vCasterLoc = hCaster:GetAbsOrigin()
	-- 播放动作
	hCaster:StartGestureWithPlaybackRate(ACT_DOTA_DEFEAT, 2)
	if IsServer() then
		-- 播放伤害预警
		local flDistance = self:GetSpecialValueFor("distance")
		local flRadius = self:GetSpecialValueFor("radius")
		local vForward = hCaster:GetForwardVector()
		local tPosition = {
			vCasterLoc + Rotation2D(vForward, math.rad(0)) * flDistance,
			vCasterLoc + Rotation2D(vForward, math.rad(90)) * flDistance,
			vCasterLoc + Rotation2D(vForward, math.rad(180)) * flDistance,
			vCasterLoc + Rotation2D(vForward, math.rad(270)) * flDistance,
		}
		self.tParticleID = {}
		for i = 1, #tPosition do
			local iParticleID = ParticleManager:CreateParticle("particles/units/boss/damage_line.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, vCasterLoc)
			ParticleManager:SetParticleControl(iParticleID, 1, tPosition[i])
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(flRadius, 0, 0))
			table.insert(self.tParticleID, iParticleID)
		end
		self.hModifier = hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	end
	return true
end
function kingkong_8:OnAbilityPhaseInterrupted()
	-- 清空特效
	for i, iParticleID in ipairs(self.tParticleID) do
		ParticleManager:DestroyParticle(iParticleID, false)
	end
	self:GetCaster():FadeGesture(ACT_DOTA_DEFEAT)
end
function kingkong_8:OnSpellStart()
	-- 清空特效
	for i, iParticleID in ipairs(self.tParticleID) do
		ParticleManager:DestroyParticle(iParticleID, false)
	end
	self:GetCaster():FadeGesture(ACT_DOTA_DEFEAT)
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local vCasterLoc = hCaster:GetAbsOrigin()
	local vForward = hCaster:GetForwardVector()
	local flDistance = self:GetSpecialValueFor("distance")
	local tPosition = {
		vCasterLoc + Rotation2D(vForward, math.rad(0)) * flDistance,
		vCasterLoc + Rotation2D(vForward, math.rad(90)) * flDistance,
		vCasterLoc + Rotation2D(vForward, math.rad(180)) * flDistance,
		vCasterLoc + Rotation2D(vForward, math.rad(270)) * flDistance,
	}
	for i = 1, #tPosition do
		local hIllusion = CreateUnitByName(hCaster:GetUnitName(), vCasterLoc, false, hCaster, hCaster, hCaster:GetTeamNumber())
		hIllusion:SetForwardVector((tPosition[i] - vCasterLoc):Normalized())
		hIllusion:MakeIllusion()
		hIllusion:AddNewModifier(hCaster, self, "modifier_kingkong_8_rush", { vPosX = tPosition[i].x, vPosY = tPosition[i].y })
	end
	hCaster:EmitSound("Hero_Magnataur.Skewer.Cast")
end
function kingkong_8:GetIntrinsicModifierName()
	return "modifier_kingkong_8"
end
---------------------------------------------------------------------
--Modifiers
if modifier_kingkong_8 == nil then
	modifier_kingkong_8 = class({}, nil, eom_modifier)
end
function modifier_kingkong_8:IsHidden()
	return true
end
function modifier_kingkong_8:OnCreated(params)
	self.trigger_time = self:GetAbilitySpecialValueFor("trigger_time")
	if IsServer() then
		self:StartIntervalThink(self.trigger_time)
	end
end
function modifier_kingkong_8:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_kingkong_8:OnDeath(params)
	if IsServer() and params.unit:IsFriendly(self:GetParent()) == false then
		self:StartIntervalThink(self.trigger_time)
	end
end
function modifier_kingkong_8:OnIntervalThink()
	local hParent = self:GetParent()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self:GetAbility():entindex(),
			Position = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()
		})
	end
end
---------------------------------------------------------------------
if modifier_kingkong_8_rush == nil then
	modifier_kingkong_8_rush = class({}, nil, HorizontalModifier)
end
function modifier_kingkong_8_rush:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_kingkong_8_rush:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end
function modifier_kingkong_8_rush:OnCreated(params)
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		self.distance = self:GetAbilitySpecialValueFor('distance')
		self.fSpeed = self:GetAbilitySpecialValueFor('speed')
		self.vS = self:GetParent():GetAbsOrigin()
		self.vV = (Vector(params.vPosX, params.vPosY, 0) - self.vS):Normalized() * self.fSpeed
		self.radius = self:GetAbilitySpecialValueFor('radius')
		self.impact_damage = self:GetAbilitySpecialValueFor("damage")
		self.knockback_duration = self:GetAbilitySpecialValueFor("knockback_duration")
		self.knockback_distance = self:GetAbilitySpecialValueFor("knockback_distance")
		self.knockback_height = self:GetAbilitySpecialValueFor("knockback_height")
		self.tTargets = {}
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/kingkong/kingkong_6.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/kingkong/kingkong_6_rush.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_kingkong_8_rush:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		for _, hUnit in pairs(self.tTargets) do
			FindClearSpaceForUnit(hUnit, hUnit:GetAbsOrigin(), true)
		end
		if self:GetParent():IsIllusion() then
			self:GetParent():AddNoDraw()
			self:GetParent():ForceKill(false)
		end
	end
end
function modifier_kingkong_8_rush:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vPos = self.vV * dt + self:GetParent():GetAbsOrigin()
		local fDis = (vPos - self.vS):Length2D()
		if fDis > self.distance or GridNav:CanFindPath(self:GetParent():GetAbsOrigin(), vPos) == false then
			fDis = self.distance
		end
		me:SetAbsOrigin(vPos)

		local tTargets = FindUnitsInRadius(me:GetTeamNumber(), vPos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, hUnit in pairs(tTargets) do
			if TableFindKey(self.tTargets, hUnit) == nil then
				table.insert(self.tTargets, hUnit)
				local tDamageInfo = {
					attacker = self:GetCaster(),
					victim = hUnit,
					ability = self:GetAbility(),
					damage = self.impact_damage,
					damage_type = self:GetAbility():GetAbilityDamageType()
				}
				ApplyDamage(tDamageInfo)

				me:KnockBack(me:GetAbsOrigin(), hUnit, self.knockback_distance, self.knockback_height, self.knockback_duration, true)
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
				self:AddParticle(iParticleID, false, false, -1, false, false)
			end
		end

		if fDis == self.distance then
			self:Destroy()
		end
	end
end
function modifier_kingkong_8_rush:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_kingkong_8_rush:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
function modifier_kingkong_8_rush:GetOverrideAnimation(params)
	return ACT_DOTA_RUN
end
function modifier_kingkong_8_rush:GetOverrideAnimationRate(params)
	return 2.5
end
function modifier_kingkong_8_rush:GetActivityTranslationModifiers(params)
	return "haste"
end
function modifier_kingkong_8_rush:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
	}
end