if modifier_building == nil then
	modifier_building = class({})
end

local public = modifier_building

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
-- function public:GetEffectName()
-- 	return "maps/reef_assets/particles/reef_effects_hero.vpcf"
-- end
-- function public:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end
-- function public:GetStatusEffectName()
-- 	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
-- end
-- function public:StatusEffectPriority()
-- 	return 100
-- end
function public:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		self.time = GameRules:GetGameTime() + 2
	end
end
function public:OnDestroy()
	if IsServer() then
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,

		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		-- [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		-- [MODIFIER_STATE_SILENCED] = true,\
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		-- [MODIFIER_STATE_FROZEN] = GameRules:GetGameTime() > self.time,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MIN_HEALTH,
	-- MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
end
function public:GetModifierDisableTurning(params)
	return 1
end
function public:GetVisualZDelta(params)
	return 0
end
function public:GetMinHealth(params)
	return 1
end