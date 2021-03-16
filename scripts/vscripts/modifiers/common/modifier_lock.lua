if modifier_lock == nil then
	modifier_lock = class({}, nil, eom_modifier)
end

local public = modifier_lock

function public:GetTexture()
	return "faceless_void_time_lock"
end
function public:OnCreated(params)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_faceless_chronosphere.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, true, -10, false, false)
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
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function public:ECheckState()
	return {
		[MODIFIER_STATE_LOCKED] = true,
	}
end