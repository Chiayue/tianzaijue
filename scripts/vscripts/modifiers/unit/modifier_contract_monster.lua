if modifier_contract_monster == nil then
	modifier_contract_monster = class({})
end

local public = modifier_contract_monster

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
function public:OnCreated(params)
	if IsServer() then
	end
end
function public:OnRefresh(params)
	if IsServer() then
	end
end
function public:OnDestroy()
	if IsServer() then
	end
end
function public:OnIntervalThink()
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end