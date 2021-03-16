if modifier_float == nil then
	modifier_float = class({})
end

local public = modifier_float

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
-- params.rate				--速率
-- params.rotate_dir		--旋转方向	1=顺时针（默认） -1=逆时针
-- params.pos_mode			--作用坐标域	0=世界坐标（默认） 1=局部坐标
function public:OnCreated(params)
	self:OnRefresh(params)
end
function public:OnRefresh(params)
	local hParent = self:GetCaster() or self:GetParent()
	if IsServer() then
		params.rate = params.rate or 1
		params.rotate_dir = (params.rotate_dir or 1) * -1
		self.rate = params.rate

		self.fMax = 30
		self.fSpeed = self.fMax * self.rate

		self.vForward = hParent:GetForwardVector()
		self.fAge = 0
		self.fSpeedAge = 90 * self.rate * params.rotate_dir

		if 1 == params.pos_mode then
			function self:SetPos(hUnit, vPos)
				return hUnit:SetLocalOrigin(vPos + hParent:GetLocalOrigin())
			end
		else
			function self:SetPos(hUnit, vPos)
				return hUnit:SetAbsOrigin(vPos + hParent:GetAbsOrigin())
			end
		end

		self:StartIntervalThink(0)
	end
end
function public:OnDestroy()
	local hParent = self:GetCaster() or self:GetParent()
	if IsServer() then
	end
end
function public:OnIntervalThink()
	local hParent = self:GetCaster() or self:GetParent()

	local mt = FrameTime()
	local vForward = RotatePosition(Vector(0, 0, 0), QAngle(math.sin(math.rad(self.fAge * 5)) * 5, self.fAge, 0), self.vForward)
	vForward = vForward:Normalized()
	hParent:SetForwardVector(vForward)
	self.fAge = (self.fAge + self.fSpeedAge * mt) % 360

	local fDis = self.fMax - (self.fMax_Cur or 0)
	local fSpeed = 30 * math.sin(math.rad(self.fAge * 5))
	self:SetPos(hParent, Vector(0, 0, fSpeed) * mt)
	self.fMax_Cur = (self.fMax_Cur or 0) + math.abs(fSpeed) * mt
	if self.fMax_Cur >= self.fMax then
		self.fMax_Cur = 0
		self.fSpeed = self.fSpeed / math.abs(self.fSpeed) * self.fMax * self.rate * -1
	end
end