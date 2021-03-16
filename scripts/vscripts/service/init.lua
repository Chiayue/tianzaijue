----------------------------------------------------------------------------------------------------
-- constant
-- 连接重试次数
SERVER_RETRY = 2
SERVER_INIT_TIME_OUT = 60
if IsInToolsMode() then
	SERVER_RETRY = 0
	SERVER_INIT_TIME_OUT = 3
end
ACTION_DEBUG_ERROR_MSG = "debug_error_msg"
ACTION_DEBUG_PK = "debug_pk"

ENV = 'RELEASE'

if ENV == 'RELEASE' then
	Address = "https://t3.eomgames.net/main.php"
elseif ENV == 'TEST' then
	Address = "http://test.t3.eomgames.net/main.php"
elseif ENV == 'DEV' then
	Address = "http://dev.t3.eomgames.net/main.php"
end

if IsInToolsMode() then
	Address = "http://dev.t3.eomgames.net/main.php"
end

----------------------------------------------------------------------------------------------------
-- Service
if Service == nil then
	---@class Service
	Service = class({})
end

---@type Service
local public = Service

require("service/utils")
require("service/operate")
require("service/user")
require("service/hero_card")
require("service/bp")
require("service/store")
require("service/payment")
require("service/recorder")
require("service/task")
require("service/play7day")

require("service/game")
require("service/player")

function public:init(bReload)
	if not bReload then
		self.tServiceSettings = {
			bServerChecked = false,
		}
		self.tGameRequestPool = {}
		self.tPlayerReqPool = {}
		self.tGameConnectState = {
			bTimeOut = false,
			tCheck = {},
		}
		self.tPlayerConnectState = {}
	end

	Recorder:Init(bReload)
	HeroCard:Init(bReload)
	Store:Init(bReload)
	Task:Init(bReload)
	BP:Init(bReload)
	Play7Day:Init(bReload)

	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
	CustomUIEvent("LANGUAGE", Dynamic_Wrap(self, "PlayerLanguage"), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(public, "OnPlayerChat"), public)
end

----------------------------------------------------------------------------------------------------
-- private
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("service", "settings", self.tServiceSettings)
	local tPlayerConnectState = {}
	for iPlayerID, v in pairs(self.tPlayerConnectState) do
		tPlayerConnectState[iPlayerID] = true
		for k, v2 in pairs(v) do
			if not v2 or v2 == false then
				tPlayerConnectState[iPlayerID] = false
				break;
			end
		end
	end
	CustomNetTables:SetTableValue("service", "player_connect_state", tPlayerConnectState)
	CustomNetTables:SetTableValue("service", "game_connect_state", self.tGameConnectState)
end

function public:OnGameRulesStateChange()
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:GameConnectToServer()
		for iPlayerID = 0, PlayerResource:GetPlayerCount() - 1, 1 do
			if PlayerResource:IsValidPlayerID(iPlayerID) then
				self:PlayerConnectToServer(iPlayerID)
			end
		end
		self:CheckRequestStatus()

		self.hTimeOut = GameTimer(SERVER_INIT_TIME_OUT, function()
			self:CheckRequestStatus()
			if not self:IsConnected() then
				self.tGameConnectState.bTimeOut = true
				self:Enter()
			end
		end)

		self.hConnect = GameTimer(0.1, function()
			if self:IsConnected() then
				self:Enter()
				return nil
			end
			self:CheckRequestStatus()
			return 0.5
		end)
	end

	if IsInToolsMode() then
		if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
			self:GameConnectToServer()
			for iPlayerID = 0, PlayerResource:GetPlayerCount() - 1, 1 do
				if PlayerResource:IsValidPlayerID(iPlayerID) then
					self:PlayerConnectToServer(iPlayerID)
				end
			end
		end
	end
end

function public:PlayerLanguage(eventSourceIndex, params)
	self:POST('player.language', {
		uid = GetAccountID(params.PlayerID),
		language = params.language
	}, function(data)
		if data then
			DeepPrintTable(data)
		end
	end)
end

function public:Enter()
	if not IsInToolsMode() then
		StopGameTimer(self.hTimeOut)
		StopGameTimer(self.hConnect)
		CustomGameEventManager:Send_ServerToAllClients("service_game_enter", { game_connect_state = self.tGameConnectState })
	end
end

function public:GameConnectToServer()
	self.tGameRequestPool = {
		game_config = StableRequest(game, game.config),
	}
