if modifier_hex == nil then
	modifier_hex = class({}, nil, BaseModifier)
end

local public = modifier_hex

function public:GetTexture()
	return "shadow_shaman_voodoo"
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:CheckState()
	return {
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
end