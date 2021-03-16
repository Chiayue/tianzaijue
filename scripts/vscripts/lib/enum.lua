-- table覆盖
local function TableOverride(mainTable, table)
	if mainTable == nil then
		return table
	end
	if table == nil or type(table) ~= "table" then
		return mainTable
	end

	for k, v in pairs(table) do
		if type(v) == "table" then
			mainTable[k] = TableOverride(mainTable[k], v)
		else
			mainTable[k] = v
		end
	end
	return mainTable
end

local _enumid = 0
function enumid(i)
	_enumid = i or (_enumid + 1)
	return _enumid
end

---生产enum
function enum(t, bUnique)
	local tIDs = {}
	for k, v in pairs(t) do
		tIDs[k] = v
	end
	for k, v in pairs(tIDs) do
		t[v] = k
	end
end

---生产val全局唯一的enum
function enum_unique(t, bUnique)
	local tIDs = {}
	for k, v in pairs(t) do
		t[k] = v .. ' ' .. k
		tIDs[k] = v
	end
	for k, v in pairs(tIDs) do
		t[v] = k
	end
	function t:enumid(k)
		return string.sub(t[k], 0, string.find(t[k], ' ') - 1)
	end
end