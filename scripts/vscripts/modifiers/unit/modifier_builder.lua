if modifier_builder == nil then
	modifier_builder = class({})
end

local public = modifier_builder

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return true
end
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		local vColor = Vector(255, 255, 255)
		if DOTA_PlayerColorVector then
			vColor = DOTA_PlayerColorVector[hParent:GetPlayerOwnerID() + 1]
		end
		local iParticleID = ParticleManager:CreateParticle("particles/player_color.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 1, vColor)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		-- AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
		-- self:StartIntervalThink(0)
	end
end
function public:OnRemoved()
	if IsServer() then
	end
end
function public:OnDestroy()
	if IsServer() then
		-- RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
	end
end
function public:OnIntervalThink()
end
function public:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	--
	-- [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IS_SCEPTER,
	-- MODIFIER_EVENT_ON_DEATH,
	}
end
function public:GetModifierScepter(params)
	return 1
end
-- function public:OnDeath(params)
-- 	if params.unit == self:GetParent() then
-- 		self:GetAbility():DamagePlayer()
-- 	end
-- end