if modifier_death_knockback == nil then
	modifier_death_knockback = class({})
end

local public = modifier_death_knockback

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:OnCreated(params)
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function public:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveHorizontalMotionController(self)
		hParent:RemoveVerticalMotionController(self)
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function public:UpdateHorizontalMotion(hParent, dt)
	if IsServer() then
		local fTime = math.min(GameRules:GetGameTime() - self.fStartTime, self.fDuration)
		hParent:SetAbsOrigin(self.vStartPosition + self.vStartVelocity * fTime + fTime * fTime * self.vAcceleration / 2)
	end
end
function public:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function public:OnDeath(params)
	local hParent = self:GetParent()
	if params.unit ~= hParent then return end
	if not IsValid(params.attacker) or params.attacker == hParent then return end

	local tAtkInfo = GetAttackInfoByDamageRecord(params.record, params.attacker)
	if not IsAttackCrit(tAtkInfo) then return end

	if self:ApplyHorizontalMotionController() then
		local vDirection = hParent:GetAbsOrigin() - params.attacker:GetAbsOrigin()
		vDirection.z = 0

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(iParticleID, 1, -vDirection:Normalized())
		ParticleManager:ReleaseParticleIndex(iParticleID)

		self.fDuration = 0.2
		self.fDistance = 500
		self.vStartPosition = hParent:GetAbsOrigin()
		local fAcceleration = 3000 / self.fDuration
		self.fStartTime = GameRules:GetGameTime()
		self.vAcceleration = vDirection:Normalized() * -fAcceleration
		self.vStartVelocity = vDirection:Normalized() * self.fDistance / self.fDuration - self.vAcceleration * self.fDuration / 2

		self:SetDuration(self.fDuration, true)
	else
		self:Destroy()
	end
end