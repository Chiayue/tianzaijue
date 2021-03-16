if modifier_artifact_hitbox == nil then
	modifier_artifact_hitbox = class({})
end

local public = modifier_artifact_hitbox

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
function public:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function public:OnCreated(params)
	if IsServer() then
		self:SetStackCount(params.slot or 0)
	end
end
function public:OnRefresh(params)
	if IsServer() then
		self:SetStackCount(params.slot or 0)
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	-- [MODIFIER_STATE_OUT_OF_GAME] = true,
	}
end