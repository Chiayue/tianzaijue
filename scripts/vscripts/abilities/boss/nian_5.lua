LinkLuaModifier("modifier_nian_5_hop", "abilities/boss/nian_5.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_nian_5_catch", "abilities/boss/nian_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nian_5_tear", "abilities/boss/nian_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nian_5_follow", "abilities/boss/nian_5.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_nian_5_debuff", "abilities/boss/nian_5.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if nian_5 == nil then
	nian_5 = class({})
end
function nian_5:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	hCaster:StartGesture(ACT_DOTA_LEAP_SWIPE)
	return true
end
function nian_5:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_LEAP_SWIPE)
end
function nian_5:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor('jump_duration')
	hCaster:AddNewModifier(hCaster, self, "modifier_nian_5_hop", { duration = duration, distance = (vPosition - hCaster:GetAbsOrigin()):Length2D() })

end
---------------------------------------------------------------------
--Modifiers
if modifier_nian_5_hop == nil then
	modifier_nian_5_hop = class({})
end
function modifier_nian_5_hop:IsHidden()
	return true
end
function modifier_nian_5_hop:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end
function modifier_nian_5_hop:OnCreated(params)
	if IsServer() then
		self.jump_height = self:GetAbilitySpecialValueFor('jump_height')
		self.jump_horizontal_distance = params.distance
		self.vS = self:GetParent():GetAbsOrigin()
		self.fSpeed = self.jump_horizontal_distance / self:GetDuration()
		self.vV = self:GetParent():GetForwardVector() * self.fSpeed
		local a = math.sqrt(self.jump_height)
		self.funcGetJmepHeight = function(x)
			x = (x / self.jump_horizontal_distance) * a * 2 - a
			return -(x ^ 2) + self.jump_height
		end
		if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end

		self.impact_radius = self:GetAbilitySpecialValueFor('impact_radius')
		self.impact_damage = self:GetAbilitySpecialValueFor("impact_damage") * self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01
		self.impact_stun_duration = self:GetAbilitySpecialValueFor('impact_stun_duration')
		self.type_target = self:GetAbility():GetAbilityTargetType()
		self.flags_target = self:GetAbility():GetAbilityTargetFlags()
	end
end
function modifier_nian_5_hop:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)

		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_nian_5_catch", { duration = 1.95 })
	end
end
function modifier_nian_5_hop:JumpFinish()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf', PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(iPtclID, 1, Vector(self.impact_radius, self.impact_radius, self.impact_radius))
	ParticleManager:ReleaseParticleIndex(iPtclID)
	hCaster:EmitSound('Hero_Brewmaster.ThunderClap')

	local iHullRadius = hCaster:GetHullRadius()
	local vCenter = hCaster:GetAbsOrigin()

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), self.impact_radius, self:GetAbility())
	for _, hTarget in pairs(tTargets) do
		hCaster:DealDamage(hTarget, self:GetAbility(), self.impact_damage)
		-- hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, self.impact_stun_duration)
		hTarget:AddNewModifier(hCaster, self:GetAbility(), "modifier_nian_5_debuff", { duration = self.impact_stun_duration })
		hCaster:KnockBack(vCenter, hTarget, math.max(self.impact_radius - (hTarget:GetAbsOrigin() - vCenter):Length2D(), 50), 0, 0.4, true, 0.4, true)
	end
end
function modifier_nian_5_hop:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vPos = self.vV * dt + self:GetParent():GetAbsOrigin()
		local fDis = (vPos - self.vS):Length2D()
		if fDis > self.jump_horizontal_distance then
			fDis = self.jump_horizontal_distance
		end
		vPos.z = self.vS.z + self.funcGetJmepHeight(fDis)
		me:SetAbsOrigin(vPos)

		if fDis == self.jump_horizontal_distance then
			--成功着陆
			self:JumpFinish()
			self:Destroy()
		end
	end
end
function modifier_nian_5_hop:UpdateVerticalMotion(me, dt)
	if IsServer() then
		self:UpdateHorizontalMotion(me, dt)
	end
end
function modifier_nian_5_hop:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_nian_5_hop:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_nian_5_hop:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end
---------------------------------------------------------------------
if modifier_nian_5_catch == nil then
	modifier_nian_5_catch = class({})
