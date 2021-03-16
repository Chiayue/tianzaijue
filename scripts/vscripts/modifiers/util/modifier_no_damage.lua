if modifier_no_damage == nil then
	modifier_no_damage = class({}, nil, BaseModifier)
end

local public = modifier_no_damage

function public:GetTexture()
	return "modifier_invulnerable"
end
function public:GetAbsoluteNoDamageMagical()
	return 1
end
function public:GetAbsoluteNoDamagePhysical()
	return 1
end
function public:GetAbsoluteNoDamagePure()
	return 1
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
end
function public:CheckState()
	return {
		-- [MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end