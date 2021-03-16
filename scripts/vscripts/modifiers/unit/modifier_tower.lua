if modifier_tower == nil then
	modifier_tower = class({}, nil, BaseModifier)
end

local public = modifier_tower

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
	return true
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
function public:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = self:GetStackCount() ~= 1,
		[MODIFIER_STATE_UNSELECTABLE] = self:GetStackCount() ~= 1,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function public:OnCreated(params)
	self:OnRefresh(params)
end
function public:OnRefresh(params)
	local hParent = self:GetParent()
	if IsServer() then
		local iState = params.iState or 1

		if 1 == iState then
			--打开
			hParent:RemoveNoDraw()
			hParent:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		else
			--关闭
			hParent:AddNoDraw()
			hParent:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
		end

		self:SetStackCount(iState)
	end
end