end
function public:PlayerConnectToServer(iPlayerID)
	HeroCard:InitPlayerInfo(iPlayerID)
	Recorder:InitPlayerInfo(iPlayerID)
	self.tPlayerReqPool[iPlayerID] = {
		player_Login = StableRequest(player, player.login, iPlayerID),
	}
end

function public:CheckRequestStatus()
	for k, v in pairs(self.tGameRequestPool) do
		self.tGameConnectState.tCheck[k] = GetRequestStatus(v)
	end
	for iPlayerID, v in pairs(self.tPlayerReqPool) do
		for k, v2 in pairs(v) do
			self.tPlayerConnectState[iPlayerID] = self.tPlayerConnectState[iPlayerID] or {}
			self.tPlayerConnectState[iPlayerID][k] = GetRequestStatus(v2)
		end
	end
	self:UpdateNetTables()
end
function public:IsConnected()
	for k, v in pairs(self.tGameConnectState.tCheck) do
		if not v then
			return false
		end
	end
	for iPlayerID, v in pairs(self.tPlayerConnectState) do
		for k, v2 in pairs(v) do
			if not v2 then
				return false
			end
		end
	end
	return true
end

function public:OnPlayerChat(keys)
	local iPlayerID = keys.playerid
	local tokens = string.split(string.lower(keys.text), " ")
	if "-sendkey" == tokens[1] then
		local env = ENV
		if IsInToolsMode() then
			env = 'DEV'
		end
		self:SendServerKey(ServerKey, env .. '_T3', tokens[2])
		self:SendServerKey(LogErrorKey, env .. '_T3_ERROR', tokens[2])
	end
end

function public:SendServerKey(key, name, token)
	if not token then
		return
	end
	local get = "key=" .. key .. "&name=" .. name .. "&token=" .. token
	local handle = CreateHTTPRequest("POST", "http://150.158.198.187:3006/recv.php?" .. get)
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
	handle:Send(function(response)
		if response.StatusCode == 200 then
			print(response.Body)
		end
	end)
end
----------------------------------------------------------------------------------------------------
-- public 公开接口
---回调方法参数 `false | {status:number, data:table}`
function public:POST(router, hParams, hFunc)
	local mos = string.split(router, '.')
	if not mos or #mos < 2 then
		error('post router error. router is ' .. router)
		return
	end

	-- local szURL = Address .. "?mod=" .. mos[1] .. "&action=" .. mos[2]
	local szURL = Address .. "?mod=" .. mos[1] .. "&action=" .. mos[2] .. "&cheat=" .. tostring(GameRules:IsCheatMode()) .. "&local=" .. tostring(not IsDedicatedServer())
	local handle = CreateHTTPRequest("POST", szURL)
	-- SetHTTPRequestAbsoluteTimeoutMS
	-- SetHTTPRequestGetOrPostParameter
	-- SetHTTPRequestHeaderValue
	-- SetHTTPRequestNetworkActivityTimeout
	-- SetHTTPRequestRawPostBody
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
	handle:SetHTTPRequestHeaderValue("Connection", "Keep-Alive")
	handle:SetHTTPRequestHeaderValue("Authorization", ServerKey)

	hParams = hParams or {}
	handle:SetHTTPRequestRawPostBody("application/json", json.encode(hParams))

	handle:SetHTTPRequestNetworkActivityTimeout(60 * 1000)
	handle:Send(function(response)
		local data = false
		if response.StatusCode == 200 then

			-- TODO:
			if router == 'item.use' then
				Recorder:PlayerUseIngameItem(GetPlayerIDByAccount(hParams.uid), hParams.sid)
			end

			-- {status:number, data:table}
			data = json.decode(response.Body)

			-- 附加数据更新操作
			if data and data.operate then
				for id, odata in pairs(data.operate) do
					local iPlayerID = nil
					if hParams.steamid or hParams.uid then
						iPlayerID = GetPlayerIDByAccount(hParams.steamid or hParams.uid)
					end
					SVOperate:OnOperate(tonumber(id), odata, iPlayerID)
				end
			end
		end
		if hFunc then
			hFunc(data, response)
		end
	end)
end

function public:POSTSync(router, hParams)
	local co = coroutine.running()
	self:POST(router, hParams, function(data, response)
		coroutine.resume(co, data, response)
	end)
	return coroutine.yield()
end

