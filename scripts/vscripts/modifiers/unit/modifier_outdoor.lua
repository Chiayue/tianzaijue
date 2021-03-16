if modifier_outdoor == nil then
	modifier_outdoor = class({})
end

local public = modifier_outdoor

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
function public:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.fRadiusOrigin = hCaster:GetModelRadius()
	if IsServer() then
		-- hCaster:AddNoDraw()
		self.fScaleOrigin = hCaster:GetModelScale()
		self.fScale = 0.25
		self.fScaleVelocity = (self.fScaleOrigin + 0.25 - self.fScale) / self:GetDuration()
		hCaster:SetModelScale(self.fScale)
		hCaster:SetAbsOrigin(hParent:GetAbsOrigin())
		self:StartIntervalThink(0)
	else
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_ion_shell.vpcf", PATTACH_CENTER_FOLLOW, hParent)
		ParticleManager:SetParticleControl(self.iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
		self.fRadius = 0
		self.fRadiusVelocity = self.fRadiusOrigin / self:GetDuration()
		self:StartIntervalThink(0.1)
	end
end
function public:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		if IsValid(self:GetCaster()) then
			-- self:GetCaster():RemoveNoDraw()
			self:GetCaster():SetModelScale(self.fScaleOrigin)
			local iPtclID = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(iPtclID, 0, self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 0)
			ParticleManager:ReleaseParticleIndex(iPtclID)
			self:GetCaster():StartGesture(ACT_DOTA_SPAWN)
		end
		hParent:RemoveSelf()
	else
	end
end
function public:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if IsServer() then
		self.fScale = self.fScale + self.fScaleVelocity * FrameTime()
		if IsValid(hCaster) then
			hCaster:SetModelScale(self.fScale)
			hCaster:SetAbsOrigin(hParent:GetAbsOrigin())
		end
	else
		self.fRadius = self.fRadius + self.fRadiusVelocity * 0.1
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.fRadius, self.fRadius, self.fRadius))
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end