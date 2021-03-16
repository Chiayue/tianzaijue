if modifier_nightmare == nil then
	modifier_nightmare = class({}, nil, BaseModifier)
end

local public = modifier_nightmare

function public:GetTexture()
	return "bane_nightmare"
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