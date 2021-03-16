if HeroCardData == nil then
	---@class HeroCardData 英雄卡数据
	HeroCardData = {
		tHeroCardsData = nil,
		iOrder = 0
	}
end
function HeroCardData:init(bReload)
	if not bReload then
		self.tHeroCardsData = {}
		self.tModifyData = {}
	end
	-- 接入修改器类型
	self.tMDFType = {
		FixedSellCardGoldPct = 1, -- 固定售卡金币百分比
		MaxHandCardCountBonus = 2, -- 修改最大手牌数
		TaxPercentage = 3, -- 修改税金百分比
	}
end
function HeroCardData:InitPlayerHandCardData(tEvent)
	local iPlayerID = tEvent.PlayerID
	self.tHeroCardsData[iPlayerID] = {}
	self.tModifyData[iPlayerID] = {}
	self:UpdateNetTables()
end
function HeroCardData:UpdateNetTables()
	local tDada = {}
	DotaTD:EachPlayer(function(_, iPlayerID)
		tDada[iPlayerID] = {
			max_count = self:GetMaxHeroCardCount(iPlayerID),
			cur_count = self:GetPlayerHeroCardsCount(iPlayerID),
			all_slots = self:GetPlayerAllSlots(iPlayerID),
		}
	end)
	CustomNetTables:SetTableValue("hand_cards", "data", tDada)
	CustomNetTables:SetTableValue("hand_cards", "hand_cards_hero", self.tHeroCardsData)
end
function HeroCardData:GetOrder()
	self.iOrder = self.iOrder + 1
	return self.iOrder
end
--计算手牌税收
function HeroCardData:JudgeTax(iPlayerID)
	local tTaxData = {}
	local iGoldSum = 0

	self:EachCard(function(hCard, iPlayerID2)
		if iPlayerID2 ~= iPlayerID then return end

		local iGold = self:GetCardTax(hCard)
		local miss_enemy = Spawner:GetPlayerRoundMissCount(iPlayerID)

		local fTaxCoe = TAX_CARD_COEFFICIENT

		if iGold * (1 - miss_enemy * fTaxCoe[1]) > 0 then
			iGold = math.floor(iGold * (1 - miss_enemy * fTaxCoe[1]))
		else
			iGold = 0
		end

		PlayerData:ModifyGold(iPlayerID, iGold)

		if not tTaxData[iPlayerID] then tTaxData[iPlayerID] = {} end
		tTaxData[iPlayerID][hCard.iCardID] = iGold
		iGoldSum = iGoldSum + iGold
	end)

	---@class EventData_PlayerTaxBalance
	local tEventData = {
		PlayerID = iPlayerID,
		iGold = iGoldSum,
		tTaxData = tTaxData[iPlayerID],
	}
	EventManager:fireEvent(ET_PLAYER.ON_TAX_BALANCE, tEventData)

	EmitSoundForPlayer('T3.ui_fstvs', iPlayerID)
	FireGameEvent("custom_show_tax", { json = json.encode(tTaxData) })

	return tTaxData
end
--获取一张卡牌税收
---@param hCard Card
function HeroCardData:GetCardTax(hCard)
	local sRarity = DotaTD:GetCardRarity(hCard.sCardName)
	local iLevel = hCard.iLevel or 1
	local iTaxPct = HeroCardData:GetPlayerTaxPercentage(hCard.iPlayerID) * 0.01 + 1
	return math.floor(TAX_CARD_PLAYER_LEVEL_COEFFICIENT(PlayerData:GetPlayerLevel(hCard.iPlayerID), TAX[sRarity][iLevel]) * iTaxPct)
end
--- 遍历英雄卡牌数据
---@param iPlayerID number|function
---@param func function func `func(hCard, iPlayerID)`
function HeroCardData:EachCard(iPlayerID, func)
	if func == nil then
		func = iPlayerID
		iPlayerID = nil
	end
	if func == nil or type(func) ~= "function" then
		return
	end
	if iPlayerID == nil then
		for iPlayerID, tData in pairs(self.tHeroCardsData) do
			for k, v in pairs(self.tHeroCardsData[iPlayerID]) do
				if func(v, iPlayerID) == true then
					return
				end
			end
		end
	else
		for k, v in pairs(self.tHeroCardsData[iPlayerID]) do
			if func(v, iPlayerID) == true then
				return
			end
		end
	end
end
---获取玩家卡牌数据
---@return Card
function HeroCardData:GetPlayerCardData(iPlayerID, iCardID)
	local tCardDatas = self.tHeroCardsData[iPlayerID]
	if not tCardDatas then return end
	return tCardDatas[iCardID]
end
--- 获取卡牌名字
function HeroCardData:GetPlayerCardName(iPlayerID, iCardID)
	local tCardData = self:GetPlayerCardData(iPlayerID, iCardID)
	if not tCardData then return end
	return tCardData.sCardName
end
--- 获取卡牌ID: `CardName -> CardID`
function HeroCardData:GetPlayerCardIDByName(iPlayerID, sCardName)
	local tData = self.tHeroCardsData[iPlayerID]
	if not tData then return end
	for k, v in pairs(tData) do
		if v.sCardName == sCardName then
			return k
		end
	end
end
function HeroCardData:GetPlayerHeroCardsCount(iPlayerID)
	local tPlayerData = self.tHeroCardsData[iPlayerID]
	if tPlayerData then
		return TableCount(tPlayerData)
	end
	return 0
end
--- 获取玩家最大英雄卡数
function HeroCardData:GetMaxHeroCardCount(iPlayerID)
	local iBonus = self:GetPlayerMaxHandCardCountBonus(iPlayerID)
	return self:GetPlayerBaseCardCount(iPlayerID) + iBonus
