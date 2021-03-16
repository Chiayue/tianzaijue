if modifier_dummy == nil then
	modifier_dummy = class({})
end

local public = modifier_dummy

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
	return true
end
function public:IsPermanent()
	return false
end
function public:OnCreated()
	if IsServer() then
		if IsInToolsMode() then
			-- SendToServerConsole("ent_text " .. self:GetParent():entindex())
		end
	end
end
function public:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
		self:GetParent():RemoveSelf()
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end