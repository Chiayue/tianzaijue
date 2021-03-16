if Recorder == nil then
	---@class Recorder 比赛后台数据记录
	Recorder = {
		tFPS = {},
		---@type table<number, table<string, table<string, any>>>
		tPlayerData = {}
	}
end

---@type Recorder 比赛后台数据记录
local public = Recorder

function public:Init(bReload)
	if not bReload then
	end

	CustomUIEvent("service_fps", Dynamic_Wrap(public, "On_service_fps"), public)
end

function public:InitPlayerInfo(iPlayerID)
	self.tPlayerData[iPlayerID] = {
		-- 回合数据临时记录
		iDrawCardCount = 0,
		iUseSpellCardCount = 0,
		tUseSpellCard = {},
		--- 后台记录用的回合数据
		tRoundData = {
			-- 初始数据
			match_id			= GetMatchID(),
			steamid				= GetAccountID(iPlayerID),
			-- 回合战斗开始保存数据
			round				= 0,
			level				= 0,
			building_count		= 0,
			start_health		= 0,
			start_mana			= 0,
			start_total_gold	= 0,
			start_total_crystal = 0,
			start_time			= 0,
			spell_cards			= {},
			items				= {},
			artifact			= {},
			-- 回合战斗结束保存数据
			end_health			= 0,
			end_mana			= 0,
			end_total_gold		= 0,
			end_total_crystal	= 0,
			end_time			= 0,
			building			= {},
			hand_cards			= {},
			-- 回合结算保存数据
			tax					= 0,
			miss_enemy			= 0,
			draw_card_count		= 0,
			use_spell_card_count = 0,
			use_spell_card		= 0,
			commander			= 0,
			tIngameItem		= {},
		},

		tAllRoundData = {}
	}
end

----------------------------------------------------------------------------------------------------
-- PBULIC 外部接口
function public:GameStart()
	if IsInToolsMode() or GameRules:IsCheatMode() or not IsDedicatedServer() then
		return 1
	end
	print("GameStart")
	Service:POST('recorder.game_init', {},
	function(data)
		if data then
			self.DotaMindAppId = data.data.id
			self.DotaMindSecret = data.data.secret

			self:ReqGameMindInfo()
		end
	end)
end
function public:GameEnd()
	print("GameEnd")
	self:ReqGameMindGameEnd()
end
----------------------------------------------------------------------------------------------------
-- PRIVATE 内部接口
function public:CaclGameMindSignature(data)
	local tData = {
		secret = self.DotaMindSecret,
		body = json.encode(data)
	}
	local signature = md5:sumhexa(json.encode(tData))
	return signature
end

function public:ReqGameMindInfo()
	local players = {}
	DotaTD:EachPlayer(function(_, iPlayerID)
		table.insert(players, GetAccountID(iPlayerID))
	end)

	local tData = {
		route = 'wisp.game.init',
		message = {
			appId = self.DotaMindAppId,
			matchId = tostring(GetMatchID()),
			map = GetMapName(),
			players = players,
		}
	}

	print('ReqGameMindInfo')


	-- do return end
	local handle = CreateHTTPRequest("POST", 'https://apidota.gamesmindai.com/wisp/handler')
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
	handle:SetHTTPRequestHeaderValue("Connection", "Keep-Alive")
	handle:SetHTTPRequestHeaderValue("signature", self:CaclGameMindSignature(tData))

	handle:SetHTTPRequestRawPostBody("application/json", json.encode(tData))

	handle:SetHTTPRequestNetworkActivityTimeout(60 * 1000)
	handle:Send(function(response)
		print('wisp.game.init')
		if response.StatusCode == 200 then
			local data = json.decode(response.Body)
			self.DotaMindTicket = data.ticket
		end
	end)
