if modifier_building_move == nil then
	modifier_building_move = class({})
end

local public = modifier_building_move

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
	return false
end
-- function public:IsPermanent()
-- 	return true
-- end
function public:OnCreated(params)
	if IsServer() then
		if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
		self:OnRefresh(params)
	end
end
function public:OnRefresh(params)
	if IsServer() then
		self.vPos = Vector(params.pos_x, params.pos_y, params.pos_z)
	end
end
function public:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
	end
end
function public:UpdateHorizontalMotion(hParent, dt)
	if IsServer() then
		-- SnapToGrid(BUILDING_SIZE, self.vPos)
		hParent:SetAbsOrigin(self.vPos + Vector(0, 0, self:GetVisualZDelta()))
	end
end
function public:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function public:UpdateVerticalMotion(hParent, dt)
	if IsServer() then
		-- SnapToGrid(BUILDING_SIZE, self.vPos)
		hParent:SetAbsOrigin(self.vPos + Vector(0, 0, self:GetVisualZDelta()))
	end
end
function public:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = false,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	-- MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
end
function public:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
function public:GetOverrideAnimationRate(params)
	return 1
end
function public:GetVisualZDelta(params)
	return 128
end