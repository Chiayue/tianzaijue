if modifier_silent == nil then
	modifier_silent = class({}, nil, BaseModifier)
end

local public = modifier_silent

function public:GetTexture()
	return "silencer_last_word"
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
	}
end