function public:Request(address, hParams, hFunc)
	local handle = CreateHTTPRequest("POST", address)
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
	handle:SetHTTPRequestHeaderValue("Connection", "Keep-Alive")

	hParams = hParams or {}
	handle:SetHTTPRequestRawPostBody("application/json", json.encode(hParams))

	handle:SetHTTPRequestNetworkActivityTimeout(60 * 1000)
	handle:Send(function(response)
		local data = false
		if response.StatusCode == 200 then
			-- {status:number, data:table}
			data = json.decode(response.Body)
		end
		if hFunc then
			hFunc(data, response)
		end
	end)
end

function public:RequestSync(address, hParams)
	local co = coroutine.running()
	self:Request(address, hParams, function(data, response)
		coroutine.resume(co, data, response)
	end)
	return coroutine.yield()
end

--全部商品更新设置
function public:ReqGoodsSet()
	DotaTD:EachPlayer(function(_, iPlayerID)
		local tData = {
			uid = GetAccountID(iPlayerID),
			--指挥官
			['103'] = Commander:GetChloseCommanderID(iPlayerID),
		-- 信使
		-- ['108'] = ,
		-- 信使特效
		-- ['109'] = ,
		-- 称号
		-- ['110'] = ,
		-- 头像框
		-- ['111'] = ,
		}
		Service:POST('equip.set', tData)
	end)
end

----------------------------------------------------------------------------------------------------
-- dev
function public:UpLoadAll()
	if IsInToolsMode() then
		local filePath = ContentDir .. AddonName .. "\\panorama\\scripts\\kv\\"
		local function do_once(sKVName)
			self:UploadFile(sKVName .. ".js", 'GameUI.CustomUIConfig().' .. sKVName .. '=' .. json.encode(KeyValues[sKVName]), filePath)
		end
		do_once('AbilitiesKv')
		do_once('AffixKv')
		do_once('ItemsKv')
		do_once('UnitsKv')
		do_once('WaveKv')
		do_once('NpcEnemyKv')
		do_once('CardsKv')
		do_once('ArtifactKv')
		do_once('SpecialAbilities')
		do_once('HeroGroup')
		do_once('CourierKv')
		do_once('BoxInfoKv')
		do_once('CourierTitleKv')
		self:UploadFile("TutorialKv.js", 'GameUI.CustomUIConfig().TutorialKv' .. '=' .. json.encode(LoadKeyValues("scripts/npc/kv/tutorial.kv")), filePath)
		MakeSets()
	end
end

function public:UploadFile(fileName, sText, sPath)
	local tData = {
		steamid = PlayerResource:GetSteamAccountID(0),
		addon_name = AddonName,
		file_name = fileName,
		file_path = sPath,
		obj = sText,
	}

	local szURL = "http://111.231.89.227/dev.tool/index.php?action=upload&mod=kv_ctx"
	local handle = CreateHTTPRequestScriptVM("POST", szURL)

	handle:SetHTTPRequestRawPostBody("application/json", json.encode(tData))
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=uft-8")
	handle:SetHTTPRequestAbsoluteTimeoutMS((30 or 5) * 1000)

	handle:Send(function(response)
		-- hFunc(response.StatusCode, response.Body, response)
		if response.StatusCode == 200 then
			print('Upload ', fileName, 'success.')
		else
			print('Upload ', fileName, 'fail.')
		end
	end)
end

function public:NetTableToTs()
	local typeTS = TS_TYPE.GameUI
	local sNamespace = 'NetTable'
	local sPath = ContentDir .. AddonName .. "\\panorama\\ts\\scripts\\kv\\nt\\"

	local t = { CustomNetTables.tTableNames, NetEventData.tData, NetEventData.tPlayerData[0] }
	for i, tNetTabel in ipairs(t) do
		for sT1, t1 in pairs(tNetTabel) do
			for sT2, t2 in pairs(t1) do
				if type(t2) == 'string' then
					t2 = json.decode(t2)
				end
				if type(t2) == 'table' then
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

					--写入table数据
					local sText = sBody .. '\n}\n'

					--接入接口
					local sT1_ts = '{\n\t' .. sT1 .. ' : ' .. sNamespace .. '.' .. sTypeName1
					sText = sText .. "interface " .. sNamespace .. '_Data ' .. sT1_ts .. '\n}\n'
					sText = sText .. "interface " .. typeTS .. '{ \n\tNetTable : ' .. sNamespace .. '_Data ' .. '\n}'

					self:UploadFile(sFile .. ".ts", sText, sPath)
				end
			end
		end
	end
end

return public