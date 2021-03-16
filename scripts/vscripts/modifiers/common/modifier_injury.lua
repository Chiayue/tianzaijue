if modifier_injury == nil then
	modifier_injury = class({}, nil, eom_modifier)
end

local public = modifier_injury

function public:GetTexture()
	return "life_stealer_open_wounds"
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:OnCreated(params)
	if IsServer() then
		self.tData = {}
		self:IncrementStackCount()
		table.insert(self.tData, self:GetDieTime())
		self:StartIntervalThink(0)
	end
end
function public:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
		table.insert(self.tData, self:GetDieTime())
	end
end
function public:OnIntervalThink()
	for i = #self.tData, 1, -1 do
		if self.tData[i] < GameRules:GetGameTime() then
			self:DecrementStackCount()
			table.remove(self.tData, i)
		end
	end
end
function public:EDeclareFunctions()
	return {
		EMDF_INCOMING_PERCENTAGE
	}
end
function public:GetIncomingPercentage()
	return self:GetStackCount() * 10
end
function public:ECheckState()
	return {
		[MODIFIER_STATE_INJURED] = true,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function public:OnTooltip()
	return self:GetIncomingPercentage()
end