if modifier_ghost_tower == nil then
	modifier_ghost_tower = class({})
end
function modifier_ghost_tower:IsHidden()
	return true
end
function modifier_ghost_tower:IsDebuff()
	return false
end
function modifier_ghost_tower:IsPurgable()
	return false
end
function modifier_ghost_tower:IsPurgeException()
	return false
end
function modifier_ghost_tower:AllowIllusionDuplicate()
	return false
end
function modifier_ghost_tower:DestroyOnExpire()
	return false
end
-- function modifier_ghost_tower:RemoveOnDeath()
-- 	return false
-- end
-- function modifier_ghost_tower:GetStatusEffectName()
-- 	return "particles/status_fx/status_effect_ghost.vpcf"
-- end
-- function modifier_ghost_tower:StatusEffectPriority()
-- 	return 10
-- end
function modifier_ghost_tower:OnCreated(table)
	if IsServer() then
		self.timeDelay = table.delay or 0
		self.timeFrozen = GameRules:GetGameTime() + self.timeDelay
		if GSManager:getStateType() == GS_Battle then
			self:StartIntervalThink(self.timeDelay)
		else
			self:StartIntervalThink(0)
		end
	end
end
function modifier_ghost_tower:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveNoDraw()
	end
end
function modifier_ghost_tower:OnIntervalThink()
	if self:GetParent():HasModifier('modifier_hero_card_drag_show') then
		return
	end
	self:GetParent():AddNoDraw()
end
function modifier_ghost_tower:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = GameRules:GetGameTime() > self.timeFrozen,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		-- [MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_INVISIBLE] = self:GetModifierInvisibilityLevel() >= 1,
	}
end
function modifier_ghost_tower:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_ghost_tower:GetModifierInvisibilityLevel()
	if self.timeFrozen then
		local fTime = self.timeFrozen - GameRules:GetGameTime()
		if fTime > 0 then
			return 1 - (fTime / self.timeDelay)
		end
	end
	return 1
	-- return 0.425
end
-- function modifier_ghost_tower:GetOverrideAnimation()
-- 	return ACT_DOTA_IDLE
-- end