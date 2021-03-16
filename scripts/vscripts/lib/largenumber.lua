--大数对象
if LargeNumber == nil then
	---@class LargeNumber
	LargeNumber = {
		tBit = {},
		iPointPos = 1,
	}
	LargeNumber = class(LargeNumber)
end
---@type LargeNumber
local public = LargeNumber

function public:constructor(num)
	local sNum = tostring(num)
	local iPos = string.find(sNum, 'e+')
	print('aaa iPos', iPos, self.tBit, self.iPointPos)
	if iPos then
		-- 科学记数法
		local a = string.sub(sNum, 0, iPos - 1)
		local b = string.sub(a, 0, string.find(a, "%.") - 1)
		a = string.sub(a, string.find(a, "%.") + 1)
		local c = string.sub(sNum, iPos + 2)
	else

	end
end

public(-12312345678900124000)

return public