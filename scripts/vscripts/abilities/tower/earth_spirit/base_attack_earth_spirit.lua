LinkLuaModifier("modifier_base_attack_earth_spirit", "abilities/tower/earth_spirit/base_attack_earth_spirit.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

if base_attack_earth_spirit == nil then
	base_attack_earth_spirit = class({}, nil, base_attack)
end

function base_attack_earth_spirit:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()

	if IsValid(hTarget) then
		vLocation = hTarget:GetAbsOrigin()
		local fDamage = hCaster:GetAverageTrueAttackDamage(hTarget)
		local tDamageTable = {
			victim = hTarget,
			attacker = hCaster,
			damage = fDamage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}
		ApplyDamage(tDamageTable)

		if self.sAttackSound then
			hTarget:EmitSound(self.sAttackSound)
			-- EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "self.sAttackHitSound", hCaster)
		end
	else

	end
end
function base_attack_earth_spirit:OnAttack(hTarget)
	if not self.sAtkPtcl then
		local tKv = KeyValues.AbilitiesKv[self:GetAbilityName()]
		self.sAtkPtcl = tKv.precache.particle
		self.sAttackSound = tKv.AttackSound
		self.sAttackHitSound = tKv.AttackHitSound
	end

	local hCaster = self:GetCaster()

	local speed = self:GetSpecialValueFor("speed")
	if speed <= 0 then speed = hCaster:GetProjectileSpeed() end
	local distance = self:GetSpecialValueFor("distance")
	if distance <= 0 then distance = hCaster:Script_GetAttackRange() end
	local radius = self:GetSpecialValueFor("radius")

	local vDir = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()

	local hThinker = CreateUnitByName("npc_dota_dummy", hCaster:GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
	hThinker:SetForwardVector(vDir)
	hThinker:AddNewModifier(hCaster, self, "modifier_base_attack_earth_spirit", {
		fDirX = vDir.x,
		fDirY = vDir.y,
		speed = speed,
		distance = distance,
		radius = radius,
		duration = distance / speed,
	})

	local tInfo = {
		-- EffectName = self.sAtkPtcl,
		Ability = self,
		Source = hCaster,
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vVelocity = vDir * speed,
		fDistance = distance,
		fStartRadius = radius,
		fEndRadius = radius,
		iUnitTargetTeam = self:GetAbilityTargetTeam(),
		iUnitTargetType = self:GetAbilityTargetType(),
		ExtraData = {
		}
	}
	ProjectileManager:CreateLinearProjectile(tInfo)
	hCaster:EmitSound(self.sAttackSound)
end

---------------------------------------------------------------------
--Modifiers
if modifier_base_attack_earth_spirit == nil then
	modifier_base_attack_earth_spirit = class({})
end
function modifier_base_attack_earth_spirit:IsHidden()
	return true
end
function modifier_base_attack_earth_spirit:IsDebuff()
	return false
end
function modifier_base_attack_earth_spirit:IsPurgable()
	return false
end
function modifier_base_attack_earth_spirit:IsPurgeException()
	return false
end
function modifier_base_attack_earth_spirit:IsStunDebuff()
	return false
end
function modifier_base_attack_earth_spirit:AllowIllusionDuplicate()
	return false
end
function modifier_base_attack_earth_spirit:OnCreated(params)
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		self.fRadius = params.radius
		self.fSpeed = params.speed
		self.fDistance = params.distance
		self.vDirection = Vector(params.fDirX, params.fDirY, 0)
		self.vOrigin = self:GetParent():GetAbsOrigin()

		self.iParticle = ParticleManager:CreateParticle(self:GetAbility().sAtkPtcl, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(self.iParticle, false, false, -1, false, false)
	end
end
function modifier_base_attack_earth_spirit:UpdateHorizontalMotion(me, dt)
	local vPos = self:GetParent():GetAbsOrigin()
	local vPos = vPos + self.vDirection * self.fSpeed * dt
	self:GetParent():SetOrigin(vPos)
	self.fDistanceCur = (self.fDistanceCur or 0) + self.fSpeed * dt
	if self.fDistanceCur >= self.fDistance then
		self:Destroy()
	end
end
function modifier_base_attack_earth_spirit:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_base_attack_earth_spirit:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		if self.iParticle then
			ParticleManager:SetParticleControl(self.iParticle, 3, self:GetParent():GetAbsOrigin())
		end
		UTIL_Remove(self:GetParent())
	end
end
function modifier_base_attack_earth_spirit:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end