end
function public:ReqGameMindGameEnd()
	local tPlayerdata = {}
	local win = 1
	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:GetPlayerRoundResult(iPlayerID, Spawner:GetRound()) ~= 1 then
			win = 0
		end

		tPlayerdata[GetAccountID(iPlayerID)] = {
			player_talent = TalentGeneral.tPlayerTalents[iPlayerID],
			commander_talent = Commander.tTalentData[iPlayerID],
			card_group = self:GetPlayerUseCardGroupString(iPlayerID),
			courier = KeyValues.CourierKv[''] and KeyValues.CourierKv[''].ID or 1080001,
			commander = KeyValues.CommanderKv[PlayerData.playerDatas[iPlayerID].commander_name] and KeyValues.CommanderKv[PlayerData.playerDatas[iPlayerID].commander_name].ID or 1030000,
			round_data = self.tPlayerData[iPlayerID].tAllRoundData,
			difficulty = NetEventData:GetTableValue('service', 'player_adventure_progress_' .. iPlayerID),
			layer = NetEventData:GetTableValue('service', 'player_endless_layers_' .. iPlayerID),
		}
	end)

	local tMatchData = {
		match_id = tostring(GetMatchID()),
		version = VERSION,
		layer = GameMode:GetEndlessLayer(),
		difficulty = GameMode:GetDifficulty(),
		end_round = Spawner:GetRound(),
		win = win,
		player_data = tPlayerdata
	}

	Service:POST('recorder.game_post', tMatchData,
	function(data)
		print('recorder.game_post')
		if data then
			DeepPrintTable(data)
		end
	end)

	if IsInToolsMode() or GameRules:IsCheatMode() or not IsDedicatedServer() then
		return 1
	end

	local tData = {
		route = 'wisp.game.post',
		message = {
			appId = self.DotaMindAppId,
			ticket = self.DotaMindTicket,
			data = tMatchData
		}
	}

	local handle = CreateHTTPRequest("POST", 'https://apidota.gamesmindai.com/wisp/handler')
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
	handle:SetHTTPRequestHeaderValue("Connection", "Keep-Alive")
	handle:SetHTTPRequestHeaderValue("signature", self:CaclGameMindSignature(tData))

	handle:SetHTTPRequestRawPostBody("application/json", json.encode(tData))

	handle:SetHTTPRequestNetworkActivityTimeout(60 * 1000)
	handle:Send(function(response)
		print('wisp.game.post')
		if response.StatusCode == 200 then
			local data = json.decode(response.Body)
		end
	end)
end

function public:ReqGameFPS()
	local tData = {
		match_id = GetMatchID(),
		fps = json.encode(self.tFPS),
	}

	Service:POST('recorder.game_fps', tData, function(data)
		if data and data.status > -1 then
			print('[recorder]: game fps. match_id is ', GetMatchID())
		end
	end)
end
--- 玩家回合战斗开始
function public:PlayerStartRound(iPlayerID)
	if self.tPlayerData[iPlayerID] then
		local tRoundData = self.tPlayerData[iPlayerID].tRoundData
		tRoundData.round = Spawner:GetRound()
		tRoundData.level = GetPlayerLevel(iPlayerID) or 0
		tRoundData.building_count = PlayerBuildings:GetPlayerCurBuildCount(iPlayerID)
		tRoundData.start_health = GetPlayerHealth(iPlayerID)
		tRoundData.start_mana = GetPlayerMana(iPlayerID)
		tRoundData.start_total_gold = PlayerData:GetTotalGold(iPlayerID)
		tRoundData.start_total_crystal = PlayerData:GetTotalCrystal(iPlayerID)
		tRoundData.spell_cards = self:GetPlayerSpellCardString(iPlayerID)
		tRoundData.items = self:GetPlayerItemString(iPlayerID)
		tRoundData.artifact = self:GetPlayerArtifactString(iPlayerID)
		tRoundData.start_time = GetGameTime()
	end
end
--- 玩家回合战斗结束
function public:PlayerEndRound(iPlayerID)
	if self.tPlayerData[iPlayerID] then
		local tRoundData = self.tPlayerData[iPlayerID].tRoundData
		tRoundData.end_health = GetPlayerHealth(iPlayerID)
		tRoundData.end_mana = GetPlayerMana(iPlayerID)
		tRoundData.end_total_gold = PlayerData:GetTotalGold(iPlayerID)
		tRoundData.end_total_crystal = PlayerData:GetTotalCrystal(iPlayerID)
		tRoundData.building = self:GetPlayerBuildingString(iPlayerID)
		tRoundData.commander_damage = self:GetPlayerCommanderString(iPlayerID)
		tRoundData.end_time = GetGameTime()
		tRoundData.ingameitem = self.tPlayerData[iPlayerID].tIngameItem or {}
	end
end
--- 玩家回合结算，计算税金，回合奖励等。
function public:ReqPlayerRoundResult(iPlayerID, tData)
	if self.tPlayerData[iPlayerID] then
		local tRoundData = self.tPlayerData[iPlayerID].tRoundData

		tRoundData.draw_card_count = self:GetPlayerDrawCardCount(iPlayerID)
		tRoundData.use_spell_card_count = self:GetPalyerUseSpellCardCount(iPlayerID)
		tRoundData.use_spell_card = self:GetPlayerUseSpellCardData(iPlayerID)
		tRoundData.win = PlayerData:GetPlayerRoundResult(iPlayerID, tRoundData.round) or 0

		self:ResetPlayerRoundTempData(iPlayerID)

		tRoundData.hand_cards = self:GetPlayerHandCardString(iPlayerID)
		tRoundData.tax = tData.tax
		tRoundData.miss_enemy = tData.miss_enemy

		self.tPlayerData[iPlayerID].tAllRoundData = self.tPlayerData[iPlayerID].tAllRoundData or {}
		table.insert(self.tPlayerData[iPlayerID].tAllRoundData, copy(tRoundData))
	end
