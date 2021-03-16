if modifier_evade == nil then
	modifier_evade = class({}, nil, eom_modifier)
end

local public = modifier_evade

function public:GetTexture()
	return "phantom_assassin_blur"
end
function public:IsPurgable()
	return false
end
function public:OnCreated(params)
	if IsServer() then
		self.evade_chance = params.evade_chance or 100
		self.evade_damage = params.evade_damage or 100
	end
end
function public:EDeclareFunctions()
	return {
		EMDF_ATTACK_MISS_BONUS
	}
end
function public:GetAttackMissBonus()
	return self.evade_damage, self.evade_chance
end