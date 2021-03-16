if modifier_hero_card_drag_show == nil then
	modifier_hero_card_drag_show = class({})
end
function modifier_hero_card_drag_show:IsHidden()
	return true
end
function modifier_hero_card_drag_show:IsDebuff()
	return false
end
function modifier_hero_card_drag_show:IsPurgable()
	return false
end
function modifier_hero_card_drag_show:IsPurgeException()
	return false
end
function modifier_hero_card_drag_show:AllowIllusionDuplicate()
	return false
end
function modifier_hero_card_drag_show:RemoveOnDeath()
	return true
end
function modifier_hero_card_drag_show:DestroyOnExpire()
	return true
end
function modifier_hero_card_drag_show:IsPermanent()
	return false
end
function modifier_hero_card_drag_show:get()
	return false
end
function modifier_hero_card_drag_show:OnCreated(params)
	if IsServer() then
		self:OnRefresh(params)
	end
end
function modifier_hero_card_drag_show:OnRefresh(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveNoDraw()

		self.active_unit_name = params.active_unit_name
		if self.active_unit_name == hParent:GetUnitName() then
			self:SetStackCount(1)
		end
	end
end
function modifier_hero_card_drag_show:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:HasModifier('modifier_ghost_tower') then
			hParent:AddNoDraw()
		end
	end
end
function modifier_hero_card_drag_show:CheckState()
	if 1 == self:GetStackCount() then
		return {
			[MODIFIER_STATE_FROZEN] = false,
			[MODIFIER_STATE_INVISIBLE] = false,
		}
	end
	return {}
end
function modifier_hero_card_drag_show:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	-- MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	-- MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
end
function modifier_hero_card_drag_show:GetOverrideAnimation(params)
	if 1 == self:GetStackCount() then
		return ACT_DOTA_VICTORY
	end
end
function modifier_hero_card_drag_show:GetOverrideAnimationRate(params)
	return 1
end
function modifier_hero_card_drag_show:GetVisualZDelta(params)
	return 0
end
function modifier_hero_card_drag_show:GetModifierInvisibilityLevel(params)
	return 0
end