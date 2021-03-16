_G.old_debug_traceback = old_debug_traceback or debug.traceback
if not _G.tErrorGsub then _G.tErrorGsub = {} end
if IsInToolsMode() then
	---报错处理
	debug.traceback = function(error, ...)
		local a = old_debug_traceback(error, ...)
		for k, v in pairs(_G.tErrorGsub) do
			a = string.gsub(a, k, v)
		end
		print("[debug error]:", a)
		return a
	end

	local src = debug.getinfo(3).source
	if src:sub(2):find("(.*dota 2 beta[\\/]game[\\/]dota_addons[\\/])([^\\/]+)[\\/]") then
		_G.GameDir, _G.AddonName = string.match(src:sub(2), "(.*dota 2 beta[\\/]game[\\/]dota_addons[\\/])([^\\/]+)[\\/]")
		_G.ContentDir = GameDir:gsub("\\game\\dota_addons\\", "\\content\\dota_addons\\")
	end
else
	if not _G.tError then _G.tError = {} end
	debug.traceback = function(error, ...)
		local a = old_debug_traceback(error, ...)
		for k, v in pairs(_G.tErrorGsub) do
			a = string.gsub(a, k, v)
		end
		local sMsg = tostring(error)
		DebugError('[VScript]: ' .. sMsg, a)
		return a
	end
end

ServerKey = GetDedicatedServerKeyV2("T3")
LogErrorKey = GetDedicatedServerKeyV2("ERROR")

-- _G.Service = require("service/init")
_G.json = require("game/dkjson")
require("lib/enum")
require("lib/md5")
require("lib/wearables")
require("lib/weight_pool")
require("core/utils")
require("core/kv")
require("core/event")
require("modifiers/init")
require("abilities/init")

