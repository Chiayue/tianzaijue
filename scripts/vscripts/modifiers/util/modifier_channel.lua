-- 标记正在施法，防止ai乱动
if modifier_channel == nil then
	modifier_channel = class({})
end

local public = modifier_channel

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