end

function public:PlayerUseIngameItem(iPlayerID, itemid)
	self.tPlayerData[iPlayerID].tIngameItem = self.tPlayerData[iPlayerID].tIngameItem or {}
	self.tPlayerData[iPlayerID].tIngameItem[itemid] = self.tPlayerData[iPlayerID].tIngameItem[itemid] or 0
	self.tPlayerData[iPlayerID].tIngameItem[itemid] = self.tPlayerData[iPlayerID].tIngameItem[itemid] + 1
end

----------------------------------------------------------------------------------------------------
-- PRIVATE 内部接口
function public:GetPlayerUseCardGroupString(iPlayerID)
	local group = {}
	local tData = GameMode:GetPlayerCardGroup(iPlayerID)
	if tData then
		for name, count in pairs(tData) do
			group[tostring(DotaTD:GetCardID(name))] = count
		end
	end
	return group
end
function public:GetPlayerBuildingString(iPlayerID)
	local tData = {}
	local tBuildingData = PlayerBuildings:GetData()
	if tBuildingData and tBuildingData[iPlayerID] and tBuildingData[iPlayerID].hero and tBuildingData[iPlayerID].hero.list then
		for k, v in pairs(tBuildingData[iPlayerID].hero.list) do
			local hUnit = EntIndexToHScript(v)
			if IsValid(hUnit) then
				local tAbility = {}
				for i = 0, 2 do
					local h = hUnit:GetAbilityByIndex(i)
					if IsValid(h) then
						table.insert(tAbility, {
							name = h:GetAbilityName(),
							level = h:GetLevel(),
						})
					end
				end

				local tItems = {}
				for iSlot, _ in pairs(ITEM_UNLOCK_LEVEL) do
					local hItem = hUnit:GetItemInSlot(iSlot)
					if IsValid(hItem) then
						table.insert(tItems, {
							id = KeyValues.ItemsKv[hItem:GetAbilityName()] and KeyValues.ItemsKv[hItem:GetAbilityName()].ID or 1050000,
							level = hItem:GetLevel(),
						})
					end
				end

				local tRoundDamage = PlayerData.playerRoundDamage[iPlayerID][Spawner:GetRound()]
				local damage_physical = math.floor(tRoundDamage[hUnit:GetUnitName()] and tRoundDamage[hUnit:GetUnitName()][DAMAGE_TYPE_PHYSICAL] or 0)
				local damage_magical = math.floor(tRoundDamage[hUnit:GetUnitName()] and tRoundDamage[hUnit:GetUnitName()][DAMAGE_TYPE_MAGICAL] or 0)
				local damage_pure = math.floor(tRoundDamage[hUnit:GetUnitName()] and tRoundDamage[hUnit:GetUnitName()][DAMAGE_TYPE_PURE] or 0)

				local iCardId = KeyValues.UnitsKv[hUnit:GetUnitName()] and KeyValues.UnitsKv[hUnit:GetUnitName()].ID
				table.insert(tData, {
					id = iCardId,
					level = hUnit:GetLevel(),
					ex_level = HeroCard:GetPlayerHeroCardLevel(iPlayerID, iCardId),
					abilities = tAbility,
					items = tItems,
					damage = {
						damage_physical = damage_physical,
						damage_magical = damage_magical,
						damage_pure = damage_pure,
						damage_total = damage_physical + damage_magical + damage_pure
					}
				})
			end
		end
	end

	return tData
end
function public:GetPlayerCommanderString(iPlayerID)
	local name = PlayerData.playerDatas[iPlayerID].commander_name

	local tRoundDamage = PlayerData.playerRoundDamage[iPlayerID][Spawner:GetRound()]
	local damage_physical = tRoundDamage and math.floor(tRoundDamage[name] and tRoundDamage[name][DAMAGE_TYPE_PHYSICAL] or 0) or 0
	local damage_magical = tRoundDamage and math.floor(tRoundDamage[name] and tRoundDamage[name][DAMAGE_TYPE_MAGICAL] or 0) or 0
	local damage_pure = tRoundDamage and math.floor(tRoundDamage[name] and tRoundDamage[name][DAMAGE_TYPE_PURE] or 0) or 0

	return {
		damage_physical = damage_physical,
		damage_magical = damage_magical,
		damage_pure = damage_pure,
		damage_total = damage_physical + damage_magical + damage_pure
	}
