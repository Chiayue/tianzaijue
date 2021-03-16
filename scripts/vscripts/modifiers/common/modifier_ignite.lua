if modifier_ignite == nil then
	modifier_ignite = class({}, nil, eom_modifier)
end

local public = modifier_ignite

function public:GetTexture()
	return "ogre_magi_ignite"
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return false
end
function public:OnCreated(params)
	if IsServer() then
		local iCount = params.iCount or 1
		self:IncrementStackCount(iCount)
		self:StartIntervalThink(1)
	end
end
function public:OnRefresh(params)
	if IsServer() then
		local iCount = params.iCount or 1
		self:IncrementStackCount(iCount)
	end
end
function public:OnIntervalThink()
	local tDamageInfo = {
		attacker = self:GetCaster(),
		victim = self:GetParent(),
		ability = self:GetAbility(),
		damage = 60 * self:GetStackCount(),
		damage_type = DAMAGE_TYPE_MAGICAL
	}
	ApplyDamage(tDamageInfo)
end
function public:ECheckState()
	return {
		[MODIFIER_STATE_IGNITED] = true,
	}
end