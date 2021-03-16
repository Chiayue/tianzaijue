if Draw == nil then
	---@class Draw
	Draw = {
		---玩家英雄卡池
		tPlayerCards = nil,
		---玩家当前的选卡列表 （英雄卡）
		tPlayerCardSelectionList = nil,
		---玩家抽卡时的Ban卡列表 （英雄卡）
		tPlayerBanHeroCardList = nil,

		---玩家法术卡池
		tPlayerSpellCards = nil,
		---玩家当前的选卡列表（法术卡）
		tPlayerSpellCardSelectionList = nil,
		---玩家抽卡时的Ban卡列表 （法术卡）
		tPlayerBanSpellCardList = nil,

		---玩家卡牌刷新时间
		tPlayerCardUpdateTime = nil,
		---玩家刷新点数
		tPlayerUpdatePoint = nil,

		---玩家幸运点数
		tPlayerLucky = nil,

		---各渠道抽取信息
		tData = nil,
		---稀有度权重池
		---@type WeightPool[]
		tReservoirs = nil,
		---卡牌权重池
		---@type WeightPool[][]
		tPlayerPools = nil,
		---修改器数据
		tModifyData = nil,
		---连续抽卡数
		tPlayerDrawCount = nil,
		---英雄卡牌权重池
		tHeroCardPools = nil,
	}
	Draw = class({}, Draw)
end
---@type Draw
local public = Draw

function public:init(bReload)
	if not bReload then
		self.tPlayerCardGroups = {}
		self.tPlayerCards = {}
		self.tPlayerCardSelectionList = {}
		self.tPlayerSpellCards = {}
		self.tPlayerSpellCardSelectionList = {}
		self.tPlayerBanHeroCardList = {}
		self.tPlayerBanSpellCardList = {}
		self.tPlayerCardUpdateTime = {}
		self.tPlayerPools = {}
		self.tPlayerLucky = {}
		self.tModifyData = {}
		self.tPlayerDrawCount = {}
	end
	-- 接入修改器类型
	self.tMDFType = {
		RefreshCostPercent = 1, -- 抽卡打折百分比
		RefreshCostConstant = 2, -- 抽卡打折固定值
	}

	--各渠道抽取信息
	self.tData = {}
	for sDrawName, keyValues in pairs(KeyValues.DrawKv) do
		local data = {
			number = keyValues.number,
			reservoir = keyValues.reservoir,
		}
		if keyValues.itemCost ~= nil then
			data.itemCost = string.split(keyValues.itemCost, " | ")
		end
		self.tData[sDrawName] = data
	end

	--抽卡权重池
	self.tReservoirs = {}
	for k, v in pairs(KeyValues.ReservoirsKv) do
		self.tReservoirs[k] = WeightPool(v)
	end
	if bReload then
		self:ChangeRoundDrawChance(Spawner:GetRound())
	end

	--加载英雄卡牌权重池
	self.tHeroCardPools = {}
	for sPoolName, t in pairs(KeyValues.HeroCardPoolKv) do
		if sPoolName == 'HeroCard_ALL' then
			t = {}
			for Rarity, tData in pairs(KeyValues.CardsKv) do
				for k, v in pairs(tData) do
					t[k] = 1
				end
			end
		end
		self.tHeroCardPools[sPoolName] = WeightPool(t)
	end

	CustomUIEvent("CardSelected", Dynamic_Wrap(public, "OnCardSelected"), public)
	CustomUIEvent("DebugSelectCard", Dynamic_Wrap(public, "OnDebugSelectCard"), public)
	CustomUIEvent("PlayerOperate_DrawCard", Dynamic_Wrap(public, "OnPlayerOperate_DrawCard"), public)

	EventManager:register(ET_BATTLE.ON_PREPARATION, 'OnPreparation', public, EVENT_LEVEL_NONE)

	Request:Event("item.use.DrawStartCard", Dynamic_Wrap(public, "UseItemDrawStartCard"), public)

	self.tFirstDraw = {}

	self:UpdateNetTables()
