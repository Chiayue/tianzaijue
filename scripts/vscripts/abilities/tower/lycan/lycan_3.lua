LinkLuaModifier("modifier_lycan_3_transform", "abilities/tower/lycan/lycan_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_3_form", "abilities/tower/lycan/lycan_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_3_culling", "abilities/tower/lycan/lycan_3.lua", LUA_MODIFIER_MOTION_BOTH)
--Abilities
if lycan_3 == nil then
	lycan_3 = class({}, nil, ability_base_ai)
end
function lycan_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local transformation_time = self:GetSpecialValueFor("transformation_time")

	hCaster:RemoveModifierByName("modifier_lycan_3_transform")
	hCaster:AddNewModifier(hCaster, self, "modifier_lycan_3_transform", { duration = transformation_time })
	hCaster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
	self:GameTimer(transformation_time, function()
		if IsValid(hCaster) and hCaster:IsAlive() and GSManager:getStateType() == GS_Battle then
			hCaster:AddNewModifier(hCaster, self, "modifier_lycan_3_form", { duration = self:GetDuration() })
			local hAbility = hCaster:FindAbilityByName("lycan_2")
			for _, hUnit in ipairs(hAbility.tWolf) do
				hUnit:AddNewModifier(hCaster, self, "modifier_lycan_3_form", { duration = self:GetDuration() })
			end
		end
	end)
	hCaster:EmitSound("Hero_Lycan.Shapeshift.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_lycan_3_transform == nil then
	modifier_lycan_3_transform = class({}, nil, ModifierHidden)
end
function modifier_lycan_3_transform:OnCreated(params)
	if IsClient() then
		local hCaster = self:GetCaster()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_lycan_3_transform:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end
function modifier_lycan_3_transform:DeclareFunctions()
	return {
	-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end
function modifier_lycan_3_transform:GetOverrideAnimation(params)
	return ACT_DOTA_OVERRIDE_ABILITY_4
end
function modifier_lycan_3_transform:GetOverrideAnimationRate(params)
	return 1.5 / self:GetDuration()
end
---------------------------------------------------------------------
if modifier_lycan_3_form == nil then
	modifier_lycan_3_form = class({}, nil, eom_modifier)
end
function modifier_lycan_3_form:OnCreated(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.culling_distance = self:GetAbilitySpecialValueFor("culling_distance")
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		self:StartIntervalThink(0.1)
	else
		-- local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast_human_form.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/lycan/blood_moon/lycan_blood_moon_shapeshift_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_blade_center", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_blade_l", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_POINT_FOLLOW, "attach_blade_r", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 4, hParent, PATTACH_POINT_FOLLOW, "attach_l_eye", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 5, hParent, PATTACH_POINT_FOLLOW, "attach_r_eye", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_wolfbite_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_mane", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lycan_3_form:OnRefresh(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.culling_distance = self:GetAbilitySpecialValueFor("culling_distance")
end
function modifier_lycan_3_form:OnIntervalThink()
	local hParent = self:GetParent()
	if IsValid(hParent.hAttackTarget) and
	hParent:GetAttackTarget() == nil and
	CalculateDistance(hParent.hAttackTarget, hParent) < self.culling_distance and
	CalculateDistance(hParent.hAttackTarget, hParent) > math.min(hParent:Script_GetAttackRange() * 3, self.culling_distance - 100) and
	not hParent:HasModifier("modifier_passive_cast") and
	self:GetRemainingTime() > 0.2
	then
		local vPosisiton = hParent.hAttackTarget:GetAbsOrigin() + (CalculateDirection(hParent, hParent.hAttackTarget)) * hParent.hAttackTarget:GetHullRadius()
		hParent:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_POSITION, {
			vPosition = vPosisiton,
			flCastPoint = 0,
			iCastAnimation = ACT_DOTA_ATTACK,
			bIgnoreBackswing = true,
			bUseCooldown = false
		}, function(hAbility)
			if IsValid(self) and IsValid(hParent.hAttackTarget) and hParent.hAttackTarget:IsAlive() then
				hParent:AddNewModifier(hParent, hAbility, "modifier_lycan_3_culling", { duration = 0.3, vPosition = vPosisiton, iEntIndex = hParent.hAttackTarget:entindex() })
			end
		end)
	end
end
function modifier_lycan_3_form:OnDestroy()
	local hParent = self:GetParent()
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function modifier_lycan_3_form:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_lycan_3_form:GetModifierModelChange()
	return "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl"
end
function modifier_lycan_3_form:GetModifierMoveSpeed_Absolute()
	return self.movespeed
end
function modifier_lycan_3_form:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
		[EMDF_STATUS_HEALTH_BONUS] = self.bonus_health,
		[EMDF_ATTACKT_SPEED_BONUS] = self.attackspeed,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_lycan_3_form:GetAttackCritBonus()
	return self.crit_mult, self.crit_chance
end
function modifier_lycan_3_form:GetStatusHealthBonus()
	return self.bonus_health
end
function modifier_lycan_3_form:GetAttackSpeedBonus()
	return self.attackspeed
end
function modifier_lycan_3_form:OnBattleEnd()
	self:Destroy()
end
function modifier_lycan_3_form:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 3
	if 0 == self.iTooltip then
		return self.bonus_health
	end
	if 1 == self.iTooltip then
		return self.attackspeed
	end
	return self.crit_mult
end
---------------------------------------------------------------------
if modifier_lycan_3_culling == nil then
	modifier_lycan_3_culling = class({}, nil, BothModifier)
end
function modifier_lycan_3_culling:OnCreated(params)
	if IsServer() then
		self.vPosition = StringToVector(params.vPosition)
		self.hTarget = EntIndexToHScript(params.iEntIndex)
		local vForward = (self.vPosition - self:GetParent():GetAbsOrigin()):Normalized()
		self.jump_height = 200
		self.jump_horizontal_distance = (self.vPosition - self:GetParent():GetAbsOrigin()):Length2D()
		self.vS = self:GetParent():GetAbsOrigin()
		self.fSpeed = self.jump_horizontal_distance / self:GetDuration()
		self.vV = vForward * self.fSpeed

		local angle = VectorToAngles(vForward)
		self:GetParent():SetLocalAngles(0, angle[2], 0)

		local a = math.sqrt(self.jump_height)
		self.funcGetJmepHeight = function(x)
			x = (x / self.jump_horizontal_distance) * a * 2 - a
			return -(x ^ 2) + self.jump_height
		end
		if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
	end
end
function modifier_lycan_3_culling:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
	end
end
function modifier_lycan_3_culling:JumpFinish()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsValid(self.hTarget) then
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 200)
		hParent:Attack(self.hTarget, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/lycan/lycan_3_sweep.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_lycan_3_culling:UpdateHorizontalMotion(me, dt)
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
function modifier_lycan_3_culling:UpdateVerticalMotion(me, dt)
	if IsServer() then
		self:UpdateHorizontalMotion(me, dt)
	end
end
function modifier_lycan_3_culling:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_lycan_3_culling:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_lycan_3_culling:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end