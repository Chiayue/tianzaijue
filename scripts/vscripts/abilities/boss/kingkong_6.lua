LinkLuaModifier("modifier_kingkong_6", "abilities/boss/kingkong_6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingkong_6_rush", "abilities/boss/kingkong_6.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if kingkong_6 == nil then
	---@class kingkong_6 合计
	kingkong_6 = class({})
end
function kingkong_6:OnAbilityPhaseStart()
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_DEFEAT, 3)
	if IsServer() then
		self.hModifier = self:GetCaster():AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY)
	end
	return true
end
function kingkong_6:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_DEFEAT)
end
function kingkong_6:OnSpellStart()
	self.hModifier:Destroy()
	self:GetCaster():FadeGesture(ACT_DOTA_DEFEAT)
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	hCaster:AddNewModifier(hCaster, self, "modifier_kingkong_6_rush", nil)
	hCaster:EmitSound("Hero_Magnataur.Skewer.Cast")
end
function kingkong_6:GetIntrinsicModifierName()
	return "modifier_kingkong_6"
end
---------------------------------------------------------------------
--Modifiers
if modifier_kingkong_6 == nil then
	modifier_kingkong_6 = class({}, nil, BaseModifier)
end
function modifier_kingkong_6:IsHidden()
	return true
end
function modifier_kingkong_6:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_kingkong_6:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) and self:GetParent():GetHealthPercent() <= self.trigger_pct then
		if self:GetParent():GetAttackTarget() then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self:GetAbility():entindex(),
				Position = self:GetParent():GetAttackTarget():GetAbsOrigin()
			})
		end
	end
end
---------------------------------------------------------------------
if modifier_kingkong_6_rush == nil then
	modifier_kingkong_6_rush = class({}, nil, HorizontalModifier)
end
function modifier_kingkong_6_rush:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_kingkong_6_rush:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end
function modifier_kingkong_6_rush:OnCreated(params)
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		self.distance = self:GetAbilitySpecialValueFor('distance')
		self.fSpeed = self:GetAbilitySpecialValueFor('speed')
		self.vS = self:GetParent():GetAbsOrigin()
		self.vV = self:GetParent():GetForwardVector() * self.fSpeed
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
function modifier_kingkong_6_rush:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		if self.tTargets then
			for _, hUnit in pairs(self.tTargets) do
				if IsValid(hUnit) then
					FindClearSpaceForUnit(hUnit, hUnit:GetAbsOrigin(), true)
				end
			end
		end
	end
end
function modifier_kingkong_6_rush:UpdateHorizontalMotion(me, dt)
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
					attacker = me,
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
function modifier_kingkong_6_rush:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_kingkong_6_rush:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
function modifier_kingkong_6_rush:GetOverrideAnimation(params)
	return ACT_DOTA_RUN
end
function modifier_kingkong_6_rush:GetOverrideAnimationRate(params)
	return 2.5
end
function modifier_kingkong_6_rush:GetActivityTranslationModifiers(params)
	return "haste"
end
function modifier_kingkong_6_rush:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end