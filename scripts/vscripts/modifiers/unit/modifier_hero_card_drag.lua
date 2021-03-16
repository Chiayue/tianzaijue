if modifier_hero_card_drag == nil then
	modifier_hero_card_drag = class({})
end
function modifier_hero_card_drag:IsHidden()
	return true
end
function modifier_hero_card_drag:IsDebuff()
	return false
end
function modifier_hero_card_drag:IsPurgable()
	return false
end
function modifier_hero_card_drag:IsPurgeException()
	return false
end
function modifier_hero_card_drag:AllowIllusionDuplicate()
	return false
end
function modifier_hero_card_drag:RemoveOnDeath()
	return true
end
function modifier_hero_card_drag:DestroyOnExpire()
	return true
end
function modifier_hero_card_drag:IsPermanent()
	return false
end
function modifier_hero_card_drag:OnCreated(params)
	if IsServer() then
		if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
		self:OnRefresh(params)
	end
end
function modifier_hero_card_drag:OnRefresh(params)
	if IsServer() then
		self.vPos = Vector(params.pos_x, params.pos_y, params.pos_z)
	end
end
function modifier_hero_card_drag:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
	end
end
function modifier_hero_card_drag:UpdateHorizontalMotion(hParent, dt)
	if IsServer() then
		-- SnapToGrid(BUILDING_SIZE, self.vPos)
		hParent:SetAbsOrigin(self.vPos + Vector(0, 0, self:GetVisualZDelta()))
	end
end
function modifier_hero_card_drag:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_hero_card_drag:UpdateVerticalMotion(hParent, dt)
	if IsServer() then
		-- SnapToGrid(BUILDING_SIZE, self.vPos)
		hParent:SetAbsOrigin(self.vPos + Vector(0, 0, self:GetVisualZDelta()))
		hParent:SetAbsAngles(0, 90, 0)
	end
end
function modifier_hero_card_drag:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_hero_card_drag:CheckState()
	return {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,

		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = false,
	}
end
function modifier_hero_card_drag:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
end
function modifier_hero_card_drag:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
function modifier_hero_card_drag:GetOverrideAnimationRate(params)
	return 1
end
function modifier_hero_card_drag:GetVisualZDelta(params)
	return 0
end