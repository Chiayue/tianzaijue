if nil == NetEventData then
	---@class NetEventData
	NetEventData = {
		tData = {},
		tPlayerData = {},
		tCallback = {},
		iBindID = 0,
	}
end
---@type NetEventData
local public = NetEventData

if IsServer() then

	function public:init(bReload)
		if not bReload then
			self.typeGameRulesState = DOTA_GAMERULES_STATE_INIT
			---允许更新数据的状态
			self.typeGameRulesStateCanUpdate = DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP
		end

		GameEvent("game_rules_state_change", Dynamic_Wrap(self, "OnGameRulesStateChange"), self)
		CustomUIEvent("NetEventData_ClientGet", Dynamic_Wrap(self, "OnClientGet"), self)
	end

	---设置网络数据表
	function public:SetTableValue(sTable, sKey, tVal)
		if nil == tVal then
			local tTable = self.tData[sTable]
			if tTable then
				tTable[sKey] = nil
				self:_Update(sTable, sKey, nil)
			end
		else
			local sJsonVal = json.encode(tVal)
			if sJsonVal then
				local tTable = self.tData[sTable]
				if not tTable then
					tTable = {}
					self.tData[sTable] = tTable
				end
				local sJsonValCur = tTable[sKey]
				if sJsonVal ~= sJsonValCur then
					tTable[sKey] = sJsonVal
					self:_Update(sTable, sKey, sJsonVal)
				end
			end
		end
	end

	---设置网络数据表（指定玩家）
	function public:SetPlayerTableValue(sTable, sKey, tVal, iPlayerID)
		local tPlaterDara = self.tPlayerData[iPlayerID]
		if nil == tPlaterDara then
			tPlaterDara = {}
			self.tPlayerData[iPlayerID] = tPlaterDara
		end

		if nil == tVal then
			local tTable = tPlaterDara[sTable]
			if tTable then
				tTable[sKey] = nil
				self:_Update(sTable, sKey, nil, iPlayerID)
			end
		else
			local sJsonVal = json.encode(tVal)
			if sJsonVal then
				local tTable = tPlaterDara[sTable]
				if not tTable then
					tTable = {}
					tPlaterDara[sTable] = tTable
				end
				local sJsonValCur = tTable[sKey]
				if sJsonVal ~= sJsonValCur then
					tTable[sKey] = sJsonVal
					self:_Update(sTable, sKey, sJsonVal, iPlayerID)
				end
			end
		end
	end

	---@private
	function public:_Update(sTable, sKey, sData, iPlayerID)
		local tData = {
			table = sTable,
			key = sKey,
			json = sData,
			playerid = iPlayerID,
		}
		if iPlayerID then
			local player = PlayerResource:GetPlayer(iPlayerID)
			if player then
				CustomGameEventManager:Send_ServerToPlayer(player, "net_event_data", tData)
			end
		else
			FireGameEvent("net_event_data", tData)
			if nil ~= sData then
				self:_Callback(sTable, sKey, sData)
			end
		end
	end

	---@private
	function public:OnClientGet(_, tEvent)
		local iPlayerID = tEvent.PlayerID
		local i = 0
		for sTable, v in pairs(self.tData) do
			for sKey, sData in pairs(v) do
				Timer(i * 0.05, function()
					self:_Update(sTable, sKey, sData, iPlayerID)
				end)
				i = i + 1
			end
		end
		Timer(i * 0.05, function()
			local player = PlayerResource:GetPlayer(iPlayerID)
			if player then
				CustomGameEventManager:Send_ServerToPlayer(player, "net_event_data_get_finished", {})
			end
		end)
	end

	---@private
	function public:OnGameRulesStateChange()
		self.typeGameRulesState = GameRules:State_Get()
		if self.typeGameRulesState == self.typeGameRulesStateCanUpdate then
			for sTable, v in pairs(self.tData) do
				for sKey, sData in pairs(v) do
					self:_Update(sTable, sKey, sData)
				end
			end
		end
	end