function Initialize(bReload)
	_G.CustomUIEventListenerIDs = {}
	_G.GameEventListenerIDs = {}
	_G.Activated = true
	_G.iLoad = (_G.iLoad or 0) + 1

	Require({
		Request = "lib/request",
	}, bReload)

	require("core/StateMachine/StateManager")
	require("core/EventManager")

	Require({
		"service/init",
		"core/AttackSystem",
		"core/Attribute/AttributeSystem",
		"core/NetEventData",
	}, bReload)

	require("mods/init")

	-- Service:init(bReload)
	if not bReload then
		_G.ATTACK_EVENTS_DUMMY = CreateModifierThinker(nil, nil, "modifier_events", nil, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
	end

	--UI错误处理
	CustomUIEvent("DebugError", function(_, tEvent)
		DebugError('[Panorama]: ' .. tEvent.error_msg, tEvent.error_stack)
	end)

	CheckPerformance()
end

function Reload()
	local state = GameRules:State_Get()
	if state > DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		_ClearEventListenerIDs()

		--从磁盘数据中更新自定义英雄、单位、技能的键值
		GameRules:Playtesting_UpdateAddOnKeyValues()
		FireGameEvent("client_reload_game_keyvalues", {})

		local tUnits = Entities:FindAllByClassname("npc_dota_creature")
		for n, hUnit in pairs(tUnits) do
			if IsValid(hUnit) and hUnit:IsAlive() then
				for i = 0, hUnit:GetAbilityCount() - 1, 1 do
					local hAbility = hUnit:GetAbilityByIndex(i)
					if IsValid(hAbility) and hAbility:GetLevel() > 0 then
						if hAbility:GetIntrinsicModifierName() ~= nil and hAbility:GetIntrinsicModifierName() ~= "" then
							hUnit:RemoveModifierByName(hAbility:GetIntrinsicModifierName())
							hUnit:AddNewModifier(hUnit, hAbility, hAbility:GetIntrinsicModifierName(), nil)
						end
					end
				end
			end
		end

		print("Reload Scripts")

		Initialize(true)
	end
end

if Activated == true then
	Reload()
end

---加载模块组
function Require(requireList, bReload)
	for k, v in pairs(requireList) do
		InitClass(bReload, require(v), k, v)
	end
end
---初始化模块
function InitClass(bReload, hClass, sName, v)
	if "table" == type(hClass) then
		if 'string' == type(sName) then
			_G[sName] = hClass
		end
		if hClass.init ~= nil then
			print('init ', v)
			hClass:init(bReload)
		end
	end
end
---动态加载
function Dynamic_Load(tLoads, bReload)
	load(tLoads.main)(tLoads, bReload)
end
---错误处理，上传至服务器
function DebugError(sErrName, sErrMsg)
	if IsInToolsMode() then
		return
	end
	if not tError then tError = {} end
	if not tError[sErrName] then
		tError[sErrName] = pcall(function()
			local szURL = "http://dev.t3.eomgames.net/main.php?mod=Debug&action=debug_error_msg" .. "&cheat=" .. tostring(GameRules:IsCheatMode()) .. "&local=" .. tostring(not IsDedicatedServer())
			local handle = CreateHTTPRequest("POST", szURL)
			handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
			handle:SetHTTPRequestHeaderValue("Connection", "Keep-Alive")
			handle:SetHTTPRequestHeaderValue("Authorization", LogErrorKey)
			handle:SetHTTPRequestRawPostBody("application/json", json.encode({ name = sErrName, debug_msg = sErrMsg }))
			handle:SetHTTPRequestNetworkActivityTimeout(60 * 1000)
			handle:Send(function(response)
				-- response.StatusCode, response.Body, response
				if response.StatusCode ~= 200 then
					tError[sErrName] = nil
				end
			end)
		end)
	end
end

---注册UIEvent
function CustomUIEvent(eventName, func, context)
	table.insert(CustomUIEventListenerIDs, CustomGameEventManager:RegisterListener(eventName, function(...)
		if context ~= nil then
			return func(context, ...)
		end
		return func(...)
	end))
end
_G.CustomUIEvent = CustomUIEvent

---注册官方GameEvent
function GameEvent(eventName, func, context)
	table.insert(GameEventListenerIDs, ListenToGameEvent(eventName, func, context))
end
_G.GameEvent = GameEvent

function _ClearEventListenerIDs()
	for i = #CustomUIEventListenerIDs, 1, -1 do
		CustomGameEventManager:UnregisterListener(CustomUIEventListenerIDs[i])
	end
	for i = #GameEventListenerIDs, 1, -1 do
		StopListeningToGameEvent(GameEventListenerIDs[i])
	end
end

---性能相关监测
function CheckPerformance()
	if IsInToolsMode() then
		_G._CreateModifierThinker = _G._CreateModifierThinker or _G.CreateModifierThinker
		_G.CreateModifierThinker = function(hUnit, hAblt, sModifier, ...)
			local hThinker = _G._CreateModifierThinker(hUnit, hAblt, sModifier, ...)
			hThinker.sModifierName = sModifier
			local hBuff = hThinker:FindModifierByName(sModifier)
			local tDebugInfo = debug.getinfo(2)
			hThinker.tDebugInfo = tDebugInfo
			return hThinker
		end

		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("collectgarbage"), function()
			local m = collectgarbage('count')
			print(string.format("[Lua Memory]  %.3f KB  %.3f MB", m, m / 1024))
			print(string.format("[Hashtable Count]  %d", HashtableCount()))
			local tThinkers = Entities:FindAllByName("npc_dota_thinker")
			print(string.format("[Thinker Count]  %d", #tThinkers))
			for i = #tThinkers, 1, -1 do
				local hThinker = tThinkers[i]
				local tModifiers = hThinker:FindAllModifiers()
				if hThinker.tDebugInfo then
					print("[Thinker Info]", hThinker.sModifierName, hThinker.tDebugInfo.currentline, hThinker.tDebugInfo.source)
				end
			end
			return 30
		end, 0)
	else
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("collectgarbage"), function()
			local m = collectgarbage('count')
			print(string.format("[Lua Memory]  %.3f KB  %.3f MB", m, m / 1024))
			print(string.format("[Hashtable Count]  %d", HashtableCount()))
			local tThinkers = Entities:FindAllByName("npc_dota_thinker")
			print(string.format("[Thinker Count]  %d", #tThinkers))
			for i = #tThinkers, 1, -1 do
				local hThinker = tThinkers[i]
				local tModifiers = hThinker:FindAllModifiers()
				if #tModifiers == 0 then
					UTIL_Remove(hThinker)
					table.remove(tThinkers, i)
				end
			end
			return 60
		end, 0)
	end
end

for _, v in ipairs({ 'print', 'DeepPrintTable', 'PrintTable' }) do
	_G['_' .. v] = _G['_' .. v] or _G[v]
	local func = _G['_' .. v]
	_G[v] = function(...)
		if IsInToolsMode() then
			return func(...)
		end
	end
end