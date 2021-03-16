if modifier_stun == nil then
	modifier_stun = class({}, nil, BaseModifier)
end

local public = modifier_stun

function public:GetTexture()
	return "tiny_toss"
end
function public:OnCreated(params)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function public:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end
function public:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function public:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end