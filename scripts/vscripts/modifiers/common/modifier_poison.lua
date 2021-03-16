if modifier_poison == nil then
	modifier_poison = class({}, nil, eom_modifier)
end

local public = modifier_poison

function public:GetTexture()
	return "venomancer_poison_sting"
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return false
end
function public:OnCreated(params)
	if IsServer() then
		self:SetStackCount((params.iCount or 1))
		-- self:SetDuration(90, true)
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function public:OnRefresh(params)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + (params.iCount or 1))
		-- self:SetDuration(5, true)
	end
end
function public:OnIntervalThink()
	local flDamage = 60 * self:GetStackCount()
	local tDamageInfo = {
		attacker = self:GetCaster(),
		victim = self:GetParent(),
		-- ability = self:GetAbility(),
		damage = flDamage,
		damage_type = DAMAGE_TYPE_PURE
	}
	ApplyDamage(tDamageInfo)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), flDamage, self:GetCaster())
end
function public:ECheckState()
	return {
		[MODIFIER_STATE_POISONED] = true,
	}
end