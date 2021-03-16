if modifier_taunted == nil then
	modifier_taunted = class({}, nil, eom_modifier)
end

local public = modifier_taunted

function public:OnCreated(params)
	if IsServer() then
		self:GetParent():Stop()
		self:GetParent():SetForceAttackTarget(self:GetCaster())
		self:StartIntervalThink(0.1)
	else
		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_beserkers_call.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(particleID, false, false, -1, false, false)
	end
end

function public:GetTexture()
	return "axe_berserkers_call"
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:OnIntervalThink()
	if not IsValid(self:GetCaster()) or not self:GetCaster():IsAlive() then
		self:Destroy()
	end
end
function public:OnDestroy()
	if IsServer() then
		self:GetParent():SetForceAttackTarget(nil)
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_TAUNTED] = true,
	}
end