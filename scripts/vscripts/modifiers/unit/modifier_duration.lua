if modifier_duration == nil then
	modifier_duration = class({})
end

local public = modifier_duration

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return true
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
		self:SetStackCount(params.stack_count)
	end
end
function public:OnDestroy()
end
function public:CheckState()
	return {
	}
end
function public:DeclareFunctions()
	return {
	}
end