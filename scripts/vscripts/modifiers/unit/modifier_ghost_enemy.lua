if modifier_ghost_enemy == nil then
	modifier_ghost_enemy = class({})
end
function modifier_ghost_enemy:IsHidden()
	return true
end
function modifier_ghost_enemy:IsDebuff()
	return false
end
function modifier_ghost_enemy:IsPurgable()
	return false
end
function modifier_ghost_enemy:IsPurgeException()
	return false
end
function modifier_ghost_enemy:AllowIllusionDuplicate()
	return false
end
function modifier_ghost_enemy:DestroyOnExpire()
	return false
end
-- function modifier_ghost_enemy:RemoveOnDeath()
-- 	return false
-- end
-- function modifier_ghost_enemy:GetEffectName()
-- 	return "particles/buildinghelper/ghost_pedestal.vpcf"
-- end
-- function modifier_ghost_enemy:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN
-- end
function modifier_ghost_enemy:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end
function modifier_ghost_enemy:StatusEffectPriority()
	return 100
end
function modifier_ghost_enemy:OnCreated(table)
	if IsServer() then
		self.timeFrozen = GameRules:GetGameTime() + 2
		-- local iPtclID = ParticleManager:CreateParticle('particles/buildinghelper/ghost_pedestal.vpcf', PATTACH_ABSORIGIN, self:GetParent())
		-- ParticleManager:SetParticleControl(iPtclID, 0, self:GetParent():GetAbsOrigin())
		-- self:AddParticle(iPtclID, false, false, -1, false, false)
	else
	end
end
function modifier_ghost_enemy:OnDestroy()
	if IsServer() then
	end
end
function modifier_ghost_enemy:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		-- [MODIFIER_STATE_INVISIBLE] = self:GetModifierInvisibilityLevel() >= 1,
		[MODIFIER_STATE_FROZEN] = GameRules:GetGameTime() > self.timeFrozen,
	}
end
function modifier_ghost_enemy:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
end
function modifier_ghost_enemy:GetModifierInvisibilityLevel()
	-- return 0.325
	return 0.1
end
function modifier_ghost_enemy:GetVisualZDelta()
	return 13
end