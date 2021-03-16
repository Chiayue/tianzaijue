if modifier_feared == nil then
	modifier_feared = class({}, nil, BaseModifier)
end

local public = modifier_feared

function public:GetTexture()
	return "bane_nightmare"
end
function public:IsDebuff()
	return true
end
function public:IsStunDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		self.vDir = -hParent:GetForwardVector()
		hParent:MoveToPosition(hParent:GetAbsOrigin() + self.vDir * 100)
		self:StartIntervalThink(0.1)
	else
		local hCaster = self:GetCaster()
		local iPlayerID = hCaster:GetPlayerOwnerID()
		LocalPlayerParticle(iPlayerID, function()
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(iParticleID, false, false, -1, false, false)
			return iParticleID
		end, PARTICLE_DETAIL_LEVEL_LOW)

		LocalPlayerParticle(iPlayerID, function()
			local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_lone_druid_savage_roar.vpcf", PATTACH_INVALID, self:GetParent())
			self:AddParticle(iParticleID, false, true, 10, false, false)
			return iParticleID
		end, PARTICLE_DETAIL_LEVEL_LOW)
	end
end
function public:OnIntervalThink()
	local hParent = self:GetParent()
	self:StartIntervalThink(0.1)
	hParent:MoveToPosition(hParent:GetAbsOrigin() + self.vDir * 100)
end
function public:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_FEARED] = true,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TURN_RATE_OVERRIDE
	}
end
function public:GetModifierTurnRate_Override()
	return 999999
end