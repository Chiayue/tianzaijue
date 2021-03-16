if nil == Exchanger then
	---@class Exchanger 消耗品管理
	Exchanger = {
		tPlayerItems = {}
	}
	Exchanger = class({}, Exchanger)
end

---@type Exchanger
local public = Exchanger

function public:init(bReload)
	if not bReload then
	end

	CustomUIEvent("Items_Exchange", Dynamic_Wrap(self, "OnItems_Exchange"), self)
	CustomUIEvent("SharingShop_HeroCard_Exchange", Dynamic_Wrap(self, "OnHeroCard_Exchange"), self)
	CustomUIEvent("ShopItem_Buy", Dynamic_Wrap(self, "OnShopItem_Buy"), self)

	-- 黑市商店
	EventManager:register(ET_BATTLE.ON_BATTLEING_END, function()
		local iRound = Spawner:GetRound()
		local iremainder = iRound % MARKET_REFRESH_ROUND
		local sPlayerID = nil

		if iremainder == 0 and iRound >= MARKET_OCCURENCE_ROUND and iRound ~= 40 then
			local iRarity = self:CheckRoundMarketPossibility(iRound)
			for i = 1, MARKET_REFRESH_ITEMS do
				local sItemName = table.concat({ "item_unknowned_item_", iRarity })
				-- local chance = PlayerData:GetPlayerCount(true) * MARKET_REFRESH_CHANCE
				if RollPercentage(MARKET_REFRESH_CHANCE) then
					self:ItemMarket(sPlayerID, sItemName, iRarity)
				end
				-- local tItem = SelectItem:GetRandomItems(1, 0, sItemPools, {})
			end
		end
	end, nil, nil, nil)
end

