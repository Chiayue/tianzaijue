--[[权重池
类功能使用的是Valve提供的class库
用于处理各种权重随机计算

权重池仅提供2个相关参数：
string:sName
integer:iWeight

constructor的参数tList是以sName为key，iWeight为value的表

例子：local pool = WeightPool({""})
]]
--
if WeightPool == nil then
	---@class WeightPool
	WeightPool = class({})
end
---@type WeightPool
local public = WeightPool

function public:constructor(tList)
	self.tList = shallowcopy(tList) or {}

	self:update()
end

function public:update()
	self.tName = {}
	self.tSection = {}
	local iTotal = 0
	for sName, iWeight in pairs(self.tList) do
		iTotal = iTotal + iWeight
		table.insert(self.tSection, iTotal)

		table.insert(self.tName, sName)
	end
end

function public:Has(sName)
	for name, _ in pairs(self.tList) do
		if name == sName then
			return true
		end
	end
	return false
end

function public:Get(sName)
	return self.tList[sName] or 0
end

function public:Set(sName, iWeight)
	self.tList[sName] = iWeight > 0 and iWeight or nil

	self:update()
end

function public:Add(sName, iWeight)
	self:Set(sName, (self.tList[sName] or 0) + iWeight)
end

function public:Remove(sName)
	self:Set(sName, 0)
end
function public:RemoveByTable(tNames)
	for _, sName in pairs(tNames) do
		self.tList[sName] = nil
	end
	self:update()
end

function public:Random()
	local iRandom = RandomInt(1, self.tSection[#self.tSection] or 1)
	return self:_random(iRandom)
end
function public:_random(iRandom)
	if self.bDebug then
		print('---Random log:', 'roll=' .. iRandom, 'range=' .. self.tSection[#self.tSection])
		local iSum = self.tSection[#self.tSection]
		local iLastVal = 0
		local iResult
		local tbDebug = {}
		for i, max in ipairs(self.tSection) do
			tbDebug[i] = {
				range = max,
				chance = Round(((max - iLastVal) / iSum) * 100, 2),
			}
			print('#' .. i, 'cur_range=' .. max, 'chance=' .. tbDebug[i].chance .. "%", 'name=' .. self.tName[i])
			iLastVal = max

			if nil == iResult and iRandom <= max then
				iResult = i
			end
		end

		if iResult then
			print('---Random log end, result=', self.tName[iResult], 'chance=' .. tbDebug[iResult].chance .. "%")
		else
			print('---Random log end no result')
		end
	end

	for i, max in ipairs(self.tSection) do
		if iRandom <= max then
			return self.tName[i]
		end
	end
end

function public:RandomMulti(iCount, bRepeat)
	local tResult = {}
	local tRemove = {}
	for i = (iCount or 1), 1, -1 do
		local sName = self:Random()
		if not sName then break end

		table.insert(tResult, sName)

		if not bRepeat then
			--去重
			tRemove[sName] = self.tList[sName]
			self:Remove(sName)
		end
	end
	for sName, iWeight in pairs(tRemove) do
		self.tList[sName] = iWeight
	end
	self:update()
	return tResult
end

function public:RandomWith(iRandom, iRange)
	local iRandom = iRandom / iRange * self.tSection[#self.tSection]
	return self:_random(iRandom)
end

function public:SwitchDebugLog(bOn)
	self.bDebug = bOn
end