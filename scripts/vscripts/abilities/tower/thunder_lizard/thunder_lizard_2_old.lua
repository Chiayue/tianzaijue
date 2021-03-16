LinkLuaModifier("modifier_thunder_lizard_2", "abilities/tower/thunder_lizard/thunder_lizard_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_thunder_lizard_2_motion", "abilities/tower/thunder_lizard/thunder_lizard_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_thunder_lizard_2_impact", "abilities/tower/thunder_lizard/thunder_lizard_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_thunder_lizard_2_slow", "abilities/tower/thunder_lizard/thunder_lizard_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if thunder_lizard_2 == nil then
	thunder_lizard_2 = class({})
end
function thunder_lizard_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vTarget = self:GetCursorPosition()

	hCaster:EmitSound("Hero_Magnataur.Skewer.Cast")
	local range = self:GetSpecialValueFor("range")

	local fDis = math.min(range, (hCaster:GetAbsOrigin() - vTarget):Length2D())
	local vDir = (vTarget - hCaster:GetAbsOrigin()):Normalized()
	if vDir then
		vTarget = vDir * fDis + hCaster:GetAbsOrigin()
	end

	hCaster:AddNewModifier(hCaster, self, "modifier_thunder_lizard_2_motion", {
		x = vTarget.x,
		y = vTarget.y,
		z = vTarget.z,
	})
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
			hParent:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_POSITION, { vPosition = vPosition })
		end
	end
end
---------------------------------------------------------------------
if modifier_thunder_lizard_2_motion == nil then
	modifier_thunder_lizard_2_motion = class({}, nil, HorizontalModifier)
end
function modifier_thunder_lizard_2_motion:OnCreated(params)
	self.skewer_speed = self:GetAbilitySpecialValueFor("skewer_speed")
	self.skewer_radius = self:GetAbilitySpecialValueFor("skewer_radius")
	if IsServer() then
		self.vDirection = self:GetParent():GetForwardVector()
		self.vVelocity = self.vDirection * self.skewer_speed
		self.tTargets = {}

		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end

		self.vS = Vector(params.x, params.y, params.z)
		local iDis = (self:GetParent():GetAbsOrigin() - self.vS):Length2D()
		self:SetDuration(iDis / self.skewer_speed, false)

		local iPtclID = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iPtclID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iPtclID, false, false, -1, false, false)
	end
end
function modifier_thunder_lizard_2_motion:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
	end
end
function modifier_thunder_lizard_2_motion:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		self.vDirection = me:GetForwardVector()
		self.vVelocity = self.vDirection * self.skewer_speed
		local vPos = me:GetAbsOrigin() + self.vVelocity * dt
		if GridNav:CanFindPath(me:GetAbsOrigin(), vPos) then
			me:SetAbsOrigin(vPos)
		else
			self:Destroy()
		end

		--检测撞击
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.skewer_radius, self:GetAbility())
		for _, hTarget in pairs(tTargets) do
			if not TableFindKey(self.tTargets, hTarget) then
				hTarget:AddNewModifier(hParent, self:GetAbility(), "modifier_thunder_lizard_2_impact", { duration = self:GetRemainingTime() })
				hTarget:EmitSound("Hero_Magnataur.Skewer.Target")
				table.insert(self.tTargets, hTarget)
			end
		end
	end
end
function modifier_thunder_lizard_2_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_thunder_lizard_2_motion:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end
function modifier_thunder_lizard_2_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
end
function modifier_thunder_lizard_2_motion:GetOverrideAnimation(params)
	return ACT_DOTA_RUN
end
function modifier_thunder_lizard_2_motion:GetModifierTurnRate_Percentage(params)
	return 100
end
function modifier_thunder_lizard_2_motion:OnOrder(params)
	if params.unit == self:GetParent() then
		if DOTA_UNIT_ORDER_MOVE_TO_POSITION == params.order_type
		or DOTA_UNIT_ORDER_ATTACK_MOVE == params.order_type then
			self:GetParent():FaceTowards(params.new_pos + self.vVelocity * 1000)
		elseif DOTA_UNIT_ORDER_ATTACK_TARGET == params.order_type
		or DOTA_UNIT_ORDER_MOVE_TO_TARGET == params.order_type then
			if IsValid(params.target) then
				self:GetParent():FaceTowards(params.target:GetAbsOrigin() + self.vVelocity * 1000)
			end
		elseif DOTA_UNIT_ORDER_STOP == params.order_type
		or DOTA_UNIT_ORDER_HOLD_POSITION == params.order_type
		then
			-- self:Destroy()
		end
	end
end
---------------------------------------------------------------------
if modifier_thunder_lizard_2_impact == nil then
	modifier_thunder_lizard_2_impact = class({}, nil, HorizontalModifier)
end
function modifier_thunder_lizard_2_impact:OnCreated(params)
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
	end
end
function modifier_thunder_lizard_2_impact:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_thunder_lizard_2_slow", { duration = self.slow_duration * self:GetParent():GetStatusResistanceFactor(self:GetCaster()) })
		-- 伤害
		self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), 0)
	end
end
function modifier_thunder_lizard_2_impact:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local hCaster = self:GetCaster()
		if not IsValid(hCaster) then
			self:Destroy()
			return
		end
		local vPosition = hCaster:GetAbsOrigin() + hCaster:GetForwardVector() * 150
		if GridNav:CanFindPath(me:GetAbsOrigin(), vPosition) then
			me:SetAbsOrigin(vPosition)
		end
	end
end
function modifier_thunder_lizard_2_impact:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_thunder_lizard_2_impact:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_thunder_lizard_2_impact:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_thunder_lizard_2_impact:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
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