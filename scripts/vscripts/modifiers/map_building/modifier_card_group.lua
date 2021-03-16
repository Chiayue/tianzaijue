if modifier_card_group == nil then
	modifier_card_group = class({})
end

local public = modifier_card_group

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
	return false
end
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
end
function public:OnDestroy()
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end
function public:GetOverrideAnimation()
	return ACT_DOTA_CAPTURE
end
function public:GetActivityTranslationModifiers()
	return 'level6'
end