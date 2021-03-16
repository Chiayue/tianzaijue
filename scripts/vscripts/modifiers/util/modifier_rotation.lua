-- age_x		--旋转角度	默认0
-- age_y		--旋转角度	默认0
-- age_z		--旋转角度	默认0
-- origin_x		--旋转中心	默认0
-- origin_y		--旋转中心	默认0
-- origin_z		--旋转中心	默认0
-- pos_mode		--作用坐标域	0=世界坐标（默认） 1=局部坐标
--
if modifier_rotation == nil then
	modifier_rotation = class({})
end

local public = modifier_rotation

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
	return true
end
function public:DestroyOnExpire()
	return true
end
function public:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function public:OnCreated(params)
	if IsServer() then
		local hParent = self:GetCaster() or self:GetParent()

		self.age_x = params.age_x or 0
		self.age_y = params.age_y or 0
		self.age_z = params.age_z or 0
		self.fAgeXCur = 0
		self.fAgeYCur = 0
		self.fAgeZCur = 0
		self.vOrigin = Vector(params.origin_x or 0, params.origin_y or 0, params.origin_z or 0)

		if 1 == params.pos_mode then
			self.vPos = hParent:GetLocalOrigin()
			function self:SetPos(hUnit, vPos)
				return hUnit:SetLocalOrigin(vPos + hUnit:GetLocalOrigin())
			end
		else
			self.vPos = hParent:GetAbsOrigin()
			function self:SetPos(hUnit, vPos)
				return hUnit:SetAbsOrigin(vPos + hUnit:GetAbsOrigin())
			end
		end
		self.vPosCur = self.vPos

		self:StartIntervalThink(0)
	end
end
function public:OnRefresh(params)
	if IsServer() then
		local hParent = self:GetCaster() or self:GetParent()
		self.age_x = (params.age_x or 0) + self.age_x - self.fAgeXCur
		self.age_y = (params.age_y or 0) + self.age_y - self.fAgeYCur
		self.age_z = (params.age_z or 0) + self.age_z - self.fAgeZCur

		if 1 == params.pos_mode then
			self.vPos = hParent:GetLocalOrigin()
		else
			self.vPos = hParent:GetAbsOrigin()
		end
		self.vPosCur = self.vPos
	end
end
function public:OnDestroy()
	if IsServer() then
		local hParent = self:GetCaster() or self:GetParent()
		local qaAeg = QAngle(self.age_x, self.age_y, self.age_z)
		local vPos = RotatePosition(self.vOrigin, qaAeg, self.vPos)
		self:SetPos(hParent, vPos - self.vPosCur)
	end
end
function public:OnIntervalThink()
	if IsServer() then
		local me = self:GetCaster() or self:GetParent()
		local f = math.min(1, 1 - (self:GetRemainingTime() / self:GetDuration()))
		self.fAgeXCur = self.age_x * f
		self.fAgeYCur = self.age_y * f
		self.fAgeZCur = self.age_z * f
		local qaAeg = QAngle(self.fAgeXCur, self.fAgeYCur, self.fAgeZCur)
		local vPos = RotatePosition(self.vOrigin, qaAeg, self.vPos)
		self:SetPos(me, vPos - self.vPosCur)
		self.vPosCur = vPos
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end