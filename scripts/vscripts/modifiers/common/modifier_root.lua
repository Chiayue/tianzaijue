if modifier_root == nil then
	modifier_root = class({}, nil, BaseModifier)
end

local public = modifier_root

function public:GetTexture()
	return "treant_overgrowth"
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:OnCreated(params)
	if IsServer() then
		if params.damage ~= nil then
			self.damage = params.damage
			self:StartIntervalThink(1)
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_bramble_root.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function public:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	hCaster:DealDamage(hParent, nil, self.damage, DAMAGE_TYPE_MAGICAL)
end
function public:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end