end
--- 获取玩家基础手牌数量
function HeroCardData:GetPlayerBaseCardCount(iPlayerID)
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	--temp
	local level = IsValid(hHero) and hHero:GetLevel() or 1
	return HAND_HERO_CARD_MAX[math.min(level, #HAND_HERO_CARD_MAX)]
end
-- 获取玩家基础卡牌金币
function HeroCardData:GetDefaultCardGold(sCardName)
	local tData = KeyValues.UnitsKv[sCardName]
	if tData and tData.Cost then
		return tonumber(tData.Cost)
	end
	return 0
end
--- 默认卡牌数据
function HeroCardData:DefaultCardData(sCardName, iPlayerID)
	---@class Card
	local hCard = {
		sCardName = sCardName or "demo",
		iGold = self:GetDefaultCardGold(sCardName),
		tItems = {},
		iXP = 0,
		iLevel = 1,
		iCardID = nil,
		iTax = 0,
		iBackGold = 0,
		iPlayerID = iPlayerID,
		iSlot = HeroCardData:GetPlayerEmptySlot(iPlayerID),
	}
	HeroCardData:UpdateCard(hCard, iPlayerID)
	return hCard
end
--- 返回英雄卡用的 单位数据
function HeroCardData:UnitCardData(hUnit)
	if hUnit and hUnit.GetBuilding then
		---@type Building
		local hBuilding = hUnit:GetBuilding()
		local hCard = HeroCardData:DefaultCardData(hBuilding:GetUnitEntityName(), hBuilding:GetPlayerOwnerID())
		hCard.iGold = hBuilding:GetGoldCost()
		hCard.iXP = hBuilding:GetCurrentXP()
		hCard.iLevel = hBuilding:GetStar()
		hCard.iEntID = hUnit:GetEntityIndex()
		HeroCardData:UpdateCard(hCard, hCard.iPlayerID)
		return hCard
	end
end
--- 根据英雄名字添加卡牌
function HeroCardData:AddCardByName(iPlayerID, sCardName)
	if sCardName ~= nil then
		local tCardData = self:DefaultCardData(sCardName, iPlayerID)
		tCardData.sCardName = sCardName
		return self:AddPlayerHeroCard(iPlayerID, tCardData)
	end
end
--- 尝试给玩家添加卡牌
function HeroCardData:TryAddCardByName(iPlayerID, sCardName, iXP)
	iXP = iXP or 1
	if HeroCardData:GetMaxHeroCardCount(iPlayerID) <= HeroCardData:GetPlayerHeroCardsCount(iPlayerID) then
		--手牌满了又有相同卡牌在手，自动升级
		---@type Card
		local hCard
		HeroCardData:EachCard(iPlayerID, function(hCard2)
			if hCard2.sCardName == sCardName and hCard2.iLevel < HERO_MAX_LEVEL then
				hCard = hCard2
				return true
			end
		end)
		if hCard then
			-- 手牌有卡给手牌升级
			HeroCardData:LevelUpCard(iPlayerID, hCard, 1)
			return true
		else
			local bHasBuilding = false
			---@param hBuilding Building
			PlayerBuildings:EachBuilding(iPlayerID, function(hBuilding)
				if hBuilding:GetUnitEntityName() == sCardName and hBuilding:GetLevel() < HERO_MAX_LEVEL then
					-- 场内有卡
					bHasBuilding = true
					BuildSystem:AddExperience(hBuilding:GetUnitEntity(), nil, 1)
					return true
				end
			end)
			if not bHasBuilding then
				if HeroCardData:AddCardByName(iPlayerID, sCardName) then return true end
			else
				return true
			end
		end
	else
		if HeroCardData:AddCardByName(iPlayerID, sCardName) then return true end
	end

	return false
end
--- 根据英雄单位添加卡牌
function HeroCardData:AddCardByUnit(iPlayerID, hUnit)
	if hUnit.GetBuilding then
		local hBuilding = hUnit:GetBuilding()
		return self:AddPlayerHeroCard(iPlayerID, self:UnitCardData(hUnit))
	end
end
--- 刷新卡片数据
function HeroCardData:UpdateCard(hCard)
	hCard.iTax = HeroCardData:GetCardTax(hCard)
	hCard.iBackGold = HeroCardData:GetSellCardGold(hCard.iPlayerID, hCard)
end
--- 添加英雄卡
---@param tCardData Card
function HeroCardData:AddPlayerHeroCard(iPlayerID, tCardData)
	if tCardData == nil then
		return false
	end
	local tPlayerData = self.tHeroCardsData[iPlayerID]
	if tPlayerData == nil then
		return false
	end
	if self:GetMaxHeroCardCount(iPlayerID) <= self:GetPlayerHeroCardsCount(iPlayerID) then
		ErrorMessage(iPlayerID, 'dota_hud_error_hand_hero_card_max')
		return false
	end

	if type(tCardData) == "string" then
		local sCardName = tCardData
		tCardData = self:DefaultCardData(sCardName, iPlayerID)
		tCardData.sCardName = sCardName
	end

	tCardData.iCardID = DoUniqueString("iCardID")
	tCardData.iOrder =	HeroCardData:GetOrder()
	tPlayerData[tCardData.iCardID] = tCardData

	self:UpdateNetTables()

	---载入单位
	HandHeroCards:PercacheCardUnit(iPlayerID, tCardData.sCardName)

	-- 自动升级
	if HandHeroCards:IsPlayerAutoUnifyCard(iPlayerID) then
		local bHasBuilding = false
		if not tCardData.iEntID then
			---@param hBuilding Building
			PlayerBuildings:EachBuilding(iPlayerID, function(hBuilding)
				if hBuilding:GetUnitEntityName() == tCardData.sCardName then
					-- 场内有卡
					bHasBuilding = true
					BuildSystem:AddExperience(hBuilding:GetUnitEntity(), nil, (tCardData.iXP or 0) + 1)
					HeroCardData:RemoveCard(iPlayerID, tCardData.iCardID)
					return true
				end
			end)
		end
		if not bHasBuilding then
			HandHeroCards:UnifyAllCard(iPlayerID)
		end
	end

	print('HuoShao', 'fireEvent(ET_PLAYER.ON_CHANGE_HERO_CARD')
	local tEventData = {
		PlayerID = iPlayerID,
		sCardName = tCardData.sCardName
	}
	EventManager:fireEvent(ET_PLAYER.ON_CHANGE_HERO_CARD, tEventData)

	return tCardData
end
--- 强制添加英雄卡（不验证数量上限，不更新nettable）
function HeroCardData:_AddPlayerHeroCard(iPlayerID, tCardData)
	if tCardData == nil then
		return false
	end
	local tPlayerData = self.tHeroCardsData[iPlayerID]
	if tPlayerData == nil then
		return false
	end

	if type(tCardData) == "string" then
		local sCardName = tCardData
		tCardData = self:DefaultCardData(sCardName, iPlayerID)
		tCardData.sCardName = sCardName
	end

	tCardData.iCardID = DoUniqueString("iCardID")
	tPlayerData[tCardData.iCardID] = tCardData

	---载入单位
	HandHeroCards:PercacheCardUnit(iPlayerID, tCardData.sCardName)

	-- 自动升级
	if HandHeroCards:IsPlayerAutoUnifyCard(iPlayerID) then
		local bHasBuilding = false
		if not tCardData.iEntID then
			---@param hBuilding Building
			PlayerBuildings:EachBuilding(iPlayerID, function(hBuilding)
				if hBuilding:GetUnitEntityName() == tCardData.sCardName then
					-- 场内有卡
					bHasBuilding = true
					BuildSystem:AddExperience(hBuilding:GetUnitEntity(), nil, 1)
					HeroCardData:RemoveCard(iPlayerID, tCardData.iCardID)
					return true
				end
			end)
		end
		if not bHasBuilding then
			HandHeroCards:UnifyAllCard(iPlayerID)
		end
	end

	return tCardData
end
--- 移除英雄卡
function HeroCardData:RemoveCard(iPlayerID, iCardID)
	local tCardData = self:GetPlayerCardData(iPlayerID, iCardID)
	if tCardData then
		local bRemove = remove(self.tHeroCardsData[iPlayerID], function(tCardData)
			return tCardData.iCardID == iCardID
		end)
		if bRemove then
			local tEventData = {
				PlayerID = iPlayerID,
			}
			EventManager:fireEvent(ET_PLAYER.ON_CHANGE_HERO_CARD, tEventData)

			self:UpdateNetTables()
		end
	end
end
--- 移除英雄卡(多张)
function HeroCardData:RemoveCards(iPlayerID, tCards)
	local bRemove = false
	for _, v in pairs(tCards) do
		local iCardID
		if type(v) == 'table' then
			---@type Card
			local hCard = v
			iCardID = hCard.iCardID
		else
			iCardID = v
		end
		if remove(self.tHeroCardsData[iPlayerID], function(hCard)
			return hCard.iCardID == iCardID
		end) then
			bRemove = true
		end
	end
	if bRemove then
		local tEventData = {
			PlayerID = iPlayerID,
		}
		EventManager:fireEvent(ET_PLAYER.ON_CHANGE_HERO_CARD, tEventData)

		self:UpdateNetTables()
	end
end
--- 移除全部英雄卡
function HeroCardData:RemoveAll(iPlayerID)
	self.tHeroCardsData[iPlayerID] = {}
	local tEventData = {
		PlayerID = iPlayerID,
	}
	EventManager:fireEvent(ET_PLAYER.ON_CHANGE_HERO_CARD, tEventData)

	self:UpdateNetTables()
end
--- 给某卡牌喂N张卡
---@param hCard Card
function HeroCardData:LevelUpCard(iPlayerID, hCard, iCount)
	if iCount == 0 then return end
	iCount = iCount or 1
	hCard.iXP = hCard.iXP + iCount
	hCard.iGold = hCard.iGold + iCount * self:GetDefaultCardGold(hCard.sCardName)

	for i = #HERO_XP_PER_LEVEL_TABLE, 1, -1 do
		local iXP = HERO_XP_PER_LEVEL_TABLE[i]
		if hCard.iXP >= iXP then
			-- 判断是否升级了
			if hCard.iLevel ~= i then
				self:FireLevelUpEvt(iPlayerID, i, hCard.iLevel, hCard)
			end
			hCard.iLevel = i
			break
		end
	end

	HeroCardData:UpdateCard(hCard, iPlayerID)
	self:UpdateNetTables()
end
--- 用多张卡喂给一张卡
---@param hCard Card
function HeroCardData:LevelUpCardWithCards(iPlayerID, hCard, tCards)
	for _, hCard2 in pairs(tCards) do
		hCard.iXP = hCard.iXP + hCard2.iXP + 1
		hCard.iGold = hCard.iGold + hCard2.iGold
	end
	for i = #HERO_XP_PER_LEVEL_TABLE, 1, -1 do
		local iXP = HERO_XP_PER_LEVEL_TABLE[i]
		if hCard.iXP >= iXP then
			-- 判断是否升级了
			if hCard.iLevel ~= i then
				self:FireLevelUpEvt(iPlayerID, i, hCard.iLevel, hCard)
			end
			hCard.iLevel = i
			break
		end
	end
	HeroCardData:UpdateCard(hCard, iPlayerID)
	HeroCardData:RemoveCards(iPlayerID, tCards)
end
---@param hCard Card
function HeroCardData:FireLevelUpEvt(iPlayerID, iLevel, iLastLevel, hCard)
	---@class EventData_PlayerHeroCardLevelup
	local tData = {
		PlayerID = iPlayerID,
		iLevel = iLevel,
		iLastLevel = iLastLevel,
		hCard = hCard
	}
	EventManager:fireEvent(ET_PLAYER.ON_HERO_CARD_LEVELUP, tData)
end
--- 获取出售金币
function HeroCardData:GetSellCardGold(iPlayerID, tCardData)
	local iLevel = tCardData.iLevel
	local iGold = tCardData.iGold

	local iReturnPct = self:GetPlayerFixedSellCardGoldPercent(iPlayerID)
	if iReturnPct == false then
		iReturnPct = SELL_CARD_GOLD_PERCENT[tCardData.iLevel] or 100
	end

	return math.floor(iGold * iReturnPct * 0.01)
end
function HeroCardData:SellCard(iPlayerID, iCardID)
	local tCardData = self:GetPlayerCardData(iPlayerID, iCardID)
	if tCardData == nil then
		return false
	end

	self:RemoveCard(iPlayerID, iCardID)
	local iSellGold = self:GetSellCardGold(iPlayerID, tCardData)
	return iSellGold
end
--- 卡牌添加物品装备
function HeroCardData:AddCardItem(iPlayerID, iCardID, tItemData)
	local tCardData = self:GetPlayerCardData(iPlayerID, iCardID)
	if tCardData == nil then
		return false
	end
	tCardData.tItems[tItemData.iItemID] = tItemData
	self:UpdateNetTables()
end
--- 卡牌移除物品装备
function HeroCardData:RemoveCardItem(iPlayerID, iCardID, iItemID)
	local tCardData = self:GetPlayerCardData(iPlayerID, iCardID)
	if tCardData == nil or tCardData.tItems[iItemID] == nil then
		return false
	end
	tCardData.tItems[iItemID] = nil
	self:UpdateNetTables()
	return true
end

---获取玩家全部槽位
function HeroCardData:EachPlayerSlot(iPlayerID, func)
	local iMax = HAND_HERO_CARD_MAX_COUNT()
	if iMax % 2 == 0 then
		local iSlot = iMax / 2
		local iOffset = 0
		for i = 1, iMax do
			iSlot = iSlot + iOffset * (i % 2 == 1 and -1 or 1)
			if func(iSlot) then
				return
			end
			iOffset = iOffset + 1
		end
	else
		local iSlot = math.ceil(iMax / 2)
		local iOffset = 0
		for i = 1, iMax do
			iSlot = iSlot + iOffset * (i % 2 == 0 and -1 or 1)
			if func(iSlot) then
				return
			end
			iOffset = iOffset + 1
		end
	end
	return -1
end
---获取玩家全部槽位
function HeroCardData:GetPlayerAllSlots(iPlayerID)
	local tSlots = {}
	self:EachPlayerSlot(iPlayerID, function(iSlot)
		table.insert(tSlots, iSlot)
	end)
	return tSlots
end
---是否是有效槽位
function HeroCardData:IsValidPlayerESlot(iPlayerID, iSlot)
	local bValid = false
	self:EachPlayerSlot(iPlayerID, function(iSlot2)
		if iSlot2 == iSlot then
			bValid = true
			return true
		end
	end)
	return bValid
end
---获取玩家一个空槽位
function HeroCardData:GetPlayerEmptySlot(iPlayerID)
	local iSlot = -1
	self:EachPlayerSlot(iPlayerID, function(iSlot2)
		if not HeroCardData:GetPlayerCardBySlot(iPlayerID, iSlot2) then
			iSlot = iSlot2
			return true
		end
	end)
	return iSlot
end
---获取玩家槽位的卡牌
---@return Card
function HeroCardData:GetPlayerCardBySlot(iPlayerID, iSlot)
	local hCardResult
	---@param hCard Card
	self:EachCard(iPlayerID, function(hCard)
		if hCard.iSlot == iSlot then
			hCardResult = hCard
			return true
		end
	end)
	return hCardResult
end
---卡牌设置槽位
---@param hCard Card
---@return boolean  true=设置成功 false=目标槽位被占用
function HeroCardData:SetCardSlot(hCard, iSlot)
	-- 验证目标卡槽是否有效
	if HeroCardData:IsValidPlayerESlot(hCard.iPlayerID, iSlot) then
		-- 验证目标卡槽是否为空
		if not HeroCardData:GetPlayerCardBySlot(hCard.iPlayerID, iSlot) then
			hCard.iSlot = iSlot
			self:UpdateNetTables()
			return true
		end
	end
	return false
end
---卡牌更换槽位（强制更换，不验证不更新nettable）
---@param hCard Card
function HeroCardData:_SetCardSlot(hCard, iSlot)
	hCard.iSlot = iSlot
end
---交换卡牌的位置
---@param hCard Card
function HeroCardData:ExchangeCardSlot(hCard, iSlot)
	-- 验证目标卡槽是否有效
	if HeroCardData:IsValidPlayerESlot(hCard.iPlayerID, iSlot) then
		local hCard2 = HeroCardData:GetPlayerCardBySlot(hCard.iPlayerID, iSlot)
		if not hCard2 then
			hCard.iSlot = iSlot
		else
			hCard.iSlot, hCard2.iSlot = hCard2.iSlot, hCard.iSlot
		end
		self:UpdateNetTables()
	end
end

--- 修改售卡折扣百分比
function HeroCardData:GetModifierFixedSellCardGoldPercent(hSource, func)
	local iPlayerID = hSource:GetPlayerID()

	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData ~= nil then
		tPlayerModifyData[self.tMDFType.FixedSellCardGoldPct] = tPlayerModifyData[self.tMDFType.FixedSellCardGoldPct] or {}
		local tModify = tPlayerModifyData[self.tMDFType.FixedSellCardGoldPct]
		if tModify[hSource] ~= func then
			tModify[hSource] = func
		end

		HeroCardData:EachCard(iPlayerID, function(hCard)
			HeroCardData:UpdateCard(hCard, iPlayerID)
		end)
		self:UpdateNetTables()
	end
end
--- 获取玩家售卡折扣百分比
function HeroCardData:GetPlayerFixedSellCardGoldPercent(iPlayerID)
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData == nil then
		return false
	end
	--- 是否需要修改
	local bResult = false

	local tModify = tPlayerModifyData[self.tMDFType.FixedSellCardGoldPct]
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
--- 修改最大英雄手牌数
function HeroCardData:GetModifierMaxHandCardCountBonus(hSource, func)
	local iPlayerID = hSource:GetPlayerID()
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData then
		tPlayerModifyData[self.tMDFType.MaxHandCardCountBonus] = tPlayerModifyData[self.tMDFType.MaxHandCardCountBonus] or {}
		local tModify = tPlayerModifyData[self.tMDFType.MaxHandCardCountBonus]
		if tModify[hSource] ~= func then
			tModify[hSource] = func
			self:UpdateNetTables()
		end
	end
end
--- 获取玩家最大英雄手牌数奖励~
function HeroCardData:GetPlayerMaxHandCardCountBonus(iPlayerID)
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData == nil then
		return 0
	end

	local iBonus = 0
	local tModify = tPlayerModifyData[self.tMDFType.MaxHandCardCountBonus]
	if tModify ~= nil then
		for hSource, func in pairs(tModify) do
			if hSource and func then
				local bonus = tonumber(func(hSource))
				if bonus then
					iBonus = iBonus + bonus
				end
			end
		end
	end
	return iBonus
end
--- 修改卡牌税金
function HeroCardData:GetTaxPercentage(hSource, func)
	local iPlayerID = hSource:GetPlayerID()
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData then
		tPlayerModifyData[self.tMDFType.TaxPercentage] = tPlayerModifyData[self.tMDFType.TaxPercentage] or {}
		local tModify = tPlayerModifyData[self.tMDFType.TaxPercentage]
		if tModify[hSource] ~= func then
			tModify[hSource] = func
			self:UpdateNetTables()
		end
	end
end
--- 获取玩家最大英雄手牌数奖励
function HeroCardData:GetPlayerTaxPercentage(iPlayerID)
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData == nil then
		return 0
	end

	local iBonus = 0
	local tModify = tPlayerModifyData[self.tMDFType.TaxPercentage]
	if tModify ~= nil then
		for hSource, func in pairs(tModify) do
			if hSource and func then
				local bonus = tonumber(func(hSource))
				if bonus then
					iBonus = iBonus + bonus
				end
			end
		end
	end
	return iBonus
end

--- 获取玩家所有的英雄卡牌数量
function HeroCardData:GetMaxLevelHeroCount(iPlayerID)
	local t = {}
	---@param hCard Card
	HeroCardData:EachCard(iPlayerID, function(hCard)
		if hCard.iXP >= HERO_XP_PER_LEVEL_TABLE[HERO_MAX_LEVEL] then
			table.insert(t, hCard.sCardName)
		end
	end)
	---@param hBuilding Building
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		if hBuilding.iXP >= HERO_XP_PER_LEVEL_TABLE[HERO_MAX_LEVEL] then
			table.insert(t, hBuilding:GetUnitEntityName())
		end
	end)
	return t
end

----------------------------------------------------------------------------------------------------
if HandHeroCards == nil then
	---@class HandHeroCards
	HandHeroCards = {
		-- tPlayerCards = nil, --玩家手牌
		tPlayerDragUnit = nil, --玩家拖拽预建造单位
		tPlayerAutoUnify = nil, --玩家自动统一升级
		tPlayerAutoBuy = nil, --玩家自动购买已有卡牌
	}
	HandHeroCards = class({}, HandHeroCards)
end
---@type HandHeroCards
local public = HandHeroCards

function public:init(bReload)
	HeroCardData:init(bReload)

	CustomUIEvent("HeroCard_DragStart", Dynamic_Wrap(self, "OnHeroCard_DragStart"), self)
	CustomUIEvent("HeroCard_DragUpdate", Dynamic_Wrap(self, "OnHeroCard_DragUpdate"), self)
	CustomUIEvent("HeroCard_Cancel", Dynamic_Wrap(self, "OnHeroCard_Cancel"), self)
	CustomUIEvent("HeroCard_DragEnd", Dynamic_Wrap(self, "OnHeroCard_DragEnd"), self)
	CustomUIEvent("HeroCard_DragStart_LevelUp", Dynamic_Wrap(self, "OnHeroCard_DragStart_LevelUp"), self)
	CustomUIEvent("HeroCard_LevelUp", Dynamic_Wrap(self, "OnHeroCard_LevelUp"), self)
	CustomUIEvent("HeroCard_Exchange", Dynamic_Wrap(self, "OnHeroCard_Exchange"), self)
	CustomUIEvent("HeroCard_ExchangeSlot", Dynamic_Wrap(self, "OnHeroCard_ExchangeSlot"), self)
	CustomUIEvent("HeroCard_Sell", Dynamic_Wrap(self, "OnHeroCard_Sell"), self)
	CustomUIEvent("HeroCard_LevelUpCard", Dynamic_Wrap(self, "OnHeroCard_LevelUpCard"), self)
	CustomUIEvent("HeroCard_LevelUpSingleCard", Dynamic_Wrap(self, "OnHeroCard_LevelUpSingleCard"), self)
	CustomUIEvent("HeroCard_UnifyAllCard", Dynamic_Wrap(self, "OnHeroCard_UnifyAllCard"), self)
	CustomUIEvent("HeroCard_EnableAutoUnifyCard", Dynamic_Wrap(self, "OnHeroCard_EnableAutoUnifyCard"), self)
	CustomUIEvent("HeroCard_EnableAutoBuyCard", Dynamic_Wrap(self, "OnHeroCard_EnableAutoBuyCard"), self)

	EventManager:register(ET_PLAYER.LEVEL_CHANGED, 'OnEvent_PlayerLevelChanged', self)
	EventManager:register(ET_PLAYER.ON_LOADED_FINISHED, 'OnEvent_LoadedFinished', self)

	if not bReload then
		-- self.tPlayerCards = {}
		self.tPlayerDragUnit = {}
		self.tPlayerAutoUnify = {}
		self.tPlayerAutoBuy = {}
	end

	-- self:UpdateNetTables()
end

--UI事件************************************************************************************************************************
	do
	-- 玩家拖拽卡牌：准备使用，显示预建造单位
	function public:OnHeroCard_DragStart(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		if PlayerData:IsPlayerDeath(iPlayerID) then return end
		local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
		if not IsValid(hHero) or not hHero:IsAlive() then return end

		local iCardID = events.card_id
		local sCardName = HeroCardData:GetPlayerCardName(iPlayerID, iCardID)
		if not sCardName then return end

		local vPos = Vector(tonumber(events.pos['0']), tonumber(events.pos['1']), tonumber(events.pos['2']))

		local hUnit = CreateUnitByName(sCardName, vPos, false, hHero, hHero, hHero:GetTeamNumber())
		if not IsValid(hUnit) then return end
		hUnit.iCardID = iCardID
		self.tPlayerDragUnit[iPlayerID] = hUnit

		hUnit:AddNewModifier(hUnit, nil, 'modifier_hero_card_drag', {
			pos_x = vPos.x,
			pos_y = vPos.y,
			pos_z = vPos.z,
		})

		--显示棋盘棋子
		self:AddDragShow(iPlayerID)
	end
	-- 玩家拖拽卡牌：升级单位
	function public:OnHeroCard_DragStart_LevelUp(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iCardID = events.card_id
		local sCardName = HeroCardData:GetPlayerCardName(iPlayerID, iCardID)

		--显示棋盘棋子
		self:AddDragShow(iPlayerID, sCardName)
	end
	-- 玩家拖拽卡牌：更新位置
	function public:OnHeroCard_DragUpdate(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local vPos = Vector(tonumber(events.pos['0']), tonumber(events.pos['1']), tonumber(events.pos['2']))
		local hUnit = self.tPlayerDragUnit[iPlayerID]
		if hUnit then
			local hBuff = hUnit:FindModifierByName('modifier_hero_card_drag')
			if hBuff then
				hBuff.vPos = Vector(vPos.x, vPos.y, vPos.z)
			end
		end
	end
	-- 玩家拖拽卡牌：取消使用
	function public:OnHeroCard_Cancel(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local hUnit = self.tPlayerDragUnit[iPlayerID]
		if hUnit then
			hUnit:RemoveModifierByName('modifier_hero_card_drag')
			UTIL_Remove(hUnit)
		end
		self.tPlayerDragUnit[iPlayerID] = nil

		self:DelDragShow(iPlayerID)
	end
	-- 玩家拖拽卡牌：放开拖拽，使用卡牌
	function public:OnHeroCard_DragEnd(eventSourceIndex, events)
		local iPlayerID = events.PlayerID

		local hUnit = self.tPlayerDragUnit[iPlayerID]
		if not hUnit then return end

		local iCardID = hUnit.iCardID
		local sUnitName = hUnit:GetUnitName()
		hUnit:RemoveModifierByName('modifier_hero_card_drag')
		UTIL_Remove(hUnit)
		self.tPlayerDragUnit[iPlayerID] = nil

		--建筑英雄
		if not USE_HERO_CARD_TO_BUILDING_IN_BATTLEING and PlayerData:IsBattling(iPlayerID) then
			--战斗时不能建筑
			ErrorMessage(iPlayerID, 'dota_hud_error_cant_operate_in_battleeing')
		else
			local vPos = Vector(tonumber(events.pos['0']), tonumber(events.pos['1']), tonumber(events.pos['2']))
			local hBuildingPos = BuildSystem:GetBuildingByPos(vPos)
			if hBuildingPos then
				if not USE_HERO_CARD_TO_EXCANGE_IN_BATTLEING and PlayerData:IsBattling(iPlayerID) then
					--战斗时不能交换建造
					ErrorMessage(iPlayerID, 'dota_hud_error_cant_operate_in_battleeing')
					goto _return
				end
			end
			self:UsedCard(iPlayerID, iCardID, vPos)
		end

		:: _return ::
		self:DelDragShow(iPlayerID)
	end
	-- 玩家使用卡牌：升级英雄
	function public:OnHeroCard_LevelUp(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iCardID = events.card_id
		local iEntID = tonumber(events.ent_id)

		local result = false

		if not USE_HERO_CARD_TO_LEVELUP_IN_BATTLEING and PlayerData:IsBattling(iPlayerID) then
			--战斗时不能操作
			ErrorMessage(iPlayerID, 'dota_hud_error_cant_operate_in_battleeing')
		else
			BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
				if iEntID == hBuilding:GetUnitEntityIndex() then
					--升级英雄
					local sCardName = HeroCardData:GetPlayerCardName(iPlayerID, iCardID)
					if self:UsedCardToLevel(iPlayerID, iCardID, hBuilding) then
						result = true
					end
					return true
				end
			end)
		end

		self:DelDragShow(iPlayerID)
		return result
	end
	-- 玩家使用卡牌：交换英雄
	function public:OnHeroCard_Exchange(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iCardID = events.card_id
		local iEntID = tonumber(events.ent_id)

		if not USE_HERO_CARD_TO_EXCANGE_IN_BATTLEING and PlayerData:IsBattling(iPlayerID) then
			--战斗时不能操作
			ErrorMessage(iPlayerID, 'dota_hud_error_cant_operate_in_battleeing')
		else
			local hBuilding = BuildSystem:GetBuildingByEntID(iEntID)
			if hBuilding then
				self:UsedCard(iPlayerID, iCardID, hBuilding.vLocation)
			end
		end

		self:DelDragShow(iPlayerID)
	end
	-- 玩家卡牌交换槽位
	function public:OnHeroCard_ExchangeSlot(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iCardID = events.card_id
		local iSlot = tonumber(events.slot)

		local hCard = HeroCardData:GetPlayerCardData(iPlayerID, iCardID)
		if not hCard then return end
		HeroCardData:ExchangeCardSlot(hCard, iSlot)
	end
	-- 玩家出售卡牌
	function public:OnHeroCard_Sell(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iCardID = events.card_id
		local tCardData = HeroCardData:GetPlayerCardData(iPlayerID, iCardID)

		self:DelDragShow(iPlayerID)

		local iGold = HeroCardData:SellCard(iPlayerID, iCardID)
		if iGold then
			---@class EventData_ON_TOWER_CARD_SELL
			local tEventData = {
				PlayerID = iPlayerID,
				iGoldReturn = iGold,
				---@type Card
				tCardData = tCardData,
				iCardID = iCardID,
			}
			EventManager:fireEvent(ET_PLAYER.ON_TOWER_CARD_SELL, tEventData)
			PlayerData:ModifyGold(iPlayerID, iGold, false)
			EmitSoundForPlayer('T3.coins', iPlayerID)

			--删除拖拽单位
			local hUnit = self.tPlayerDragUnit[iPlayerID]
			if hUnit then
				local sUnitName = hUnit:GetUnitName()
				hUnit:RemoveModifierByName('modifier_hero_card_drag')
				UTIL_Remove(hUnit)
				self.tPlayerDragUnit[iPlayerID] = nil
			end
			return true
		end

		return false
	end
	---玩家在手牌中升级卡牌
	function public:OnHeroCard_LevelUpCard(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iCardID = events.card_id

		local hCard_LevelUp = HeroCardData:GetPlayerCardData(iPlayerID, iCardID)
		if not hCard_LevelUp then return end

		local tCards = self:CheckCardCanLevelUp(iPlayerID, hCard_LevelUp)
		if not tCards then return end

		HeroCardData:LevelUpCardWithCards(iPlayerID, hCard_LevelUp, tCards)
	end
	---玩家在单卡喂卡
	function public:OnHeroCard_LevelUpSingleCard(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iCardID_Used = events.used_card_id
		local iCardID_Level = events.level_card_id

		local hCard_Used = HeroCardData:GetPlayerCardData(iPlayerID, iCardID_Used)
		if not hCard_Used then return end
		if hCard_Used.iLevel >= HERO_MAX_LEVEL then
			ErrorMessage(iPlayerID, 'dota_hud_error_cant_levelup_have_max')
			return
		end

		local hCard_Level = HeroCardData:GetPlayerCardData(iPlayerID, iCardID_Level)
		if not hCard_Level then return end
		if hCard_Level.iLevel >= HERO_MAX_LEVEL then
			ErrorMessage(iPlayerID, 'dota_hud_error_cant_levelup_have_max')
			return
		end

		HeroCardData:LevelUpCardWithCards(iPlayerID, hCard_Level, { hCard_Used })
	end
	---玩家在手牌中统一升级所有卡牌（合并重复卡牌）
	function public:OnHeroCard_UnifyAllCard(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		self:UnifyAllCard(iPlayerID)
	end
	---玩家开关自动统一升级
	function public:OnHeroCard_EnableAutoUnifyCard(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		self.tPlayerAutoUnify[iPlayerID] = not self.tPlayerAutoUnify[iPlayerID]
		self:UnifyAllCard(iPlayerID)
		self:UpdateNetTables()
	end
	---玩家开关自动购买相同卡牌
	function public:OnHeroCard_EnableAutoBuyCard(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		self.tPlayerAutoBuy[iPlayerID] = not self.tPlayerAutoBuy[iPlayerID]
		self:UpdateNetTables()
	end
end
--事件监听************************************************************************************************************************
	do
	---@param tEvent EventData_PLAYER_LEVEL_CHANGED
	function public:OnEvent_PlayerLevelChanged(tEvent)
		local iPlayerID = tEvent.PlayerID
		HeroCardData:EachCard(iPlayerID, function(hCard)
			HeroCardData:UpdateCard(hCard)
		end)
		HeroCardData:UpdateNetTables()
	end
	---@param tEvent EventData_ON_LOADED_FINISHED
	function public:OnEvent_LoadedFinished(tEvent)
		local iPlayerID = tEvent.PlayerID
		self.tPlayerAutoUnify[iPlayerID] = false
		self:UpdateNetTables()
	end
end
--事件监听************************************************************************************************************************
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("hand_cards", "player_auto_unify", self.tPlayerAutoUnify)
	CustomNetTables:SetTableValue("hand_cards", "player_auto_buy", self.tPlayerAutoBuy)
end

--玩家使用卡牌
function public:UsedCard(iPlayerID, iCardID, vPos)
	local sCardName = HeroCardData:GetPlayerCardName(iPlayerID, iCardID)
	if not sCardName then return false end
	local tCardData = HeroCardData:GetPlayerCardData(iPlayerID, iCardID)
	if not tCardData then return false end

	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	if not IsValid(hHero) or not hHero:IsAlive() then return false end

	if PlayerData:IsPlayerDeath(iPlayerID) then
		ErrorMessage(iPlayerID, 'dota_hud_error_death')
		return false
	end

	-- 验证建筑单位是否重复
	if PlayerBuildings:HasBuildingUnit(iPlayerID, sCardName) then
		if not _G.CLONEMODE then
			ErrorMessage(iPlayerID, 'dota_hud_error_hero_repeat')
			return false
		end
	end

	-- 验证建筑位置
	SnapToGrid(BUILDING_SIZE, vPos)
	---@type Building
	local hBuildingPos = BuildSystem:GetBuildingByPos(vPos)
	if not hBuildingPos then
		local iTeamID = PlayerData:GetPlayerTeamID(iPlayerID)
		if not BuildSystem:ValidPosition(BUILDING_SIZE, vPos, iTeamID, BuildSystem.typeBuildingMap) then
			ErrorMessage(iPlayerID, 'dota_hud_error_cant_build_at_location')
			return false
		end
	else
		--替换单位，先把当前位置单位换成卡牌
		if hBuildingPos:GetPlayerOwnerID() ~= iPlayerID then
			ErrorMessage(iPlayerID, 'dota_hud_error_cant_build_at_location')
			return false
		end
		local hCard = HeroCardData:UnitCardData(hBuildingPos:GetUnitEntity())
		hCard.iSlot = tCardData.iSlot
		HeroCardData:_AddPlayerHeroCard(iPlayerID, hCard)
		EventManager:fireEvent(ET_PLAYER.ON_TOWER_TO_CARD, {
			hBuilding = hBuildingPos,
			tCardData = hCard,
		})
		BuildSystem:RemoveBuilding(hBuildingPos:GetUnitEntity())
	end

	local hBuilding = BuildSystem:PlaceBuilding(hHero, sCardName, vPos, BUILDING_ANGLE)
	if hBuilding then
		local iXP = tCardData.iXP or 0
		if hBuilding:IsHero() then
			BuildSystem:AddExperience(hBuilding:GetUnitEntity(), nil, iXP)
		else
			BuildSystem:UpgradeBuilding(hBuilding:GetUnitEntity(), nil, iXP)
		end

		EventManager:fireEvent(ET_PLAYER.ON_TOWER_SPAWNED_FROM_CARD, {
			PlayerID = iPlayerID,
			hBuilding = hBuilding,
			iCardID = iCardID,
			tCardData = tCardData,
		})
		HeroCardData:RemoveCard(iPlayerID, iCardID)
		return hBuilding
	end
	return false
end
--- 玩家使用卡牌升级英雄
---@param hBuilding Building
function public:UsedCardToLevel(iPlayerID, iCardID, hBuilding)
	if hBuilding:GetStar() >= 5 then
		ErrorMessage(iPlayerID, 'dota_hud_error_star_limit')
		return false
	end

	local sCardName = HeroCardData:GetPlayerCardName(iPlayerID, iCardID)
	if not sCardName then return false end
	if sCardName ~= hBuilding:GetUnitEntityName() then
		ErrorMessage(iPlayerID, 'dota_hud_error_only_can_cast_on_same_hero')
		return false
	end

	local tCardData = HeroCardData:GetPlayerCardData(iPlayerID, iCardID)
	local iXP = tCardData.iXP or 0

	local iLastLevel = hBuilding:GetLevel()
	if hBuilding:IsHero() then
		BuildSystem:AddExperience(hBuilding:GetUnitEntity(), nil, iXP + 1)
	else
		BuildSystem:UpgradeBuilding(hBuilding:GetUnitEntity(), nil, iXP + 1)
	end

	---@class EventData_PlayerTowerLevelupFromCard
	local tData = {
		PlayerID = iPlayerID,
		hBuilding = hBuilding,
		iCardID = iCardID,
		iLastLevel = iLastLevel,
		iLevel = hBuilding:GetLevel(),
		tCardData = HeroCardData:GetPlayerCardData(iPlayerID, iCardID),
	}
	EventManager:fireEvent(ET_PLAYER.ON_TOWER_LEVELUP_FROM_CARD, tData)

	HeroCardData:RemoveCard(iPlayerID, iCardID)
	return true
end

---添加拖拽
function public:AddDragShow(iPlayerID, sActiveUnitName)
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		local hUnit = hBuilding:GetUnitEntity()
		hUnit:AddNewModifier(hUnit, nil, 'modifier_hero_card_drag_show', {
			active_unit_name = sActiveUnitName,
		})
	end)
end
function public:DelDragShow(iPlayerID)
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		local hUnit = hBuilding:GetUnitEntity()
		hUnit:RemoveModifierByName('modifier_hero_card_drag_show')
	end)
end

---判断一张卡牌能否在手牌中升级
---@param hCard Card
---@return Card[]
function public:CheckCardCanLevelUp(iPlayerID, hCard)
	local sCardName = hCard.sCardName
	local iLevel = hCard.iLevel
	local iNeedXP = HERO_XP_PER_LEVEL_TABLE[iLevel + 1] - hCard.iXP

	---@type Card[]
	local tCards = {}

	HeroCardData:EachCard(iPlayerID, function(hCard2)
		if hCard2.sCardName == sCardName and hCard2.iCardID ~= hCard.iCardID and hCard2.iLevel <= iLevel then
			table.insert(tCards, hCard2)
		end
	end)
	table.sort(tCards, function(a, b)
		return a.iXP > b.iXP
	end)


	--找到需要的
	---@param tCardsCur Card[]
	local function find(iNeedXPCur, tCardsCur)
		for i = #tCardsCur, 1, -1 do
			local hCard2 = tCardsCur[i]
			table.remove(tCardsCur, i)

			local iNeedXPTemp = iNeedXPCur - (hCard2.iXP + 1)
			if 0 == iNeedXPTemp then
				return { hCard2 }
			end

			local tFind = find(iNeedXPTemp, deepcopy(tCardsCur))
			if tFind then
				table.insert(tFind, hCard2)
				return tFind
			end
		end
	end

	return find(iNeedXP, tCards)
end

---载入某卡牌的单位
function public:PercacheCardUnit(iPlayerID, sCardName)
	if not self._tPercacheFinished then self._tPercacheFinished = {} end
	if self._tPercacheFinished[sCardName] then return end

	local hHero = PlayerData:GetHero(iPlayerID)
	if IsValid(hHero) then
		hHero._percache_unit = sCardName
		hHero:AddAbility('percache_unit')
		hHero:RemoveAbility('percache_unit')
		self._tPercacheFinished[sCardName] = true
	end
end

function public:UnifyAllCard(iPlayerID)
	local tCards = {}
	---@param hCard Card
	HeroCardData:EachCard(iPlayerID, function(hCard)
		if not tCards[hCard.sCardName] then
			tCards[hCard.sCardName] = {}
		end

		-- 验证确保不会经验溢出
		local iXP = hCard.iXP + 1
		for _, hCard2 in pairs(tCards[hCard.sCardName]) do
			iXP = iXP + hCard2.iXP + 1
		end
		local iMaxXP = HERO_XP_PER_LEVEL_TABLE[HERO_MAX_LEVEL] + 1
		if iXP <= iMaxXP then
			table.insert(tCards[hCard.sCardName], hCard)
		end
	end)

	for sCardName, t in pairs(tCards) do
		local iCount = #t
		if 2 <= iCount then
			local hCardLast = t[iCount]
			table.remove(t, iCount)
			HeroCardData:LevelUpCardWithCards(iPlayerID, hCardLast, t)
		end
	end
end

---玩家是否开启自动升级相同卡牌
function public:IsPlayerAutoUnifyCard(iPlayerID)
	return true == HandHeroCards.tPlayerAutoUnify[iPlayerID]
end
---玩家是否开启自动购买已有卡牌
function public:IsPlayerAutoBuyCard(iPlayerID)
	return true == HandHeroCards.tPlayerAutoBuy[iPlayerID]
end

return public