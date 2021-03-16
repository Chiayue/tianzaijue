-- params.change	--震动幅度
-- params.rate		--频率：单位时间内震动次数
--
if modifier_pudding == nil then
	modifier_pudding = class({}, nil, eom_modifier)
end

local public = modifier_pudding

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
	local hParent = self:GetCaster() or self:GetParent()
	if IsServer() then
		local iCount = params.rate * self:GetDuration()
		self.fTime = self:GetDuration() / iCount
		self.fScaleOrigin = hParent:GetModelScale()
		self.fScaleVelocity = params.change / iCount
		self.fScale = params.change + self.fScaleVelocity
		self:StartIntervalThink(0)
	end
end
function public:OnDestroy()
	local hParent = self:GetCaster() or self:GetParent()
	if IsServer() then
		-- hParent:SetModelScale(self.fScaleOrigin)
		hParent:SetValPercent(ATTRIBUTE_KIND.ModelScale, 0, self)
	end
end
function public:OnIntervalThink()
	local hParent = self:GetCaster() or self:GetParent()
	if not self.fEndTime or self.fEndTime <= GameRules:GetGameTime() then
		self:_onve()
	end
	self.fTimeCur = GameRules:GetGameTime()
	self.fSmoothValue = RemapValClamped(self.fTimeCur, self.fStartTime, self.fEndTime, self.fStartVal, self.fEndVal)
	-- hParent:SetModelScale(self.fSmoothValue)

	hParent:SetValPercent(ATTRIBUTE_KIND.ModelScale, (self.fSmoothValue - self.fScaleOrigin) / self.fScaleOrigin * 100, self)
end
function public:_onve()
	self.fScale = self.fScale - self.fScaleVelocity
	self.iSign = (self.iSign or -1) * -1
	self.fStartTime = GameRules:GetGameTime()
	self.fEndTime = self.fTime + self.fStartTime
	self.fStartVal = self.fScaleOrigin + self.fScale * self.iSign
	self.fEndVal = self.fScaleOrigin - self.fScale * self.iSign
end