--必填：一个目标点或速度
-- position_x	目标点
-- position_y	目标点
-- position_z	目标点
-- velocity_x	速度
-- velocity_y	速度
-- velocity_z	速度
--
--其他选填
-- acceleration		加速度
-- acceleration_x	x方向加速度
-- acceleration_y	y方向加速度
-- acceleration_z	z方向加速度
--
if modifier_motion == nil then
	modifier_motion = class({})
end

local public = modifier_motion

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
		if not self:ApplyVerticalMotionController() or not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end

		--加速度
		self.vAcceleration = Vector(
		params.acceleration_x or params.acceleration or 0,
		params.acceleration_y or params.acceleration or 0,
		params.acceleration_z or params.acceleration or 0)

		--基础速度
		if nil ~= params.position_x or nil ~= params.position_y or nil ~= params.position_z then
			--以目标点 计算运动
			local vPos = Vector(params.position_x or 0, params.position_y or 0, params.position_z or 0)
			self.vPos = vPos

			local vDis = vPos - self:GetParent():GetAbsOrigin()
			self.vDir = vDis:Normalized()
			self.vAcceleration = self.vAcceleration * self.vDir
			local vDisAcc = self.vAcceleration * (self:GetDuration() ^ 2) * 0.5
			if vDisAcc:Length() >= vDis:Length() then
				--修正加速度
				self.vVelocity = Vector(0, 0, 0)
				self.vAcceleration = 2 * vDis / (self:GetDuration() ^ 2)
			else
				vDis = vDis - vDisAcc
				self.vVelocity = vDis / self:GetDuration()
			end
			self.vDis = vDis
		else
			self.vVelocity = Vector(params.velocity_x or 0, params.velocity_y or 0, params.velocity_z or 0)
			self.vDir = self.vVelocity:Normalized()
			self.vAcceleration = self.vAcceleration * self.vDir
		end
	end
end

function public:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController(self)
		self:GetParent():RemoveHorizontalMotionController(self)
		if self.vPos then
			self:GetParent():SetAbsOrigin(self.vPos)
		end
	end
end
function public:UpdateVerticalMotion(me, dt)
	if IsServer() then
		me:SetAbsOrigin(me:GetAbsOrigin() + self.vVelocity * dt)
		self.vVelocity = self.vVelocity + Vector(0, 0, self.vAcceleration.z) * dt

		if self.vDis then
			self.vDis = self.vDis - self.vVelocity
			if 0 >= self.vDis:Length() then
				self:Destroy()
			end
		end
	end
end
function public:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function public:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		me:SetAbsOrigin(me:GetAbsOrigin() + self.vVelocity * dt)
		self.vVelocity = self.vVelocity + Vector(self.vAcceleration.x, self.vAcceleration.y, 0) * dt
	end
end
function public:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end