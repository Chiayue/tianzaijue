function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end

	done = done or {}
	done[t] = true
	indent = indent or 1

	local l = {}
	for k, v in pairs(t) do
		table.insert(l, k)
	end

	table.sort(l)
	if indent == 1 then
		print("{")
	end
	for k, tableKey in ipairs(l) do
		-- Ignore FDesc
		if tableKey ~= 'FDesc' then
			local value = t[tableKey]

			if type(value) == "table" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(tableKey).. "  ("..type(tableKey)..")"..":")
				PrintTable (value, indent + 1, done)
			elseif type(value) == "userdata" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(tableKey)..": "..tostring(value))
				PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 1, done)
			else
				if t.FDesc and t.FDesc[tableKey] then
					print(string.rep ("\t", indent)..tostring(t.FDesc[tableKey]))
				else
					--普通kv结果显示：key(type):value(type)
					print(string.rep ("\t", indent)..tostring(tableKey).. "  ("..type(tableKey)..")"..": "..tostring(value) .. "  ("..type(value)..")")
				end
			end
		end
	end
	if indent == 1 then
		print("}")
	end
end

function dumpTable(t,...)
	if ... then
		local args = {...}
		local argStr = ""
		for key, var in ipairs(args) do
			if key == 1 then
				argStr = argStr .. tostring(var)
			else
				argStr = argStr .. "\t" .. tostring(var)
			end
		end
		print("================",argStr,"================")
	end
	if type(t) == "table" then
		PrintTable(t)
	elseif t ~= nil then
		print(tostring(t))
	else
		print("nil")
	end
end

function DebugPrint(...)

	if IsInToolsMode() then
		print(...)
	end
end

function DebugPrintTable(...)

	if IsInToolsMode() then
		PrintTable(...)
	end
end


--- 用法:
-- local list = Split("abc,123,345", ",")，list是一个数组。<p>
-- 数组长度 #list，数组元素 list[index] (index从1开始)
function Split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

--判断一个数是否是小数
function isFloat(num)
	if type(num) ~= "number" then
		return false
	else
		return math.floor(num) < num
	end
end
---将浮点数转为n位小数（不足n位的话，返回实际的位数；转换后末尾是0的，会被丢弃，也就是说最多会有n位小数，实际可能少于n），
--@param num 数字
--@param n 精度（小数位），如果为nil，则默认是2位
--@param numRes 是否返回数值型结果，如果为否（或nil），则返回字符串
function ParseFloatToDecimal(num,n,numRes)
	if not isFloat(num) then
		return numRes and num or tostring(num)
	else
		n = n or 2;
		local fmt = "%."..n.."f"
		local value = string.format(fmt,num);
		if numRes then
			return tonumber(value)
		else--去掉后面的0
			return tostring(tonumber(value));
		end
		
	end
end

---将传入的值转换为数值型
--@param value 可以是数值型和字符型，当是字符型的时候，可以包括"%"(如50%)，此时返回的是一个小数(0.5)；其他类型的返回0
--@return 两个返回值，第一个是数值，第二个是个布尔型，表明是否是百分比
function parseNumber(value)
	local isPercent = false --是否是百分比数字
	if type(value) == "string" then --字符型的话判断是否有%
		local percentIndex,_ = string.find(value,"%%");
		if percentIndex ~= nil and percentIndex > 1 then
			isPercent = true
			value = tonumber(string.sub(value,1,percentIndex - 1)) or 0
			value = value / 100 --百分比的求为小数
		else
			value = tonumber(value) or 0
		end
	else
		value = tonumber(value) or 0
	end

	return value,isPercent
end

function IsPositiveNum(value)
	return type(value) == "number" and value > 0
end

function NumberRound(num)
	if type(num) ~= "number" then
		return num
	end
	
	if math.floor(num) == math.floor(num + 0.5) then
		return math.floor(num)
	else
		return math.ceil(num)
	end
end



---位运算测试数值full是否包含target值。如果有一个不是数字，则直接返回false
--@param #number full 测试值
--@param #number target 要检查是否存在的值
--@return #boolean 返回value是否包含test位
function BitAndTest(full,target)
	if type(full) == "number" and type(target) == "number" then
		return target == bit32.band(full,target)
	end
	return false;
end

---获取任意一个table中的非空元素数量
function TableLen(t)
	if t then
		local len = 0;
		for key, var in pairs(t) do
			len = len +1;
		end
		return len;
	end
	return 0
end

---判断一个表是否是空表（有任意元素就不认为是空表）
function TableNotEmpty(t)
	if t then
		for key, var in pairs(t) do
			return true;
		end
	end
	return false;
end

---表复制，返回一个副本。会嵌套复制子表<br>
--注意：只针对key和value是简单的lua元素（table，number，string，boolean值）的表，如果涉及到其他的（比如function，userdata）的类型，则不会产生副本，仍然是引用对象
function TableCopy(t)
	if type(t) ~= "table" then
		return t;
	end
	local result = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			result[TableCopy(k)] = TableCopy(v)
		else
			result[TableCopy(k)] = v
		end
	end
	return result;
end

---权重随机
--@param #table t 要随机的表
--@param #table weights 权重
function GetRanomByWeight(t, weights)
    local sum = 0
    for i = 1, #weights do
        sum = sum + weights[i]
    end
    local compareWeight = RandomFloat(1, sum)
    local weightIndex = 1
    while sum > 0 do
        sum = sum - weights[weightIndex]
        if sum < compareWeight then
            return t[weightIndex]
        end
        weightIndex = weightIndex + 1
    end
    DebugPrint("compare error, return nil")
    return nil
end

---检查当前时间是否在特定时间之前
--@param #string timeStr 时间字符串，格式：YYYYMMDDHHmmss 或者 YYYY-MM-DD HH:mm:ss
--@param #boolean replaceInvalidChar 是否移除timeStr中的非法字符（主要针对第二种格式）
function CheckTimeBefore(timeStr,replaceInvalidChar)
	local now = GetDateTime()
	if timeStr then
		if replaceInvalidChar then
			timeStr = string.gsub(timeStr," ","")
			timeStr = string.gsub(timeStr,"-","")
			timeStr = string.gsub(timeStr,":","")
		end
		return now <= timeStr
	end
	return false;
end

---检查当前时间是否在某个特定的时间区间内（包含两头）<p>
--由于dota接口获取的时间(不是UTC就是GMT)比北京时间晚8小时，所以以北京时间为准的话，所有时间要+8小时
--@param #string minTime 时间字符串，非空，格式：YYYYMMDDHHmmss
--@param #string maxTime 时间字符串，非空，格式：YYYYMMDDHHmmss
function CheckTimeInRange(minTime,maxTime)
	local now = GetDateTime()
	if minTime and maxTime then
		return now >= minTime and now <= maxTime
	end
	return false;
end
