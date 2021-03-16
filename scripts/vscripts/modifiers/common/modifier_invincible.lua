if modifier_invincible == nil then
	modifier_invincible = class({}, nil, BaseModifier)
end

local public = modifier_invincible

function public:GetTexture()
	return "modifier_invulnerable"
end
function public:IsPurgable()
	return false
end
function public:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end