end
function modifier_nian_5_catch:IsHidden()
	return true
end
function modifier_nian_5_catch:OnCreated(params)
	if IsServer() then
		self.flTime = 0
		self.hTarget = nil
		self:StartIntervalThink(0)
	end
end
function modifier_nian_5_catch:OnDestroy()
	if IsServer() then
		if self.hTarget and self.hTarget:IsAlive() then
			local hParent = self:GetParent()
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_nian_5_tear", { duration = 3.93, iEntIndex = self.hTarget:entindex() })
		end
	end
end
function modifier_nian_5_catch:OnIntervalThink()
	local hParent = self:GetParent()
	self.flTime = self.flTime + FrameTime()
	if self.flTime > 1.32 and self.flTime < 1.41 then
		if self.iParticleID == nil then
			self.iParticleID = ParticleManager:CreateParticle("particles/units/boss/nian/nian_5_swip_a.vpcf", PATTACH_ABSORIGIN, hParent)
			self:AddParticle(self.iParticleID, false, false, -1, false, false)
		end
		-- DebugDrawCircle(hParent:GetAttachmentOrigin(hParent:ScriptLookupAttachment("attach_attack1")), Vector(0, 255, 0), 255, 50, false, 1)
		if self.hTarget == nil then
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAttachmentOrigin(hParent:ScriptLookupAttachment("attach_attack1")), 500, self:GetAbility())
			if IsValid(tTargets[1]) then
				self.hTarget = tTargets[1]
				self.hTarget:Purge(true, false, false, true, true)
				self.hTarget:InterruptMotionControllers(false)
				self.hTarget:Stop()
				self.hTarget:AddNewModifier(hParent, self:GetAbility(), "modifier_nian_5_follow", nil)
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_nian_5_tear == nil then
	modifier_nian_5_tear = class({})
end
function modifier_nian_5_tear:IsHidden()
	return true
end
function modifier_nian_5_tear:OnCreated(params)
	if IsServer() then
		self.hTarget = EntIndexToHScript(params.iEntIndex)

		local hParent = self:GetParent()
		local hAbility = hParent:AddAbility("nian_5_1")
		hAbility:SetLevel(1)
		hParent:Stop()
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, hAbility)
	end
end
function modifier_nian_5_tear:OnDestroy()
	if IsServer() then
		self.hTarget:RemoveModifierByName("modifier_nian_5_follow")
	end
end
function modifier_nian_5_tear:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end
---------------------------------------------------------------------
if modifier_nian_5_follow == nil then
	modifier_nian_5_follow = class({})
end
function modifier_nian_5_follow:IsHidden()
	return true
end
function modifier_nian_5_follow:OnCreated(params)
	self.damage_interval = self:GetAbilitySpecialValueFor("damage_interval")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	self.flDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.damage_factor * 0.01
	if IsServer() then
		self:StartIntervalThink(self.damage_interval)
		if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then
			-- self:Destroy()
			return
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/nian/nian_5_tear.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_nian_5_follow:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
	end
end
function modifier_nian_5_follow:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	hCaster:DealDamage(hParent, self:GetAbility(), self.flDamage)
	if not hParent:IsAlive() then
		hCaster:Stop()
	end
end
function modifier_nian_5_follow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_nian_5_follow:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end
function modifier_nian_5_follow:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_nian_5_follow:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local hCaster = self:GetCaster()
		me:SetAbsOrigin(hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_attack1")) + Vector(0, 0, -240))
	end
end
function modifier_nian_5_follow:UpdateVerticalMotion(me, dt)
	if IsServer() then
		local hCaster = self:GetCaster()
		me:SetAbsOrigin(hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_attack1")) + Vector(0, 0, -240))
	end
end
function modifier_nian_5_follow:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_nian_5_follow:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
---------------------------------------------------------------------
if modifier_nian_5_debuff == nil then
	modifier_nian_5_debuff = class({}, nil, eom_modifier)
end
function modifier_nian_5_debuff:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE = -self:GetAbilitySpecialValueFor("attackspeed_reduce_pct"),
		EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE = -self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
	}
end