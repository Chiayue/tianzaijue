if modifier_disarm == nil then
	modifier_disarm = class({}, nil, BaseModifier)
end

local public = modifier_disarm

function public:GetTexture()
	return "action_attackmove"
end
function public:IsDebuff()
	return true
end
function public:OnCreated(params)
	if IsClient() then
		LocalPlayerParticle(self:GetCaster():GetPlayerOwnerID(), function()
			self.iParticleID = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
			return self.iParticleID
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end
function public:IsPurgable()
	return true
end
function public:OnDestroy()
	if self.iParticleID and IsClient() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
	}
end