end
function public:GetPlayerHandCardString(iPlayerID)
	local tData = {}
	if HeroCardData.tHeroCardsData and HeroCardData.tHeroCardsData[iPlayerID] then
		local tPlayerData = HeroCardData.tHeroCardsData[iPlayerID]
		for k, v in pairs(tPlayerData) do
			table.insert(tData, {
				id = KeyValues.UnitsKv[v.sCardName] and KeyValues.UnitsKv[v.sCardName].ID,
				level = v.iLevel,
				xp = v.iXP,
				tax = v.iTax,
				gold = v.iGold,
				back_gold = v.iBackGold
			})
		end
	end
	return tData
end
function public:GetPlayerSpellCardString(iPlayerID)
	local tData = {}
	if HandSpellCards.tPlayerCards and HandSpellCards.tPlayerCards[iPlayerID] then
		local tPlayerData = HandSpellCards.tPlayerCards[iPlayerID]
		for k, v in pairs(tPlayerData) do
			table.insert(tData, {
				id = KeyValues.SpellKv[v.sCardName] and KeyValues.SpellKv[v.sCardName].Unique or 1070000,
				count = v.iCount
			})
		end
	end
	return tData
end
function public:GetPlayerItemString(iPlayerID)
	local tData = {}
	if Items.tPlayerItems and Items.tPlayerItems[iPlayerID] then
		local tPlayerData = Items.tPlayerItems[iPlayerID]
		for k, v in pairs(tPlayerData) do
			-- v.sItemName
			table.insert(tData, {
				id = KeyValues.ItemsKv[v.sItemName] and KeyValues.ItemsKv[v.sItemName].ID or 1050000,
				star = v.iStar,
				level = v.iLevel,
				star_bonus = v.iStarBonus,
			})
		end
	end
	return tData
end
function public:GetPlayerArtifactString(iPlayerID)
	local tData = {}
	if Artifact.tData and Artifact.tData[iPlayerID] then
		local tPlayerData = Artifact.tData[iPlayerID].tArtifacts
		for k, v in pairs(tPlayerData) do
			table.insert(tData, KeyValues.ArtifactKv[v.name] and KeyValues.ArtifactKv[v.name].UniqueID or 1060000)
		end
	end
	return tData
end
function public:ResetPlayerRoundTempData(iPlayerID)
	self.tPlayerData[iPlayerID].iDrawCardCount = 0
	self.tPlayerData[iPlayerID].iUseSpellCardCount = 0
	self.tPlayerData[iPlayerID].tUseSpellCard = {}
	self.tPlayerData[iPlayerID].tIngameItem = {}
end
function public:GetPlayerDrawCardCount(iPlayerID)
	return self.tPlayerData[iPlayerID].iDrawCardCount or 0
end
function public:RecordPlayerDrawCard(iPlayerID, iCount)
	iCount = iCount or 1
	if not self.tPlayerData[iPlayerID] then
		self.tPlayerData[iPlayerID] = {
			iDrawCardCount = 0
		}
	end
	self.tPlayerData[iPlayerID].iDrawCardCount = self.tPlayerData[iPlayerID].iDrawCardCount + iCount
end
function public:GetPalyerUseSpellCardCount(iPlayerID)
	return self.tPlayerData[iPlayerID].iUseSpellCardCount or 0
end
function public:GetPlayerUseSpellCardData(iPlayerID)
	return self.tPlayerData[iPlayerID].tUseSpellCard
end
function public:RecordPlayerUseSpellCard(iPlayerID, sCardName)
	table.insert(self.tPlayerData[iPlayerID].tUseSpellCard, KeyValues.SpellKv[sCardName] and KeyValues.SpellKv[sCardName].Unique or 1070000)
	self.tPlayerData[iPlayerID].iUseSpellCardCount = self.tPlayerData[iPlayerID].iUseSpellCardCount + 1
end

----------------------------------------------------------------------------------------------------
-- UIEVENT
---玩家客户端fps记录
function public:On_service_fps(eventSourceIndex, data)
	local iPlayerID = data.PlayerID
	local iFPS = data.fps
	local iFPS_S = math.floor(1 / FrameTime())
	local iGameTime = math.floor(GameRules:GetGameTime())

	if iPlayerID and PlayerResource:IsValidPlayer(iPlayerID) then
		self.tFPS[GetAccountID(iPlayerID)] = self.tFPS[GetAccountID(iPlayerID)] or {}
		local tPlayerFPS = self.tFPS[GetAccountID(iPlayerID)]
		tPlayerFPS[iGameTime] = {
			fps = iFPS,
			fps_s = iFPS_S,
			round = Spawner:GetRound(),
		}
	end
end