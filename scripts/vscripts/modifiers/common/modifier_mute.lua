if modifier_mute == nil then
	modifier_mute = class({}, nil, BaseModifier)
end

local public = modifier_mute

function public:GetTexture()
	return "action_stop"
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:CheckState()
	return {
		[MODIFIER_STATE_MUTED] = true,
	}
end