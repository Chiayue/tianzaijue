if modifier_froze == nil then
	modifier_froze = class({}, nil, BaseModifier)
end

local public = modifier_froze

function public:GetTexture()
	return "crystal_maiden_frostbite"
end
function public:OnCreated(params)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/generic_frozen.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true
	}
end