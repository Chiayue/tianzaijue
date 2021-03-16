if modifier_tenacity == nil then
	modifier_tenacity = class({}, nil, eom_modifier)
end

local public = modifier_tenacity

function public:GetTexture()
	return "armadillo/ti8_immortal_head/pangolier_shield_crash_immortal"
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
	end
end
function public:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
	end
end
function public:EDeclareFunctions()
	return {
		[EMDF_STATUS_RESISTANCE_PERCENTAGE] = 100,
	}
end
function public:GetStatusResistancePercentage()
	return 100
end
function public:ECheckState()
	return {
		[MODIFIER_STATE_TENACITED] = true,
	}
end