--事件监听************************************************************************************************************************
	do
	function public:OnShopItem_Buy(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iShopItemID = tonumber(events.sShopItemID)
		local bIsGold = tonumber(events.bIsGold) == 1

		-- 验证商品存在
		local tItemData = self.tPlayerItems[iShopItemID]
		if not tItemData then
			ErrorMessage(iPlayerID, 'dota_hud_error_item_nil')
			return
		end

		-- 验证消耗
		local iCost
		if bIsGold then
			if tItemData.iItemRarity == 5 then
				iCost = self:GetHeroGoldBuy(tItemData.sCardName, tItemData.iXP)
			else
				if string.find(tItemData.sItenName, 'item_unknowned_item') then
					iCost = self:GetItemGoldBuy(tItemData.iItemRarity) * MARKET_ITEMBUYS_TIMES
				else
					iCost = self:GetItemGoldBuy(tItemData.iItemRarity)
				end
			end
			if not iCost or iCost > PlayerData:GetGold(iPlayerID) then
				ErrorMessage(iPlayerID, "dota_hud_error_not_enough_gold")
				return
			end
		else
			if tItemData.iItemRarity == 5 then
				iCost = self:GetHeroCrysBuy(tItemData.sCardName, tItemData.iXP)
			else
				if string.find(tItemData.sItenName, 'item_unknowned_item') then
					iCost = self:GetItemCrysBuy(tItemData.iItemRarity) * MARKET_ITEMBUYS_TIMES
				else
					iCost = self:GetItemCrysBuy(tItemData.iItemRarity)
				end
			end
			if not iCost or iCost > PlayerData:GetCrystal(iPlayerID) then
				ErrorMessage(iPlayerID, "dota_hud_error_not_enough_crystal")
				return
			end
		end

		-- 给玩家物品
		if tItemData.iItemRarity == 5 then
			local sCardName = tItemData.sCardName
			-- 验证手牌
			if HeroCardData:GetMaxHeroCardCount(iPlayerID) <= HeroCardData:GetPlayerHeroCardsCount(iPlayerID) then
				--手牌满了又有相同卡牌在手，自动升级
				---@type Card
				local hCard
				---@param hCard2 Card
				HeroCardData:EachCard(iPlayerID, function(hCard2)
					if hCard2.sCardName == sCardName and hCard2.iLevel < HERO_MAX_LEVEL then
						hCard = hCard2
						return true
					end
				end)
				if hCard then
					-- 手牌有卡给手牌升级
					HeroCardData:LevelUpCard(iPlayerID, hCard, tItemData.iXP + 1)
				else
					local bHasBuilding = false
					---@param hBuilding Building
					PlayerBuildings:EachBuilding(iPlayerID, function(hBuilding)
						if hBuilding:GetUnitEntityName() == sCardName and hBuilding:GetLevel() < HERO_MAX_LEVEL then
							-- 场内有卡
							bHasBuilding = true
							BuildSystem:AddExperience(hBuilding:GetUnitEntity(), nil, tItemData.iXP + 1)
							return true
						end
					end)
					if not bHasBuilding then
						ErrorMessage(iPlayerID, 'dota_hud_error_item_Full')
						return
					end
				end
			elseif not self:AddHero(iPlayerID, tItemData) then
				return
			end
		else
			if not self:AddItem(iPlayerID, tItemData) then
				return
			end
		end

		-- 消耗资源
		if bIsGold then
			PlayerData:ModifyGold(iPlayerID, -iCost)
		else
			PlayerData:ModifyCrystal(iPlayerID, -iCost)
		end

		-- 移除存在的卡片
		table.remove(self.tPlayerItems, iShopItemID)
		self:UpdateNetTables()
	end

	-- ---物品进入共享商店
	function public:OnItems_Exchange(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		if #self.tPlayerItems > MARKET_REFRESH_MAXCOUNT then
			ErrorMessage(iPlayerID, 'MarketShare_Full')
		end
		self:ItemExchange(iPlayerID, events.item_id)
	end
	-- ---卡片进入共享商店
	function public:OnHeroCard_Exchange(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		self:CardExchange(iPlayerID, events.iCardID)
	end
end
--事件监听************************************************************************************************************************
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("common", "exchanger_player_items", self.tPlayerItems)
end
-- 黑市物品添加
function public:ItemMarket(iPlayerID, sItenName, iItemRarity)
	local tItemDataKv = KeyValues.ItemsKv[sItenName]
	local iItemRarity = tItemDataKv.Rarity
	table.insert(self.tPlayerItems, {
		iPlayerID = iPlayerID,
		sItenName = sItenName,
		iItemRarity = iItemRarity,
	})

	Notification:ItemShare({
		player_id = iPlayerID,
		string_item_name = tostring("DOTA_Tooltip_ability_") .. tostring(sItenName),
		iItemRarity = iItemRarity,
		message = "#MarketShare_Item",
	})
	self:UpdateNetTables()
end
---物品共享
function public:ItemExchange(iPlayerID, iItemID)
	local tData = Items.tPlayerItems[iPlayerID][iItemID]
	if not tData then return end

	local sItenName = tData.sItemName
	if string.find(sItenName, 'item_unknowned_item') then
		ErrorMessage(iPlayerID, 'dota_hud_error_item_cant_exchange')
		return
	end

	local tItemDataKv = KeyValues.ItemsKv[sItenName]
	local iItemRarity = tItemDataKv.Rarity

	-- 自身物品删除
	if iItemRarity and iPlayerID ~= -1 then
		Items:RemoveItem(iPlayerID, iItemID)
		local iCrystal = self:GetItemExchangeGold(iItemRarity)
		PlayerData:ModifyCrystal(iPlayerID, iCrystal, true)
	end
	table.insert(self.tPlayerItems, {
		iPlayerID = iPlayerID,
		sItenName = sItenName,
		iItemRarity = iItemRarity,
	})

	Notification:ItemShare({
		player_id = iPlayerID,
		string_item_name = tostring("DOTA_Tooltip_ability_") .. tostring(sItenName),
		iItemRarity = iItemRarity,
		goldearn = self:GetItemExchangeGold(iItemRarity),
		message = "#Share_Item",
	})
	-- notification_item_share
	---@class EventData_PlayerItemShare
	local tEventData = {
		PlayerID = iPlayerID,
		sItenName = sItenName,
		iItemRarity = iItemRarity,
	}
	EventManager:fireEvent(ET_PLAYER.ON_ITEM_SHARE, tEventData)

	self:UpdateNetTables()
end


---卡片共享
function public:CardExchange(iPlayerID, iCardID)
	local iPlayerID = iPlayerID
	local iCardID = iCardID
	local tCardData = HeroCardData:GetPlayerCardData(iPlayerID, iCardID)
	if not tCardData then return end
	-- 存入网表刷新
	table.insert(self.tPlayerItems, {
		iPlayerID = iPlayerID,
		sCardName = tCardData.sCardName,
		iItemRarity = 5,
		iCardID = tCardData.iCardID,
		iLevel = tCardData.iLevel,
		iXP = tCardData.iXP,
		iNeededXPToLevel = self:NeededXPToLevel(tCardData.iLevel)
	})
	-- 更新网表
	self:UpdateNetTables()
	local exCardFactor = self:GetExchangeCardFactor()
	local iGold = HeroCardData:SellCard(iPlayerID, iCardID) * exCardFactor

	if iGold then
		---@class EventData_ON_TOWER_CARD_EXCHANGE
		local tEventData = {
			PlayerID = iPlayerID,
			iGoldReturn = iGold,
			---@type Card
			tCardData = tCardData,
			iCardID = iCardID,
		}
		EventManager:fireEvent(ET_PLAYER.ON_TOWER_CARD_EXCHANGE, tEventData)
		PlayerData:ModifyGold(iPlayerID, iGold, false)
		EmitSoundForPlayer('T3.coins', iPlayerID)

		-- 发出通知
		Notification:CardShare({
			player_id = iPlayerID,
			string_unit_name = tCardData.sCardName,
			goldearn = iGold,
			message = "#Share_Card",
		})

		return true
	end
	return false
end

--- 添加物品
function public:AddItem(iPlayerID, tItemData)
	local item = Items:AddItem(iPlayerID, tItemData.sItenName)
	Notification:ShareItemBuy({
		player_id = iPlayerID,
		string_item_name = "DOTA_Tooltip_ability_" .. tItemData.sItenName,
		iItemRarity = tItemData.iItemRarity,
		message = "#Buy_Share_Item",
	})
	-- GameTimer(1, function()
	-- 	if string.find(tItemData.sItenName, 'item_unknowned_item') then
	-- 		Items:RemoveItem(iPlayerID, item.iItemID, tItemData.iItemRarity)
	-- 		local sItemPools = table.concat({ "ItemLevel_", tItemData.iItemRarity })
	-- 		local tItem = SelectItem:GetRandomItems(1, iPlayerID, sItemPools, {})
	-- 		if tItem[1] then
	-- 			local tItemNew = Items:AddItem(iPlayerID, tItem[1].sItemName)
	-- 		end
	-- 	end
	-- end)
	-- EventManager:fireEvent(ET_PLAYER.ON_BUY_SHARINGITEM, {
	-- 	PlayerID = iPlayerID,
	-- 	sItemName = tItemData.sItenName,
	-- })
	return true
end
--- 添加英雄
function public:AddHero(iPlayerID, tItemData)
	-- 购买并获得
	local tCardData = HeroCardData:DefaultCardData(tItemData.sCardName, iPlayerID)
	HeroCardData:LevelUpCard(iPlayerID, tCardData, tItemData.iXP)
	HeroCardData:AddPlayerHeroCard(iPlayerID, tCardData)

	-- 发出通知
	Notification:ShareCardBuy({
		player_id = iPlayerID,
		string_unit_name = tItemData.sCardName,
		message = "#Buy_Share_Card",
	})


	return true
end

--- 获取物品出售金币
function public:GetItemExchangeGold(iRarity)
	return CARD_EXCHANGE_GOLD * ITEM_EXCHANGE_BUYCRYSTAL[iRarity] or 0
end
function public:GetItemGoldBuy(iRarity)
	return ITEM_EXCHANGE_BUYGOLD[iRarity] or 0
end
function public:GetItemCrysBuy(iRarity)
	return ITEM_EXCHANGE_BUYCRYSTAL[iRarity] or 0
end
function public:GetHeroGoldBuy(sCardName, iXP)
	return math.floor(HeroCardData:GetDefaultCardGold(sCardName) * (iXP + 1) * BUYCARD_EXCHANGE_GOLD)
end
function public:GetHeroCrysBuy(sCardName, iXP)
	return GAME_SHOP_HERO_COST[DotaTD:GetCardRarity(sCardName)] * (iXP + 1)
end

-- 获取英雄卡片相关
function public:GetExchangeCardFactor()
	return CARD_EXCHANGE_GOLD or 0
end
-- 英雄升级所需经验
function public:NeededXPToLevel(iLevel)
	return HERO_XP_PER_LEVEL_TABLE[iLevel + 1] or 0
end

--黑市刷新几率获取
function public:CheckRoundMarketPossibility(iRound)
	local tRoundData = KeyValues.WaveKv['round_' .. iRound]
	if tRoundData then
		function doonce(sRate)
			local tRarityWeight = {}
			local tRate = string.split(sRate, '|')
			if tRate then
				tRarityWeight['1'] = tonumber(tRate[1])
				tRarityWeight['2'] = tonumber(tRate[2])
				tRarityWeight['3'] = tonumber(tRate[3])
				tRarityWeight['4'] = tonumber(tRate[4])

			end
			local hRarityPool = WeightPool(tRarityWeight)
			local iRarity = hRarityPool:Random()
			return iRarity
		end
		return doonce(tRoundData.market_item_rate)
	end
end

return public