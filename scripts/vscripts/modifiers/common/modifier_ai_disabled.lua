if modifier_ai_disabled == nil then
	modifier_ai_disabled = class({}, nil, eom_modifier)
end

local public = modifier_ai_disabled

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:ECheckState()
	return {
		[MODIFIER_STATE_AI_DISABLED] = true,
	}
end