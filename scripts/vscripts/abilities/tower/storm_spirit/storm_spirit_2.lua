LinkLuaModifier("modifier_storm_spirit_2_attack", "abilities/tower/storm_spirit/storm_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_storm_spirit_2_motion", "abilities/tower/storm_spirit/storm_spirit_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if storm_spirit_2 == nil then
	storm_spirit_2 = class({iOrderType = FIND_FARTHEST}, nil, ability_base_ai)
end
function storm_spirit_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vDirection = CalculateDirection(hTarget, hCaster)
	local vPosition = hTarget:GetAbsOrigin() + vDirection * (hCaster:GetHullRadius() + hTarget:GetHullRadius())
	hCaster:AddNewModifier(hCaster, self, "modifier_storm_spirit_2_motion", { vPosition = vPosition })
end
---------------------------------------------------------------------
--Modifiers
if modifier_storm_spirit_2_attack == nil then
	modifier_storm_spirit_2_attack = class({}, nil, eom_modifier)
end
function modifier_storm_spirit_2_attack:IsHidden()
	return true
end
function modifier_storm_spirit_2_attack:IsDebuff()
	return false
end
function modifier_storm_spirit_2_attack:IsPurgable()
	return false
end
function modifier_storm_spirit_2_attack:IsPurgeException()
	return false
end
function modifier_storm_spirit_2_attack:IsStunDebuff()
	return false
end
function modifier_storm_spirit_2_attack:AllowIllusionDuplicate()
	return false
end
function modifier_storm_spirit_2_attack:OnCreated(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
end
function modifier_storm_spirit_2_attack:OnRefresh(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
end
function modifier_storm_spirit_2_attack:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_storm_spirit_2_attack:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local hParent = self:GetParent()

	for _iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		if _iDamageType == DAMAGE_TYPE_MAGICAL then
			tDamageInfo.damage = tDamageInfo.damage * (1+self.damage_pct*0.01)
		end
	end
end
---------------------------------------------------------------------
if modifier_storm_spirit_2_motion == nil then
	modifier_storm_spirit_2_motion = class({})
end
function modifier_storm_spirit_2_motion:IsHidden()
	return true
end
function modifier_storm_spirit_2_motion:OnCreated(params)
	local hParent = self:GetParent()
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.vPosition = StringToVector(params.vPosition)
		if self.vPosition == nil then
			self:Destroy()
			return
		end

		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end

		self.vStart = hParent:GetAbsOrigin()
		local vDirection = self.vPosition - self.vStart
		vDirection.z = 0
		self.fDuration = vDirection:Length2D()/self.speed
		self.fTime = 0
		self.tTargets = {}
		hParent:EmitSound("Hero_StormSpirit.BallLightning")
		if vDirection:Length2D() > self.speed * 2/30 then
			hParent:EmitSound("Hero_StormSpirit.BallLightning.Loop")
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_storm_spirit_2_motion:OnDestroy(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveHorizontalMotionController(self)
		hParent:StopSound("Hero_StormSpirit.BallLightning.Loop")
	end
end
function modifier_storm_spirit_2_motion:UpdateHorizontalMotion(hParent, dt)
	if IsServer() then
		self.fTime = self.fTime + dt
		local hAbility = self:GetAbility()
		if not IsValid(hAbility) then
			self:Destroy()
			return
		end
		hParent:SetAbsOrigin(VectorLerp(self.fTime/self.fDuration, self.vStart, self.vPosition))

		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_storm_spirit_2_attack", nil)

		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_CLOSEST, false)
		for _, hTarget in pairs(tTargets) do
			if TableFindKey(self.tTargets, hTarget) == nil then
				hParent:Attack(hTarget, ATTACK_STATE_SKIPCOOLDOWN+ATTACK_STATE_IGNOREINVIS+ATTACK_STATE_NOT_USEPROJECTILE+ATTACK_STATE_NEVERMISS+ATTACK_STATE_NO_EXTENDATTACK+ATTACK_STATE_SKIPCOUNTING)
			end
		end
		self.tTargets = tTargets

		hParent:RemoveModifierByName("modifier_storm_spirit_2_attack")

		if self.fTime >= self.fDuration then
			self:Destroy()
			return
		end
	end
end
function modifier_storm_spirit_2_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_storm_spirit_2_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_storm_spirit_2_motion:GetOverrideAnimation(params)
	return ACT_DOTA_OVERRIDE_ABILITY_4
end
function modifier_storm_spirit_2_motion:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end