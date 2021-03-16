LinkLuaModifier("modifier_nian_4_hop", "abilities/boss/nian_4.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_nian_4_debuff", "abilities/boss/nian_4.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if nian_4 == nil then
	nian_4 = class({})
end
function nian_4:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	hCaster:StartGesture(ACT_DOTA_LEAP_STUN)
	return true
end
function nian_4:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_LEAP_STUN)
end
function nian_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor('jump_duration')
	hCaster:AddNewModifier(hCaster, self, "modifier_nian_4_hop", { duration = duration, distance = (vPosition - hCaster:GetAbsOrigin()):Length2D() })

end
---------------------------------------------------------------------
--Modifiers
if modifier_nian_4_hop == nil then
	modifier_nian_4_hop = class({})
end
function modifier_nian_4_hop:IsHidden()
	return true
end
function modifier_nian_4_hop:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end
function modifier_nian_4_hop:OnCreated(params)
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
function modifier_nian_4_hop:OnDestroy(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveHorizontalMotionController(self)
		hParent:RemoveVerticalMotionController(self)
		-- 连续接技能
		local hAbility = self:GetAbility().hComboAbility
		if hAbility then
			if hAbility:GetAbilityName() == "nian_2" then
				hParent:Stop()
				local vPosition = GetLinearMostTargetsPosition(hParent:GetAbsOrigin(), 3000, hParent:GetTeamNumber(), 500, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER)
				if vPosition ~= vec3_invalid then
					ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, hAbility, vPosition)
				end
			end
			if hAbility:GetAbilityName() == "nian_6" then
				hParent:Stop()
				local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 6000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				if IsValid(tTargets[1]) then
					ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, hAbility, tTargets[1]:GetAbsOrigin())
				end
			end
			if hAbility:GetAbilityName() == "nian_8" then
				hParent:Stop()
				local vPosition = GetLinearMostTargetsPosition(hParent:GetAbsOrigin(), 3000, hParent:GetTeamNumber(), 500, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER)
				-- local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 6000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				if vPosition ~= vec3_invalid then
					ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, hAbility, vPosition)
				end
			end
		end
		self:GetAbility().hComboAbility = nil
	end
end
function modifier_nian_4_hop:JumpFinish()
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
		hTarget:AddNewModifier(hCaster, self:GetAbility(), "modifier_nian_4_debuff", { duration = self.impact_stun_duration })
		hCaster:KnockBack(vCenter, hTarget, math.max(self.impact_radius - (hTarget:GetAbsOrigin() - vCenter):Length2D(), 50), 0, 0.4, true, 0.4, true)
	end
end
function modifier_nian_4_hop:UpdateHorizontalMotion(me, dt)
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
function modifier_nian_4_hop:UpdateVerticalMotion(me, dt)
	if IsServer() then
		self:UpdateHorizontalMotion(me, dt)
	end
end
function modifier_nian_4_hop:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_nian_4_hop:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_nian_4_hop:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
---------------------------------------------------------------------
if modifier_nian_4_debuff == nil then
	modifier_nian_4_debuff = class({}, nil, eom_modifier)
end
function modifier_nian_4_debuff:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE = -self:GetAbilitySpecialValueFor("attackspeed_reduce_pct"),
		EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE = -self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
	}
end