json = require("game/dkjson")

TS_TYPE = {
	GameUI = 'CDOTA_PanoramaScript_GameUI',
}
for k, v in pairs(TS_TYPE) do TS_TYPE[v] = k end

function toTsInterface(val, _layer, bMergeNumKey)
	local sVal = '{'
	_layer = _layer or ''
	local sLayer = _layer .. '\t'
	local sMerge = ''
	local tMergeData = {}
	for k, v in pairs(val) do
		if 'table' ~= type(k) then
			local function doing(tData)
				local s = ' \n' .. sLayer
				if 'table' == type(tData) then
					s = s .. k .. ':' .. toTsInterface(tData, sLayer, bMergeNumKey)
				else
					s = s .. k .. ':' .. type(tData)
				end
				return s
			end
			if tonumber(k) then
				if bMergeNumKey then
					--数字key的数据归一化
					if 'table' == type(v) and 'table' == type(tMergeData) then
						tMergeData = TableOverride(tMergeData, v)
					else
						tMergeData = v
					end
					k = '[index in number|string]'
					sMerge = doing(tMergeData)
				else
					k = tonumber(k)
					sVal = sVal .. doing(v)
				end
			else
				sVal = sVal .. doing(v)
			end
		end
	end
	sVal = sVal .. sMerge
	sVal = sVal .. '\n' .. _layer .. '}'
	return sVal
end
function toTsObjcet(val, _layer)
	local sVal = '{'
	_layer = _layer or ''
	local sLayer = _layer .. '\t'
	for k, v in pairs(val) do
		if tonumber(k) then
			k = tonumber(k)
		end
		sVal = sVal .. ' \n' .. sLayer
		if 'table' == type(v) then
			sVal = sVal .. k .. ':' .. toTsObjcet(v, sLayer) .. ','
		elseif tonumber(v) then
			sVal = sVal .. k .. ':' .. tonumber(v) .. ','
		else
			sVal = sVal .. k .. ':"' .. v .. '",'
		end
	end
	sVal = sVal .. '\n' .. _layer .. '}'
	return sVal
end

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

function KvToJson(sKvName, tTable)
	local filePath = ContentDir .. AddonName .. "\\panorama\\scripts\\kv\\" .. sKvName .. ".js"
	local file = io.open(filePath, 'w')
	local str = json.encode(tTable)
	str = string.gsub(str, "'", "\\'")
	file:write("const " .. sKvName .. "_json" .. " = '" .. str .. "';")
	file:write("\n")
	file:write("GameUI." .. sKvName .. " = JSON.parse(" .. sKvName .. "_json);")
	file:close()
end

--kv转typescripts
---@param typeTS TS_TYPE 默认实现在GameUI下
---@param bOnlyInterace 是否只声明类型接口
function KvToTs(sKvName, tTable, typeTS, bOnlyInterace)
	KvToJson(sKvName, tTable)
	typeTS = typeTS or TS_TYPE.GameUI
	local filePath = ContentDir .. AddonName .. "\\panorama\\ts\\scripts\\kv\\" .. sKvName .. ".ts"
	local file = io.open(filePath, 'w')

	--定义TS类型接口
	file:write("interface " .. typeTS .. " {\n" .. sKvName .. ':' .. toTsInterface(tTable) .. "}\n")
	--赋值
	if not bOnlyInterace then
		file:write(TS_TYPE[typeTS] .. "." .. sKvName .. " = " .. toTsObjcet(tTable))
	end
	file:close()
end


--nettable转Ts
if not CustomNetTables._SetTableValue then
	CustomNetTables._SetTableValue = CustomNetTables.SetTableValue
	CustomNetTables.tTableNames = {}
	-- ListenToGameEvent("game_rules_state_change", function()
	-- 	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
	-- 		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("NetTableToTs"), function()
	-- 			NetTableToTs()
	-- 			return 60
	-- 		end, 0)
	-- 	end
	-- end, nil)
end
function CustomNetTables:SetTableValue(sT1, sT2, tTable, ...)
	if not CustomNetTables.tTableNames[sT1] then CustomNetTables.tTableNames[sT1] = {} end
	CustomNetTables.tTableNames[sT1][sT2] = TableOverride(CustomNetTables.tTableNames[sT1][sT2], tTable)
	-- NetTableToTs()
	--
	local s = json.encode(tTable)
	local size = string.len(s)
	if size > 5000 then
		s = '[warning] net table value size : ' .. size .. ' name=' .. sT1 .. ' key=' .. sT2
		print(s)
		DebugError('nettable,' .. sT1 .. ',' .. sT2 .. ',' .. math.floor(size / 5000), s)
	end
	return CustomNetTables:_SetTableValue(sT1, sT2, tTable, ...)
end

function NetTableToTs()
	local version = '1.0.2'
	local version_old = io.lines(ContentDir .. AddonName .. "\\panorama\\ts\\scripts\\kv\\nt\\cfg.cfg")()
	if version_old ~= version then
		io.popen('rd /S/Q "' .. ContentDir .. AddonName .. "\\panorama\\scripts\\kv\\nt\"", "r")
		io.popen('del /Q "' .. ContentDir .. AddonName .. "\\panorama\\ts\\scripts\\kv\\nt\\*.ts\"", "r")
		local file = io.open(ContentDir .. AddonName .. "\\panorama\\ts\\scripts\\kv\\nt\\cfg.cfg", 'w')
		file:write(version)
		file:close()
	end

	local typeTS = TS_TYPE.GameUI
	local sNamespace = 'NetTable'

	for sT1, t1 in pairs(CustomNetTables.tTableNames) do

		for sT2, t2 in pairs(t1) do
			--创建一张表数据
			local sFile = sT1
			local sBody = 'namespace ' .. sNamespace .. '{'
			sBody = sBody .. '\n\texport namespace ' .. sT1 .. '{'

			local s2 = '{'
			local sTypeName1 = sT1

			local tMergeData = {}

			--小表数据
			local sTypeName2 = sT2
			if tonumber(sT2) then
				--index为key的数据归一化
				sTypeName2 = sT1 .. '_data'
				s2 = s2 .. '\n\t\t' .. '[index:number]' .. ' : ' .. sT1 .. '.' .. sTypeName2
				tMergeData = TableOverride(tMergeData, t2)
				sBody = sBody .. "\n\t\texport type " .. sTypeName2 .. '=' .. toTsInterface(tMergeData, '\t\t', true) .. '\n'
			else
				sFile = sT1 .. ' ' .. sT2
				s2 = s2 .. '\n\t\t' .. sT2 .. ' : ' .. sT1 .. '.' .. sTypeName2
				sBody = sBody .. "\n\t\texport type " .. sTypeName2 .. '=' .. toTsInterface(t2, '\t\t', true) .. '\n'
			end
			sBody = sBody .. "\n\t}\n\texport interface " .. sTypeName1 .. s2 .. '\n\t}\n'

			local file = io.open(ContentDir .. AddonName .. "\\panorama\\ts\\scripts\\kv\\nt\\" .. sFile .. ".ts", 'w')

			--写入table数据
			file:write(sBody .. '\n}\n')

			--接入接口
			local sT1_ts = '{\n\t' .. sT1 .. ' : ' .. sNamespace .. '.' .. sTypeName1
			file:write("interface " .. sNamespace .. '_Data ' .. sT1_ts .. '\n}\n')
			file:write("interface " .. typeTS .. '{ \n\tNetTable : ' .. sNamespace .. '_Data ' .. '\n}')
			file:close()
		end
	end
end