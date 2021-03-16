LinkLuaModifier("modifier_snapfire_2_short_hop", "abilities/tower/snapfire/snapfire_2.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_snapfire_2_crit", "abilities/tower/snapfire/snapfire_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if snapfire_2 == nil then
	snapfire_2 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET }, nil, ability_base_ai)
end
function snapfire_2:GetAOERadius()
	return self:GetSpecialValueFor("impact_radius")
end
function snapfire_2:GetCastPoint()
	if IsServer() and self:GetCursorTarget() == self:GetCaster() then
		return self:GetSpecialValueFor('self_cast_delay')
	end
	return self.BaseClass.GetCastPoint(self)
end
function snapfire_2:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_snapfire/hero_snapfire_cookie_selfcast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hand_r_fx", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 2, hCaster, PATTACH_POINT_FOLLOW, "attach_mouth", hCaster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	return true
end
function snapfire_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	hCaster:RemoveGesture(self.BaseClass.GetCastAnimation(self))
	hCaster:EmitSound('Hero_Snapfire.FeedCookie.Consume')
	local flAmount = hCaster:GetVal(ATTRIBUTE_KIND.StatusHealth) * self:GetSpecialValueFor("health_instant") * 0.01

	local jump_duration = self:GetSpecialValueFor('jump_duration')
	hCaster:AddNewModifier(hCaster, self, "modifier_snapfire_2_short_hop", { duration = jump_duration, distance = (vPosition - hCaster:GetAbsOrigin()):Length2D() })
	hCaster:Heal(flAmount, self)
end
---------------------------------------------------------------------
--Modifiers
if modifier_snapfire_2_short_hop == nil then
	modifier_snapfire_2_short_hop = class({})
end
function modifier_snapfire_2_short_hop:IsHidden()
	return true
end
function modifier_snapfire_2_short_hop:GetEffectName()
	return 'particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf'
end
function modifier_snapfire_2_short_hop:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_snapfire_2_short_hop:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end
function modifier_snapfire_2_short_hop:OnCreated(params)
	if IsServer() then
		self.pre_land_anim_time = self:GetAbilitySpecialValueFor('pre_land_anim_time')
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
		self.impact_damage = self:GetAbility():GetAbilityDamage()
		self.impact_stun_duration = self:GetAbilitySpecialValueFor('impact_stun_duration')
		self.type_target = self:GetAbility():GetAbilityTargetType()
		self.flags_target = self:GetAbility():GetAbilityTargetFlags()
	end
end
function modifier_snapfire_2_short_hop:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
		-- 添加必定暴击buff
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_snapfire_2_crit", { duration = self:GetAbility():GetDuration() })
	end
end
function modifier_snapfire_2_short_hop:JumpFinish()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf', PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(iPtclID, 1, Vector(self.impact_radius, self.impact_radius, self.impact_radius))
	ParticleManager:ReleaseParticleIndex(iPtclID)
	hCaster:EmitSound('Hero_Snapfire.FeedCookie.Impact')

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.impact_radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, self.type_target, self.flags_target, 0, false)
	for _, hTarget in pairs(tTargets) do
		local damage_table =		{
			ability = self:GetAbility(),
			attacker = hCaster,
			victim = hTarget,
			damage = self.impact_damage,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage(damage_table)
		hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, self.impact_stun_duration)
	end
end
function modifier_snapfire_2_short_hop:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vPos = self.vV * dt + self:GetParent():GetAbsOrigin()
		local fDis = (vPos - self.vS):Length2D()
		if fDis > self.jump_horizontal_distance then
			fDis = self.jump_horizontal_distance
		end
		vPos.z = self.vS.z + self.funcGetJmepHeight(fDis)
		me:SetAbsOrigin(vPos)

		--准备着陆动作
		if self:GetRemainingTime() <= 0.25 and not self._bEndAnmt then
			self._bEndAnmt = true
			-- self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END, 1 + self.pre_land_anim_time)
			self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END, 1.75)
		end
		if fDis == self.jump_horizontal_distance then
			--成功着陆
			self:JumpFinish()
			self:Destroy()
		end
	end
end
function modifier_snapfire_2_short_hop:UpdateVerticalMotion(me, dt)
	if IsServer() then
		self:UpdateHorizontalMotion(me, dt)
	end
end
function modifier_snapfire_2_short_hop:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_snapfire_2_short_hop:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_snapfire_2_short_hop:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_snapfire_2_short_hop:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -100,
	}
end
function modifier_snapfire_2_short_hop:GetOverrideAnimation(params)
	if self:GetParent() ~= self:GetCaster() then
		return ACT_DOTA_FLAIL
	end
end
function modifier_snapfire_2_short_hop:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
---------------------------------------------------------------------
if modifier_snapfire_2_crit == nil then
	modifier_snapfire_2_crit = class({}, nil, eom_modifier)
end
function modifier_snapfire_2_crit:OnCreated(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_count = self:GetAbilitySpecialValueFor("crit_count")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
		self:SetStackCount(self.crit_count)
	end
end
function modifier_snapfire_2_crit:OnRefresh(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_count = self:GetAbilitySpecialValueFor("crit_count")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
		self:SetStackCount(self.crit_count)
	end
end
function modifier_snapfire_2_crit:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_snapfire_2_crit:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
	-- [MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_snapfire_2_crit:GetAttackCritBonus(params)
	return self.crit_mult, self.crit_chance
end
function modifier_snapfire_2_crit:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		self:SetStackCount(self:GetStackCount() - 1)
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end
function modifier_snapfire_2_crit:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_snapfire_2_crit:OnTooltip()
	return self.crit_mult
end