end
--UI事件************************************************************************************************************************
	do
	--选卡
	function public:OnCardSelected(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iSelectID = tonumber(events.iSelectID) or 0
		local sType = events.sType

		-- if PlayerData:IsBattling(iPlayerID) then
		-- 	ErrorMessage(iPlayerID, 'dota_hud_error_cant_operate_in_battleeing')
		-- 	return
		-- end
		-- 选卡清空连续抽卡点数
		self.tPlayerDrawCount[iPlayerID] = 0
		PlayerData:RefreshPlayerData()
		self:SelectCard(iPlayerID, iSelectID, sType == 'spellcard')
	end
	--图鉴选卡
	function public:OnDebugSelectCard(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local cardName = events.card_name or ""
		if not GameRules:IsCheatMode() then
			return
		end

		if not HeroCardData:AddCardByName(iPlayerID, cardName) then return end

		Notification:Combat({
			player_id = iPlayerID,
			string_unit_name = cardName,
			message = "#Custom_Draw",
		})

		if DotaTD:GetCardRarity(cardName) == "ssr" then
			Notification:Upper({
				player_id = iPlayerID,
				string_unit_name = cardName,
				message = "#Custom_Draw",
			})
			CustomGameEventManager:Send_ServerToAllClients("show_drawing", { name = cardName })
		elseif DotaTD:GetCardRarity(cardName) == "sr" then
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "show_drawing", { name = cardName })
		end
		self:UpdateNetTables()
	end
	--抽卡
	function public:OnPlayerOperate_DrawCard(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local sDrawName = events.draw_name
		sDrawName = 'round_draw_1'

		if PlayerData:IsPlayerDeath(iPlayerID) then
			return
		end

		-- if PlayerData:IsBattling(iPlayerID) then
		-- 	ErrorMessage(iPlayerID, 'dota_hud_error_cant_operate_in_battleeing')
		-- 	return
		-- end
		--没刷新点数消耗金币
		if 0 < self.tPlayerCardUpdateTime[iPlayerID].iCount then
		else
			local iDrawLevel = 1
			if sDrawName == 'round_draw_2' then
				iDrawLevel = 2
			elseif sDrawName == 'round_draw_3' then
				iDrawLevel = 3
			end
			local iGold = GET_DRAW_CARD_COST_GOLD(iPlayerID, iDrawLevel)
			if PlayerData:GetGold(iPlayerID) < iGold then
				ErrorMessage(iPlayerID, 'dota_hud_error_not_enough_gold')
				return
			end
			PlayerData:ModifyGold(iPlayerID, -iGold)
		end

		-- 增加连续抽卡点数
		self.tPlayerDrawCount[iPlayerID] = self.tPlayerDrawCount[iPlayerID] + 1
		PlayerData:RefreshPlayerData()
		EmitSoundForPlayer('T3.draw_reroll', iPlayerID)
		self:DrawCard(iPlayerID, sDrawName)
	end
end
--事件监听************************************************************************************************************************
	do
	--- 初始化玩家数据
	function public:InitPlayerData(iPlayerID)
		self.tPlayerBanHeroCardList[iPlayerID] = {}
		self.tPlayerBanSpellCardList[iPlayerID] = {}
		self.tPlayerCardSelectionList[iPlayerID] = {}
		self.tPlayerCardUpdateTime[iPlayerID] = {
			iCount = 0,
			timeRefresh = 0,
		}
		self.tPlayerLucky[iPlayerID] = {
			iLucky = 0,
			timeRefresh = 0,
		}
		self.tModifyData[iPlayerID] = {}
		self.tPlayerCards[iPlayerID] = {}
		self.tPlayerCardGroups[iPlayerID] = {}
		self.tPlayerPools[iPlayerID] = {}
		self.tPlayerDrawCount[iPlayerID] = 0

		self:UpdateNetTables()
	end
	--- 初始化玩家抽卡权重池
	function public:InitPlayerCardPools(iPlayerID)
		--获取玩家卡池
		self.tPlayerCards[iPlayerID] = {}
		local tCards = GameMode:GetPlayerCardGroup(iPlayerID)
		self.tPlayerCardGroups[iPlayerID] = tCards

		for sCardName, iCount in pairs(tCards) do
			local sRarity = DotaTD:GetCardRarity(sCardName)
			if sRarity then
				if nil == self.tPlayerCards[iPlayerID][sRarity] then self.tPlayerCards[iPlayerID][sRarity] = {} end
				self.tPlayerCards[iPlayerID][sRarity][sCardName] = iCount * GAME_CARD_RATE
			end
		end
		--初始化玩家抽卡权重池
		self.tPlayerPools[iPlayerID] = {}
		for sRarity, tCards in pairs(self.tPlayerCards[iPlayerID]) do
			self.tPlayerPools[iPlayerID]['pool_' .. sRarity] = WeightPool(tCards)
		end
		CustomNetTables:SetTableValue("common", "draw_hero_cards", self.tPlayerCards)

		--获取玩家技能卡池
		self.tPlayerSpellCards[iPlayerID] = {}
		local tCards = {}
		for sCardName, tV in pairs(KeyValues.SpellKv) do
			self.tPlayerSpellCards[iPlayerID][sCardName] = tV.MaxCount
		end

		self:UpdateNetTables()
	end

	--调整不同回合抽卡概率
	function public:ChangeRoundDrawChance(iRound)
		local tRoundData = KeyValues.WaveKv['round_' .. iRound]
		if tRoundData then

			local function doone(sRate, sPoolName)
				local tRate = string.split(sRate, '|')
				local hPool = WeightPool({})
				if tRate[1] then hPool:Add('pool_n', tonumber(tRate[1])) end
				if tRate[2] then hPool:Add('pool_r', tonumber(tRate[2])) end
				if tRate[3] then hPool:Add('pool_sr', tonumber(tRate[3])) end
				if tRate[4] then hPool:Add('pool_ssr', tonumber(tRate[4])) end
				self.tReservoirs[sPoolName] = hPool
			end
			doone(tRoundData.hero_card_draw_rate_1, 'round_draw_1')
			doone(tRoundData.hero_card_draw_rate_2, 'round_draw_2')
			doone(tRoundData.hero_card_draw_rate_3, 'round_draw_3')
			doone(tRoundData.lucky_draw_rate, 'lucky')
		end
	end

	--备战
	function public:OnPreparation(iRound)
		if 1 == Spawner:GetRound() then
			--第一回合开启抽卡刷新
			DotaTD:EachPlayer(function(_, iPlayerID)
				self:TimeingUpdatePoint(iPlayerID)
			end)
		end
		-- 每回合的免费刷新点数
		DotaTD:EachPlayer(function(_, iPlayerID)
			self:RoundUpdatePoint(iPlayerID)
		end)
	end

	---玩家死亡清理数据
	function public:OnPlayerDeath(iPlayerID)
		self.tPlayerCardSelectionList[iPlayerID] = {}
		self:UpdateNetTables()
	end
end
--事件监听************************************************************************************************************************
--
function public:UpdateNetTables()
	for iPlayerID, t in pairs(self.tPlayerCardSelectionList) do
		CustomNetTables:SetTableValue("common", "draw_list_player_" .. iPlayerID, t)
	end
	for iPlayerID, t in pairs(self.tPlayerSpellCardSelectionList) do
		CustomNetTables:SetTableValue("common", "draw_spellcard_list_player_" .. iPlayerID, t)
	end

	CustomNetTables:SetTableValue("common", "draw_card_update_time", self.tPlayerCardUpdateTime)
	CustomNetTables:SetTableValue("common", "draw_player_lucky", self.tPlayerLucky)
	CustomNetTables:SetTableValue("common", "draw_player_card_group", self.tPlayerCardGroups)
	-- CustomNetTables:SetTableValue("common", "deal_cards", self.tDealCards)
	-- CustomNetTables:SetTableValue("common", "player_redraw_chance", self.tReDrawChance)
	local tHeroCardPool = {}
	local tSpellCardPool = {}
	DotaTD:EachPlayer(function(n, iPlayerID)
		tHeroCardPool[iPlayerID] = self:GetKindCountInHeroPool(iPlayerID) - (self.tPlayerBanHeroCardList[iPlayerID] ~= nil and #self.tPlayerBanHeroCardList[iPlayerID] or 0) - (self.tPlayerCardSelectionList[iPlayerID] ~= nil and #self.tPlayerCardSelectionList[iPlayerID] or 0)
		if tHeroCardPool[iPlayerID] <= 0 then
			tHeroCardPool[iPlayerID] = self:GetKindCountInHeroPool(iPlayerID)
		end
		tSpellCardPool[iPlayerID] = self:GetKindCountInSpellPool(iPlayerID) - (self.tPlayerBanSpellCardList[iPlayerID] ~= nil and #self.tPlayerBanSpellCardList[iPlayerID] or 0) - (self.tPlayerSpellCardSelectionList[iPlayerID] ~= nil and #self.tPlayerSpellCardSelectionList[iPlayerID] or 0)
		if tSpellCardPool[iPlayerID] <= 0 then
			tSpellCardPool[iPlayerID] = self:GetKindCountInSpellPool(iPlayerID)
		end
	end)
	CustomNetTables:SetTableValue("common", "draw_player_hero_card_pool", tHeroCardPool)
	CustomNetTables:SetTableValue("common", "draw_player_spell_card_pool", tSpellCardPool)

	CustomNetTables:SetTableValue("common", "draw_player_isfirst", self.tFirstDraw)
end

function public:UseItemDrawStartCard(params)
	local iPlayerID = params.PlayerID
	local buyuse = params.buyuse
	local sid = params.sid
	local pid = params.pid

	local tData = {
		uid = GetAccountID(iPlayerID),
		sid = sid,
	}

	local data
	if buyuse == 1 then
		tData.pid = pid
		data = Service:POSTSync('item.buyuse', tData)
	else
		data = Service:POSTSync('item.use', tData)
	end

	if data and data.status == 0 then
		self:DrawStartCard(iPlayerID, (self.tFirstDraw[iPlayerID] or USEITEM_DRAW_FIRST) - 1)
	end

	return data
end

--- 开局抽卡
function public:DrawStartCard(iPlayerID, iRemainCount)
	self.tFirstDraw[iPlayerID] = iRemainCount or USEITEM_DRAW_FIRST

	local data = self.tData["builder_start_pick"]
	local tSelectionList = {}
	---忽略的卡牌，不重复
	local tIgnoreCards = {}
	--卡牌数量
	for i = 1, data.number, 1 do
		--抽取
		local sCardName = self:DrawReservoir(data.reservoir, iPlayerID, tIgnoreCards)
		if not sCardName then break end

		table.insert(tIgnoreCards, sCardName)
		local iDiscount = 100 - self:GetCardBuyDiscont(iPlayerID, sCardName)
		local iGold = DotaTD:GetCardGold(sCardName) * iDiscount * 0.01
		table.insert(tSelectionList, {
			sCardName = sCardName,
			iCount = 1,
			iGold = iGold,
			bPlus = (i == 1 or i == data.number) and 1 or 0
		})
	end

	self.tPlayerCardSelectionList[iPlayerID] = tSelectionList
	self:UpdateNetTables()
end

--- 抽卡
function public:DrawCard(iPlayerID, sDrawName, bIgnoreCostUpdateTime)
	self.tFirstDraw[iPlayerID] = 0

	if not bIgnoreCostUpdateTime and 0 < self.tPlayerCardUpdateTime[iPlayerID].iCount then
		--消耗刷新点数抽卡
		self.tPlayerCardUpdateTime[iPlayerID].iCount = self.tPlayerCardUpdateTime[iPlayerID].iCount - 1
		self:TimeingUpdatePoint(iPlayerID)
	end

	-- 不选的卡ban掉
	if 0 < self:GetPlayerSelectionHeroCardCount(iPlayerID) then
		for _, tSelectData in pairs(self.tPlayerCardSelectionList[iPlayerID]) do
			if 0 < tSelectData.iCount then
				table.insert(self.tPlayerBanHeroCardList[iPlayerID], tSelectData.sCardName)
			end
		end
	end
	if 0 < self:GetPlayerSelectionSpellCardCount(iPlayerID) then
		for _, tSelectData in pairs(self.tPlayerSpellCardSelectionList[iPlayerID]) do
			if 0 < tSelectData.iCount then
				table.insert(self.tPlayerBanSpellCardList[iPlayerID], tSelectData.sCardName)
			end
		end
	end

	-- 忽略满级英雄
	local tMaxHeroCards = HeroCardData:GetMaxLevelHeroCount(iPlayerID)
	local tIgnoreCards_Hero = tMaxHeroCards or {}
	local tIgnoreCards_Spell = {}

	local function hero_card_one(tSelectionList, sReservoir, tIgnoreCards)
		if (#self.tPlayerBanHeroCardList[iPlayerID] + #tMaxHeroCards) >= self:GetKindCountInHeroPool(iPlayerID) then
			self.tPlayerBanHeroCardList[iPlayerID] = {}
		end
		local sCardName = self:DrawReservoir(sReservoir, iPlayerID, concat(tIgnoreCards, self.tPlayerBanHeroCardList[iPlayerID]))
		if sCardName then
			table.insert(tIgnoreCards, sCardName)
			local iDiscount = 100 - self:GetCardBuyDiscont(iPlayerID, sCardName)
			local iGold = DotaTD:GetCardGold(sCardName) * iDiscount * 0.01
			local tData = {
				sCardName = sCardName,
				iCount = 1,
				iGold = iGold,
			}
			table.insert(tSelectionList, tData)
			return sCardName, tData
		end
	end
	local function spell_card_one(tSelectionList, sReservoir, tIgnoreCards)
		if #self.tPlayerBanSpellCardList[iPlayerID] >= self:GetKindCountInSpellPool(iPlayerID) then
			self.tPlayerBanSpellCardList[iPlayerID] = {}
		end
		local sCardName = self:DrawSpellCardPool(sReservoir, iPlayerID, concat(tIgnoreCards, self.tPlayerBanSpellCardList[iPlayerID]))
		if sCardName then
			table.insert(tIgnoreCards, sCardName)

			local tData = {
				sCardName = sCardName,
				iCount = 1,
				iGold = 0,
				iCrystal = 0,
			}

			--消耗魂晶还是金币
			local tKV = KeyValues.SpellKv[sCardName]
			if tKV and tKV.CrystalRate and RollPercentage(tonumber(tKV.CrystalRate)) then
				tData.iCrystal = DotaTD:GetSpellCardCrystal(sCardName)
			else
				tData.iGold = DotaTD:GetSpellCardGold(sCardName)
			end

			table.insert(self.tPlayerSpellCardSelectionList[iPlayerID], tData)
			return sCardName, tData
		end
	end

	local tDrawData_Hero = self.tData[sDrawName]
	local tDrawData_Spell = self.tData[sDrawName .. '_spellcard']

	-- 英雄卡
	self.tPlayerCardSelectionList[iPlayerID] = {}
	local function hero_card()
		for i = 1, tDrawData_Hero.number, 1 do
			local sCardName = hero_card_one(self.tPlayerCardSelectionList[iPlayerID], tDrawData_Hero.reservoir, tIgnoreCards_Hero)
			if not sCardName then
				--抽光了，抽法术卡
				for j = i, tDrawData_Hero.number, 1 do
					spell_card_one(self.tPlayerSpellCardSelectionList[iPlayerID], tDrawData_Spell.reservoir, tIgnoreCards_Spell)
				end
				break
			end
		end

		--有幸运点数额外抽取一个
		local tLucky = self.tPlayerLucky[iPlayerID]
		if 0 < tLucky.iLucky then
			local sCardName, tData = hero_card_one(self.tPlayerCardSelectionList[iPlayerID], 'lucky', tIgnoreCards_Hero)
			if sCardName then
				tData.iGold = 0
				tLucky.iLucky = tLucky.iLucky - 1
				if tLucky.iLucky + 1 == LUCKY_MAX then
					--重新开始幸运计时
					self:StartLuckyTime(iPlayerID)
				end
			end
		end
	end

	-- 法术卡
	self.tPlayerSpellCardSelectionList[iPlayerID] = {}
	local function spell_card()
		---忽略的卡牌，不重复
		for i = 1, tDrawData_Spell.number, 1 do
			local sCardName = spell_card_one(self.tPlayerSpellCardSelectionList[iPlayerID], tDrawData_Spell.reservoir, tIgnoreCards_Spell)
			if not sCardName then break end
		end
	end

	hero_card()
	spell_card()

	if 0 == #self.tPlayerCardSelectionList[iPlayerID] and 0 == #self.tPlayerSpellCardSelectionList[iPlayerID] then
		ErrorMessage(iPlayerID, '#dota_hud_error_draw_nothing')
	end

	---@class EventData_PlayerDrawCard
	local tEventData = {
		PlayerID = iPlayerID,
		tSpellCards = self.tPlayerSpellCardSelectionList[iPlayerID],
		tHeroCards = self.tPlayerCardSelectionList[iPlayerID],
	}
	EventManager:fireEvent(ET_PLAYER.ON_DRAW_CARD, tEventData)

	-- 自动买卡
	if HandHeroCards:IsPlayerAutoBuyCard(iPlayerID) then
		local tCanBuyCards = {}
		for iSelectID, tSelectData in pairs(self.tPlayerCardSelectionList[iPlayerID]) do
			local bHasCard = false
			-- 遍历手牌
			---@param hCard Card
			HeroCardData:EachCard(iPlayerID, function(hCard)
				if hCard.sCardName == tSelectData.sCardName and hCard.iLevel < HERO_MAX_LEVEL then
					bHasCard = true
					return true
				end
			end)
			-- 遍历场内英雄
			if not bHasCard then
				---@param hBuilding Building
				PlayerBuildings:EachBuilding(iPlayerID, function(hBuilding, iPlayerID, iEntIndex)
					if hBuilding:GetUnitEntityName() == tSelectData.sCardName and hBuilding:GetLevel() < HERO_MAX_LEVEL then
						bHasCard = true
						return true
					end
				end)
			end
			if bHasCard then
				if (not tSelectData.iGold or PlayerData:GetGold(iPlayerID) >= tSelectData.iGold)
				and (not tSelectData.iCrystal or PlayerData:GetCrystal(iPlayerID) >= tSelectData.iCrystal) then
					table.insert(tCanBuyCards, {
						iSelectID = iSelectID,
						tSelectData = tSelectData.sCardName,
					})
				end
			end
		end
		if 0 < #tCanBuyCards then
			local tRarity2Numb = {
				N = '1', R = '2', SR = '3', SSR = '4',
			}
			table.sort(tCanBuyCards, function(a, b)
				local iRarity1 = tRarity2Numb[string.upper(DotaTD:GetCardRarity(a.tSelectData.sCardName))] or 0
				local iRarity2 = tRarity2Numb[string.upper(DotaTD:GetCardRarity(b.tSelectData.sCardName))] or 0
				if iRarity1 > iRarity2 then
					return true
				end
				if iRarity1 == iRarity2 then
					return (a.tSelectData.iGold or 0) < (b.tSelectData.iGold or 0)
				end
				return false
			end)
			self:SelectCard(iPlayerID, tCanBuyCards[1].iSelectID, false)
		end
	end

	self:UpdateNetTables()
	Recorder:RecordPlayerDrawCard(iPlayerID)
end

--- 选卡
function public:SelectCard(iPlayerID, iSelectID, bSpellCard)
	if PlayerData:IsPlayerDeath(iPlayerID) then return end

	if bSpellCard then
		--法术卡
		local tSelectData = self.tPlayerSpellCardSelectionList[iPlayerID][iSelectID]
		if tSelectData then
			local sCardName = tSelectData.sCardName

			if HandSpellCards:GetPlayerHandCardKind(iPlayerID) >= HandSpellCards:GetPlayerMaxCardCategory(iPlayerID)
			and not HandSpellCards:HasCard(iPlayerID, sCardName)
			then
				ErrorMessage(iPlayerID, 'dota_hud_error_hand_spell_card_kind_limit')
				return
			end


			--消耗金币买卡
			local iGold = tSelectData.iGold
			local iCrystal = tSelectData.iCrystal

			if PlayerData:GetGold(iPlayerID) < iGold then
				ErrorMessage(iPlayerID, 'dota_hud_error_not_enough_gold')
				return
			end
			if PlayerData:GetCrystal(iPlayerID) < iCrystal then
				ErrorMessage(iPlayerID, 'dota_hud_error_not_enough_crystal')
				return
			end

			if 0 >= tSelectData.iCount then
				return
			end
			--归零所有法术卡数量
			for _, tSelectData in pairs(self.tPlayerSpellCardSelectionList[iPlayerID]) do
				tSelectData.iCount = 0
			end
			--清除ban卡数据
			self.tPlayerBanSpellCardList[iPlayerID] = {}

			if 0 ~= iGold then
				PlayerData:ModifyGold(iPlayerID, -iGold)
			end
			if 0 ~= iCrystal then
				PlayerData:ModifyCrystal(iPlayerID, -iCrystal)
			end

			HandSpellCards:AddCard(iPlayerID, sCardName)

			--消耗卡池
			self:ModifySpellCardCountInPlayerPool(iPlayerID, sCardName, -1)
		end
	else
		--英雄卡
		local tSelectData = self.tPlayerCardSelectionList[iPlayerID][iSelectID]
		if tSelectData then
			local sCardName = tSelectData.sCardName

			if tSelectData.bPlus and tSelectData.bPlus == 1 and not (0 < (NetEventData:GetTableValue('service', 'player_vip_' .. iPlayerID) or 0)) then
				ErrorMessage(iPlayerID, 'dota_hud_error_not_vip')
				return
			end

			--消耗金币买卡
			local iGold = tSelectData.iGold
			if PlayerData:GetGold(iPlayerID) < iGold then
				ErrorMessage(iPlayerID, 'dota_hud_error_not_enough_gold')
				return
			end

			if 0 >= tSelectData.iCount then
				return
			end

			if HeroCardData:GetMaxHeroCardCount(iPlayerID) <= HeroCardData:GetPlayerHeroCardsCount(iPlayerID) then
				--手牌满了又有相同卡牌在手，自动升级
				---@type Card
				local hCard
				HeroCardData:EachCard(iPlayerID, function(hCard2)
					if hCard2.sCardName == sCardName then
						hCard = hCard2
						return true
					end
				end)
				if hCard then
					-- 手牌有卡给手牌升级
					HeroCardData:LevelUpCard(iPlayerID, hCard, 1)
				else
					local bHasBuilding = false
					---@param hBuilding Building
					PlayerBuildings:EachBuilding(iPlayerID, function(hBuilding)
						if hBuilding:GetUnitEntityName() == sCardName then
							-- 场内有卡
							bHasBuilding = true
							BuildSystem:AddExperience(hBuilding:GetUnitEntity(), nil, 1)
							return true
						end
					end)
					if not bHasBuilding then
						if not HeroCardData:AddCardByName(iPlayerID, sCardName) then return end
					end
				end
			else
				if not HeroCardData:AddCardByName(iPlayerID, sCardName) then return end
			end

			--归零所有英雄卡数量
			for _, tSelectData in pairs(self.tPlayerCardSelectionList[iPlayerID]) do
				tSelectData.iCount = 0
			end
			--清除ban卡数据
			self.tPlayerBanHeroCardList[iPlayerID] = {}

			PlayerData:ModifyGold(iPlayerID, -iGold)

			--抽卡消息
			Notification:Combat({
				player_id = iPlayerID,
				string_unit_name = sCardName,
				message = "#Custom_Draw",
			})
			if DotaTD:GetCardRarity(sCardName) == "ssr" then
				Notification:Upper({
					player_id = iPlayerID,
					string_unit_name = sCardName,
					message = "#Custom_Draw",
				})
				CustomGameEventManager:Send_ServerToAllClients("show_drawing", { name = sCardName })
			elseif DotaTD:GetCardRarity(sCardName) == "sr" then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "show_drawing", { name = sCardName })
			end

			--消耗卡池
			self:ModifyCardCountInPlayerPool(iPlayerID, sCardName, -1)
			---@class EventData_PlayerHeroCardBuyInDraw
			local tEventData = {
				PlayerID = iPlayerID,
				sCardName = sCardName,
			}
			EventManager:fireEvent(ET_PLAYER.ON_HERO_CARD_BUY_IN_DRAW, tEventData)

			-- 选卡清空连续抽卡点数
			self.tPlayerDrawCount[iPlayerID] = 0
			-- 首抽次数改为0
			self.tFirstDraw[iPlayerID] = 0
			PlayerData:RefreshPlayerData()
		end
	end

	-- 抽光了
	if 0 >= self:GetPlayerSelectionCardCount(iPlayerID) then
		self.tPlayerCardSelectionList[iPlayerID] = {}
		self.tPlayerSpellCardSelectionList[iPlayerID] = {}

		--消耗刷新点数抽卡
		if 0 < self.tPlayerCardUpdateTime[iPlayerID].iCount then
			self.tPlayerCardUpdateTime[iPlayerID].iCount = self.tPlayerCardUpdateTime[iPlayerID].iCount - 1
			self:TimeingUpdatePoint(iPlayerID)
			self:DrawCard(iPlayerID, 'round_draw_1', true)
		end
	else
	end
	-- 重置法术卡列表和英雄卡列表
	self.tPlayerCardSelectionList[iPlayerID] = {}
	self.tPlayerSpellCardSelectionList[iPlayerID] = {}
	self:UpdateNetTables()
end

---是否有可选卡牌
function public:HasSelectCard(iPlayerID, sCardName)
	local t = self.tPlayerCardSelectionList[iPlayerID]
	for _, v in pairs(t) do
		if sCardName == v.sCardName then
			return true
		end
	end
	return false
end

---开始幸运值计时
function public:StartLuckyTime(iPlayerID)
	if 0 >= LUCKY_REFRESH_TIME then return end

	for _iPlayerID, t in pairs(self.tPlayerLucky) do
		if nil == iPlayerID or _iPlayerID == iPlayerID then
			local tLucky = t
			local iPlayerID2 = _iPlayerID
			if not tLucky.bNoTimeRefresh then
				tLucky.timeRefresh = GameRules:GetGameTime() + LUCKY_REFRESH_TIME
				GameTimer('StartLuckyTime' .. iPlayerID2, LUCKY_REFRESH_TIME, function()
					if tLucky.bNoTimeRefresh then return end
					tLucky.iLucky = tLucky.iLucky + 1
					if tLucky.iLucky < LUCKY_MAX then
						tLucky.timeRefresh = GameRules:GetGameTime() + LUCKY_REFRESH_TIME
						self:UpdateNetTables()
						return LUCKY_REFRESH_TIME
					end
					self:UpdateNetTables()
				end)
			end
		end
	end
	self:UpdateNetTables()
end

---计时刷新点数
function public:TimeingUpdatePoint(iPlayerID)
	if 0 >= DRAW_CARD_UPDATE_TIME then
		return
	end

	if self.tPlayerCardUpdateTime[iPlayerID].timeRefresh > GameRules:GetGameTime() then
		return
	end

	self.tPlayerCardUpdateTime[iPlayerID].timeRefresh = GameRules:GetGameTime() + DRAW_CARD_UPDATE_TIME
	GameTimer('draw_update_' .. iPlayerID, DRAW_CARD_UPDATE_TIME, function()
		self.tPlayerCardUpdateTime[iPlayerID].timeRefresh = GameRules:GetGameTime() + DRAW_CARD_UPDATE_TIME
		if 0 >= self:GetPlayerSelectionCardCount(iPlayerID) then
			--直接刷新
			self:DrawCard(iPlayerID, 'round_draw_1')
		else
			--积攒点数
			self.tPlayerCardUpdateTime[iPlayerID].iCount = self.tPlayerCardUpdateTime[iPlayerID].iCount + 1
			if DRAW_CARD_UPDATE_COUNT_MAX(iPlayerID) <= self.tPlayerCardUpdateTime[iPlayerID].iCount then
				--达到上限
				self.tPlayerCardUpdateTime[iPlayerID].timeRefresh = 0
				self:UpdateNetTables()
				return
			end
			self:UpdateNetTables()
		end
		return DRAW_CARD_UPDATE_TIME
	end)
	self:UpdateNetTables()
end
---回合刷新点数
function public:RoundUpdatePoint(iPlayerID)
	local iCount = DRAW_CARD_UPDATE_ROUND(iPlayerID)
	if 0 >= iCount then return end

	if 0 >= self:GetPlayerSelectionCardCount(iPlayerID) then
		iCount = iCount - 1
		--直接刷新
		self:DrawCard(iPlayerID, 'round_draw_1')
		if 0 >= iCount then return end
	end

	--积攒点数
	self.tPlayerCardUpdateTime[iPlayerID].iCount = math.min(DRAW_CARD_UPDATE_COUNT_MAX(iPlayerID), self.tPlayerCardUpdateTime[iPlayerID].iCount + iCount)
	if DRAW_CARD_UPDATE_COUNT_MAX(iPlayerID) <= self.tPlayerCardUpdateTime[iPlayerID].iCount then
		--达到上限，停止时间计时
		StopGameTimer('draw_update_' .. iPlayerID)
	end
	self:UpdateNetTables()
end

-- 抽奖堆
function public:DrawReservoir(sReservoirName, iPlayerID, tIgnoreCards)
	---@param hReservoir WeightPool
	local function do_once(hReservoir)
		if hReservoir then
			local tCardWeight = {}
			for sPoolName, iVal in pairs(hReservoir.tList) do
				---@type WeightPool
				local hPool = self:GetCardPool(iPlayerID, sPoolName)
				if hPool then
					for sCardName, iCount in pairs(hPool.tList) do
						if not exist(tIgnoreCards, sCardName) then
							local fChancePct = self:GetDrawCardChancePercentage(iPlayerID, sCardName, sReservoirName)
							-- tCardWeight[sCardName] = iCount * iVal * (fChancePct * 0.01)
							tCardWeight[sCardName] = iVal * (fChancePct * 0.01)
						end
					end
				end
			end
			local hCardPool = WeightPool(tCardWeight)
			-- hCardPool:SwitchDebugLog(true)
			local sCard = hCardPool:Random()
			return sCard
		end
	end
	if not self.tReservoirs[sReservoirName] then
		sReservoirName = 'default'
	end
	return do_once(self.tReservoirs[sReservoirName])
end
-- 抽奖池
function public:DrawPool(sPoolName, iPlayerID, tIgnoreCards)
	local hPool = self:GetCardPool(iPlayerID, sPoolName)
	if hPool then
		--排除忽略卡牌
		if tIgnoreCards and 0 < #tIgnoreCards then
			hPool = WeightPool(hPool.tList)
			hPool:RemoveByTable(tIgnoreCards)
		end
		return hPool:Random()
	end
end
function public:GetCardPool(iPlayerID, sPoolName)
	--个人独立卡池
	return self.tPlayerPools[iPlayerID][sPoolName]
end

-- 向法术卡牌池内抽卡
function public:DrawSpellCardPool(sReservoirName, iPlayerID, tIgnoreCards)
	local tCards = self.tPlayerSpellCards[iPlayerID]
	local tIgnoreLock = self:GetPlayerLockSpell(iPlayerID)

	---获取一张卡的权重
	function get_weight_val(sCardName)
		if 'ui_draw_spellcard' == sReservoirName then
			--取KV
			local tKV = KeyValues.SpellKv[sCardName]
			if tKV then
				return tonumber(tKV.DrawWeight) or 0
			end
		else
			local hSpellCardReservoirs = self.tReservoirs[sReservoirName]
			if not hSpellCardReservoirs then
				sReservoirName = 'ui_draw_spellcard'
				return get_weight_val(sCardName)
			end
			return tonumber(hSpellCardReservoirs[sCardName]) or 0
		end
		return 0
	end

	---生成卡池内剩余卡牌权重
	local tCardWeight = {}
	for sCardName, iCount in pairs(tCards) do
		if not exist(tIgnoreCards, sCardName)
		and not exist(tIgnoreLock, sCardName)
		then
			tCardWeight[sCardName] = iCount * get_weight_val(sCardName)
		end
	end
	local hCardPool = WeightPool(tCardWeight)
	return hCardPool:Random()
end
---获取玩家未解锁的法术卡数组
function public:GetPlayerLockSpell(iPlayerID)
	local t = NetEventData:GetTableValue('service', 'player_spell_' .. iPlayerID)
	if t then
		-- id转name
		local t2 = {}
		for _, sItemID in pairs(t) do
			local sItemName = HandSpellCards:GetCardNameByGoodsID(sItemID)
			if sItemName then
				t2[sItemName] = true
			end
		end
		-- 反选未解锁
		t = {}
		for sItemName, v in pairs(KeyValues.SpellKv) do
			if type(v) == 'table' and v.Unique and not t2[sItemName] then
				-- 未解锁物品
				table.insert(t, sItemName)
			end
		end
		return t
	end

	-- 未获取到玩家解锁数据，使用默认配置
	if nil == self._GetPlayerLockSpell_DefaultItems then
		t = {}
		self._GetPlayerLockSpell_DefaultItems = t
		local tDefaultItem = LoadKeyValues("scripts/npc/kv/default_items.kv") or {}
		for sItemName, v in pairs(KeyValues.SpellKv) do
			if type(v) == 'table' and v.Unique and not tDefaultItem[sItemName] then
				-- 非默认物品
				table.insert(t, sItemName)
			end
		end
	end
	return self._GetPlayerLockSpell_DefaultItems
end

--- 获取玩家卡池卡牌种类数量 (英雄卡)
function public:GetKindCountInHeroPool(iPlayerID)
	local iCount = 0
	if self.tPlayerPools[iPlayerID] ~= nil then
		for _, tPool in pairs(self.tPlayerPools[iPlayerID]) do
			for _, iWeight in pairs(tPool.tList) do
				if 0 < iWeight then
					iCount = iCount + 1
				end
			end
		end
	end
	return iCount
end
--- 获取玩家卡池卡牌种类数量 (法术卡)
function public:GetKindCountInSpellPool(iPlayerID)
	local tIgnoreLock = self:GetPlayerLockSpell(iPlayerID)

	local iCount = 0
	if self.tPlayerSpellCards[iPlayerID] ~= nil then
		for sCardName, iCount2 in pairs(self.tPlayerSpellCards[iPlayerID]) do
			if not exist(tIgnoreLock, sCardName) then
				if 0 < iCount2 then
					local tKV = KeyValues.SpellKv[sCardName]
					if tKV and 0 < tKV.DrawWeight then
						iCount = iCount + 1
					end
				end
			end
		end
	end
	return iCount
end

--- 获取玩家卡池内某张卡的数量
function public:GetCardCountInPlayerPool(iPlayerID, sCardName)
	local iCount = 0
	local sRarity = string.lower(DotaTD:GetCardRarity(sCardName))
	local tPool = self.tPlayerPools[iPlayerID]['pool_' .. sRarity]
	if tPool then
		iCount = tPool:Get(sCardName)
	end
	return iCount
end
--- 修改在玩家卡池内某张卡数量
function public:ModifyCardCountInPlayerPool(iPlayerID, sCardName, iCount)
	local sRarity = string.lower(DotaTD:GetCardRarity(sCardName))
	local tPool = self.tPlayerPools[iPlayerID]['pool_' .. sRarity]
	if tPool then
		tPool:Add(sCardName, iCount)
	end

	local iCountHas = self:GetCardCountInPlayerPool(iPlayerID, sCardName)
	if 0 == iCountHas then
		--移除抽卡列表内不足数量的卡牌
		local iDel = 0
		for i, tList in pairs(self.tPlayerCardSelectionList[iPlayerID]) do
			if tList.sCardName == sCardName then
				iDel = iDel + 1
				tList.iCount = 0
			end
		end

		--移除后抽卡列表空了，用刷新点数抽卡
		if 0 < iDel then
			if 0 >= self:GetPlayerSelectionCardCount(iPlayerID) then
				if 0 < self.tPlayerCardUpdateTime[iPlayerID].iCount then
					--消耗刷新点数抽卡
					self.tPlayerCardUpdateTime[iPlayerID].iCount = self.tPlayerCardUpdateTime[iPlayerID].iCount - 1
					self:TimeingUpdatePoint(iPlayerID)
					self:DrawCard(iPlayerID, 'round_draw_1', true)
				end
			end

			self:UpdateNetTables()
		end
	end
end
--- 修改在玩家卡池内某张卡数量（法术卡）
function public:ModifySpellCardCountInPlayerPool(iPlayerID, sCardName, iCount)
	local tCards = self.tPlayerSpellCards[iPlayerID]
	tCards[sCardName] = math.max(0, tCards[sCardName] + iCount)

	if 0 >= tCards[sCardName] then
		--移除抽卡列表内不足数量的卡牌
		local iDel = 0
		for i, tList in pairs(self.tPlayerSpellCardSelectionList[iPlayerID]) do
			if tList.sCardName == sCardName then
				iDel = iDel + 1
				tList.iCount = 0
			end
		end

		--移除后抽卡列表空了，用刷新点数抽卡
		if 0 < iDel then
			if 0 >= self:GetPlayerSelectionCardCount(iPlayerID) then
				if 0 < self.tPlayerCardUpdateTime[iPlayerID].iCount then
					--消耗刷新点数抽卡
					self.tPlayerCardUpdateTime[iPlayerID].iCount = self.tPlayerCardUpdateTime[iPlayerID].iCount - 1
					self:TimeingUpdatePoint(iPlayerID)
					self:DrawCard(iPlayerID, 'round_draw_1', true)
				end
			end

			self:UpdateNetTables()
		end
	end
end

---获取玩家抽卡列表内可选卡牌数量 （英雄卡+法术卡）
function public:GetPlayerSelectionCardCount(iPlayerID)
	return self:GetPlayerSelectionHeroCardCount(iPlayerID) + self:GetPlayerSelectionSpellCardCount(iPlayerID)
end
---获取玩家抽卡列表内可选卡牌数量 （英雄卡）
function public:GetPlayerSelectionHeroCardCount(iPlayerID)
	local iCount = 0
	if self.tPlayerCardSelectionList[iPlayerID] then
		for k, v in pairs(self.tPlayerCardSelectionList[iPlayerID]) do
			iCount = v.iCount + iCount
		end
	end

	return iCount
end
---获取玩家抽卡列表内可选卡牌数量 （法术卡）
function public:GetPlayerSelectionSpellCardCount(iPlayerID)
	local iCount = 0
	if self.tPlayerSpellCardSelectionList[iPlayerID] then
		for k, v in pairs(self.tPlayerSpellCardSelectionList[iPlayerID]) do
			iCount = v.iCount + iCount
		end
	end
	return iCount
end

--- 修改玩家抽卡折扣百分比
function public:GetModifierCardRefreshCostPercent(hSource, func)
	local iPlayerID = hSource:GetPlayerID()
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData ~= nil then
		tPlayerModifyData[self.tMDFType.RefreshCostPercent] = tPlayerModifyData[self.tMDFType.RefreshCostPercent] or {}
		local tModify = tPlayerModifyData[self.tMDFType.RefreshCostPercent]
		if tModify[hSource] ~= func then
			tModify[hSource] = func
			self:UpdateNetTables()
		end
	end
end
--- 获取玩家抽卡折扣百分比
function public:GetPlayerFixedCardRefreshCostPercent(iPlayerID)
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData == nil then
		return false
	end
	--- 是否需要修改
	local bResult = false

	local tModify = tPlayerModifyData[self.tMDFType.RefreshCostPercent]
	if tModify ~= nil then
		local iPercent = 0
		for hSource, func in pairs(tModify) do
			if hSource and func then
				local iPct = tonumber(func(hSource))
				if iPct then
					bResult = true
					iPercent = iPercent + iPct
				end
			end
		end
		if bResult then
			return iPercent
		end
	end
	return bResult
end

--- 修改玩家抽卡折扣固定值
function public:GetModifierCardRefreshCostConstant(hSource, func)
	local iPlayerID = hSource:GetPlayerID()
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData ~= nil then
		tPlayerModifyData[self.tMDFType.RefreshCostConstant] = tPlayerModifyData[self.tMDFType.RefreshCostConstant] or {}
		local tModify = tPlayerModifyData[self.tMDFType.RefreshCostConstant]
		if tModify[hSource] ~= func then
			tModify[hSource] = func
			self:UpdateNetTables()
		end
	end
end
--- 获取玩家抽卡折扣固定值
function public:GetPlayerFixedCardRefreshCostConstant(iPlayerID)
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData == nil then
		return false
	end
	--- 是否需要修改
	local bResult = false

	local tModify = tPlayerModifyData[self.tMDFType.RefreshCostConstant]
	if tModify ~= nil then
		local iConstant = 0
		for hSource, func in pairs(tModify) do
			if hSource and func then
				local iPct = tonumber(func(hSource))
				if iPct then
					bResult = true
					iConstant = iConstant + iPct
				end
			end
		end
		if bResult then
			return iConstant
		end
	end
	return bResult
end

--修改器----------------------------------------------------------------
--- 修改买卡折扣百分比
function public:GetModifierCardBuyDiscont(hSource, func)
	local iPlayerID = hSource:GetPlayerID()
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData ~= nil then
		tPlayerModifyData.CardGoldBuyDiscount = tPlayerModifyData.CardGoldBuyDiscount or {}
		local tModify = tPlayerModifyData.CardGoldBuyDiscount
		if tModify[hSource] ~= func then
			tModify[hSource] = func
			self:UpdateNetTables()
		end
	end
end

--- 获取买卡折扣百分比
function public:GetCardBuyDiscont(iPlayerID, sCardName)
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData == nil then
		return 0
	end

	local iDiscount = 0
	local tModify = tPlayerModifyData.CardGoldBuyDiscount
	if tModify ~= nil then
		for hSource, func in pairs(tModify) do
			if hSource and func then
				local c = tonumber(func(hSource, sCardName))
				if iDiscount then
					iDiscount = iDiscount + c
				end
			end
		end
	end
	return iDiscount
end


---获取英雄抽卡额外概率权重
function public:GetDrawCardChancePercentage(iPlayerID, sCardName, sReservoirName)
	local fPct = 100
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_DRAW_CARD_CHANCE_PERCENTAGE, iPlayerID, sCardName, sReservoirName)) do
		local iVal = tonumber(tVals[1]) or 0
		if type(key) == 'table' then
			---@type eom_modifier
			local hBuff = key
			if hBuff:GetPlayerID() ~= iPlayerID then
				iVal = 0
			end
		end
		fPct = iVal + fPct
	end
	return fPct
end
if not EModifier:HasModifier(EMDF_DRAW_CARD_CHANCE_PERCENTAGE) then EModifier:CreateModifier(EMDF_DRAW_CARD_CHANCE_PERCENTAGE) end

---获取装备物品抽卡额外概率权重
function GetDrawItemChancePercentage(iPlayerID, sCardName, sReservoirName)
	local fPct = 100
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_DRAW_ITEM_CHANCE_PERCENTAGE, iPlayerID, sCardName, sReservoirName)) do
		local iVal = tonumber(tVals[1]) or 0
		if type(key) == 'table' then
			---@type eom_modifier
			local hBuff = key
			if hBuff:GetPlayerID() ~= iPlayerID then
				iVal = 0
			end
		end
		fPct = iVal + fPct
	end
	return fPct
end
if not EModifier:HasModifier(EMDF_DRAW_ITEM_CHANCE_PERCENTAGE) then EModifier:CreateModifier(EMDF_DRAW_ITEM_CHANCE_PERCENTAGE) end


return public