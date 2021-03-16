if modifier_movespeed_alldeath == nil then
	modifier_movespeed_alldeath = class({}, nil, BaseModifier)
end

local public = modifier_movespeed_alldeath

function public:GetTexture()
	return "bounty_hunter_track"
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function public:GetModifierMoveSpeedBonus_Percentage(params)
	return 100
end