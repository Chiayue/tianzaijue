if modifier_blind == nil then
	modifier_blind = class({}, nil, BaseModifier)
end

local public = modifier_blind

function public:GetTexture()
	return "keeper_of_the_light_blinding_light"
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:CheckState()
	return {
		[MODIFIER_STATE_BLIND] = true,
	}
end