else

	function public:init(bReload)
		ListenToGameEvent("net_event_data", Dynamic_Wrap(public, "OnUpdate"), public)
		ListenToGameEvent("net_event_data_local", Dynamic_Wrap(public, "OnUpdate"), public)
	end

	---@private
	function public:OnUpdate(tEvent)
		local tTable = self.tData[tEvent.table]
		if not tTable then
			tTable = {}
			self.tData[tEvent.table] = tTable
		end
		if '' == tEvent.json then
			tTable[tEvent.key] = nil
		else
			tTable[tEvent.key] = tEvent.json
			self:_Callback(tEvent.table, tEvent.key, tEvent.json)
		end
	end
end

--- 绑定
function public:Bind(func, sTableName, sTableKey, bindKey, iLevel)
	sTableKey = sTableKey or ''
	if not bindKey then
		self.iBindID = self.iBindID + 1
		bindKey = self.iBindID
	end
	iLevel = iLevel or 0
	local tCallback = self.tCallback[sTableName]
	if nil == tCallback then
		tCallback = {}
		self.tCallback[sTableName] = tCallback
	end
	if nil == tCallback[sTableKey] then
		tCallback[sTableKey] = {}
	end
	tCallback[sTableKey][bindKey] = {
		func = func,
		level = iLevel,
		bindKey = bindKey,
	}
	return bindKey
end

--- 绑定并触发一次(调用一次)
function public:BindDo(func, sTableName, sTableKey, bindKey, iLevel)
	if '' == sTableKey then
		local tTables = self:GetAllTableValues(sTableName)
		for _, v in pairs(tTables) do
			self:_call(func, bindKey, sTableName, v.key, v.value)
		end
	else
		local v = self:GetTableValue(sTableName, sTableKey)
		if nil ~= v then
			self:_call(func, bindKey, sTableName, sTableKey, v)
		end
	end
	return self:Bind(func, sTableName, sTableKey, bindKey, iLevel)
end

--- 解绑
function public:Unbind(bindKey)
	for sTableName, v in pairs(self.tCallback) do
		for sTableKey, v2 in pairs(v) do
			v2[bindKey] = nil
			return
		end
	end
end

--- 获取某Tabel全部Key数据
function public:GetAllTableValues(sTable)
	local tKVs = {}
	local tTabel = self.tData[sTable];
	if tTabel then
		for k, v in pairs(tTabel) do
			table.insert(tKVs, {
				key = k,
				value = json.decode(v),
			})
		end
	end
	return tKVs
end

--- 获取数据
function public:GetTableValue(sTable, sKey)
	local tTable = self.tData[sTable]
	if tTable then
		if tTable[sKey] then
			local val = json.decode(tTable[sKey])
			return val
		end
	end
end

---@private
function public:_Callback(sTableName, sTableKey, tData)
	local tTabel = self.tCallback[sTableName]
	if nil == tTabel then
		return
	end
	local funcs = {}
	local tCallback = tTabel[sTableKey]
	if tCallback then
		for i, v in pairs(tCallback) do
			table.insert(funcs, v)
		end
	end
	tCallback = tTabel[''];
	if tCallback then
		for i, v in pairs(tCallback) do
			table.insert(funcs, v)
		end
	end
	table.sort(funcs, function(a, b) return a.level < b.level end)
	for i = #funcs, 1, -1 do
		self:_call(funcs[i].func, funcs[i].bindKey, sTableName, sTableKey, json.decode(tData))
	end
end
---@private
function public:_call(fun, bindKey, ...)
	local bSuccess, result = xpcall(function(...)
		if type(bindKey) == 'table' then
			if type(fun) == 'string' then
				fun = bindKey[fun]
			end
			if type(fun) == 'function' then
				return fun(bindKey, ...)
			end
		else
			if type(fun) == 'function' then
				return fun(...)
			end
		end
	end, self._err, ...)
	if not bSuccess then
		return false
	end
	return result
end
---@private
function public._err(...)
	debug.traceback(...)
end

return public