if HeroCard == nil then
	HeroCard = {}
end

---@class HeroCard
local public = HeroCard

function public:Init(bReload)
	if not bReload then
		self.tPlayerCards = {
		-- [iPlayerID]:{
		--		[cardid]: { -- 英雄卡ID
		-- 			xp
		-- 			total_xp
		-- 			level
		-- 			up
		-- 			count
		-- 		}
		-- }
		}

		self.tPlayerCardgroups = {
		-- [iPlayerID]:{
		-- 	[id]: {
		-- 		name
		-- 		group
		-- 		status
		-- 	}
		-- }
		}

		--- 默认卡牌成长信息
		self.tDefaultCardsGrowupInfo = {
		-- [cardid]:{
		-- 	[level]:{
		-- 		type:number
		-- 		xp:number
		-- 		bSpecial:number -- 是否突出显示
		-- 		val:number
		-- 		pay_type:number
		-- 		pay_val:number
		-- 	}
		-- }
		}
		--- 默认卡牌属性成长系数
		self.tHeroAttributeGrowupInfo = {
		-- [cardid]:{
		-- 	[typeid]: number
		-- }
		}
	end

	Request:Event("hero_card.update_card_group", Dynamic_Wrap(public, "UpdateCardGroup"), public)
	Request:Event("hero_card.set_default_card_group", Dynamic_Wrap(public, "UpdateCardGroupDefault"), public)
	Request:Event("hero_card.levelup", Dynamic_Wrap(public, "HeroCardLevelUp"), public)
end

function public:InitPlayerInfo(iPlayerID)
end

function public:UpdateNetTables()
	NetEventData:SetTableValue("service", "info_hero_growup", self.tDefaultCardsGrowupInfo)
end

----------------------------------------------------------------------------------------------------
-- Public
function public:SetPlayerHeroCards(iPlayerID, data)
	self.tPlayerCards[iPlayerID] = data
	DeepPrintTable(data)

	EventManager:fireEvent('UpdateExternalAttribute')
end

function public:GetPlayerHeroCardLevel(iPlayerID, iCardId)
	if self.tPlayerCards[iPlayerID] and self.tPlayerCards[iPlayerID][tostring(iCardId)] then
		return self.tPlayerCards[iPlayerID][tostring(iCardId)].level
	end
	return 0
end

function public:SetPlayerCardgroups(iPlayerID, data)
	self.tPlayerCardgroups[iPlayerID] = data
end

function public:SetHeroGrowupInfo(data)
	local tRes = {}
	for cardid, tLevelInfo in pairs(data) do
		local cardInfo = {}
		for iLevel, tInfo in pairs(tLevelInfo) do
			cardInfo[tostring(iLevel)] = {
				xp = tInfo[1],
				bSpecial = tInfo[2],
				type = tInfo[3],
				val = tInfo[4],
				pay_type = tInfo[5],
				pay_val = tInfo[6],
			}
		end
		tRes[tostring(cardid)] = cardInfo
	end
	self.tDefaultCardsGrowupInfo = tRes
	self:UpdateNetTables()
end

function public:SetHeroAttributeGrowupInfo(data)
	self.tHeroAttributeGrowupInfo = data
end

function public:GetPlayerOneCardDataByName(iPlayerID, sCardName)
	local cardid = DotaTD:GetCardID(sCardName)
	if not self.tPlayerCards[iPlayerID] then
		return nil
	end
	return self.tPlayerCards[iPlayerID][tostring(cardid)]
end

function public:GetPlayerOneCardGrowupInfo(iPlayerID, sCardName)
	local tGrowup = {}
	local cardid = DotaTD:GetCardID(sCardName)
	local tCardData = self:GetPlayerOneCardDataByName(iPlayerID, sCardName)
	local tCardGrowupInfo = self.tDefaultCardsGrowupInfo[tostring(cardid)]
	if tCardData and tCardGrowupInfo then
		local max = tonumber(tCardData.level)
		if tCardData.up == 1 then
			max = max + 1
		end
		for level = 1, max, 1 do
			if level > 1 then
				local tLevel = tCardGrowupInfo[tostring(level - 1)]
				if tLevel then
					tGrowup[tLevel.type] = tLevel.val + (tGrowup[tLevel.type] or 0)
				end
			end
		end
	end
	return tGrowup
end

---return: `{tCards = table, tCardGroup = table }`
function public:GetPlayerCardgroup(iPlayerID)
	return self.tPlayerCardgroups[iPlayerID]
end

--- 获取玩家卡组卡牌
function public:GetPlayerCardgroupCards(iPlayerID, iGroupID)
	if not self.tPlayerCardgroups[iPlayerID]
	or not self.tPlayerCardgroups[iPlayerID][iGroupID] then
		return false
	end

	local tCardGroupData = self.tPlayerCardgroups[iPlayerID][iGroupID]

	local group = json.decode(tCardGroupData.group)
	local tGroupCards = {}
	if group then
		for cardid, count in pairs(group) do
			tGroupCards[cardid] = count
		end
	end

	return tGroupCards
end

--- 获取卡牌默认属性成长系数
---@param iTypeID ATTRIBUTE_KIND
function public:GetCardDefaultAttributeCoefficient(sUnitName, iTypeID)
	local iID = tostring(DotaTD:GetCardID(sUnitName))
	iTypeID = tostring(iTypeID)
	if self.tHeroAttributeGrowupInfo[iID] then
		return self.tHeroAttributeGrowupInfo[iID][iTypeID]
	end
end

----------------------------------------------------------------------------------------------------
--UI EVENT
--- 更新卡组数据
--- params: 必带参数 id， 可选参数  name，group
function public:UpdateCardGroup(params)
	local iPlayerID = params.PlayerID

	-- 判断参数
	if (not params.id) or (params.group == nil and params.name == nil) then
		return '#ParamError'
	end

	-- 判断玩家数据
	local tCardGroupData = self.tPlayerCardgroups[iPlayerID]
	if not tCardGroupData
	or not tCardGroupData[params.id] then
		return '#ParamError'
	end

	local tData = {
		uid = GetAccountID(iPlayerID),
		index = params.id
	}

	if params.group then
		-- 检查卡组数据
		local iCount = 0
		local tCards = self.tPlayerCards[iPlayerID]
		local tCheckGroup = {}
		local tGroup = json.decode(params.group)
		if tGroup then
			for cardid, count in pairs(tGroup) do
				if 0 < count then
					if tCards[tostring(cardid)] or tCards[tonumber(cardid)] then
						if 1 < count then
							-- 验证是否有金卡，才可携带2张
							local t = self:GetPlayerOneCardGrowupInfo(iPlayerID, DotaTD:GetCardName(cardid))
							if nil ~= t[CardGrowupType.GoldCard] then
								tCheckGroup[cardid] = 2
							else
								tCheckGroup[cardid] = 1
							end
						else
							tCheckGroup[cardid] = 1
						end
						iCount = iCount + tCheckGroup[cardid]
					end
				end
			end
		end
		if iCount > GROUP_CARD_CARD_COUNT then
			return 'dota_hud_error_group_card_count'
		end
		if iCount < GROUP_CARD_CARD_COUNT_MIN then
			return 'dota_hud_error_group_card_count_min'
		end
		if iCount == 0 then
			tData.group = ''
		else
			tData.group = json.encode(tCheckGroup)
		end
	end

	if params.name then
		tData.name = params.name
	end

	local data = Service:POSTSync('card_group.update', tData)
	return data
end

--- 设置卡组默认
function public:UpdateCardGroupDefault(params)
	local iPlayerID = params.PlayerID
	local iGreoupID = params.id

	local tCardgroupData = self.tPlayerCardgroups[iPlayerID]

	if not tCardgroupData
	or not tCardgroupData[iGreoupID] then
		return 'ParamError'
	end

	local tGroup = json.decode(tCardgroupData[iGreoupID].group) or {}
	local iCount = 0
	for k, v in pairs(tGroup) do
		iCount = iCount + tonumber(v)
	end
	if iCount > GROUP_CARD_CARD_COUNT then
		return 'dota_hud_error_group_card_count'
	end
	if iCount < GROUP_CARD_CARD_COUNT_MIN then
		return 'dota_hud_error_group_card_count_min'
	end

	local data = Service:POSTSync('equip.set', {
		uid = GetAccountID(iPlayerID),
		cardgroup = iGreoupID,
	})

	return data
end

--- 获取卡牌某级升级
function public:HeroCardLevelUp(params)
	local iPlayerID = params.PlayerID
	local sCardName = params.card_name
	local sCardID = tostring(DotaTD:GetCardID(sCardName))

	local tCardInfo = self.tPlayerCards[iPlayerID][sCardID]
	if not tCardInfo then
		return 'error_not_have_card'
	end
	if tonumber(tCardInfo.up) == 1 then
		return 'error_card_level_max'
	end
	local tDefaultInfo = self.tDefaultCardsGrowupInfo[sCardID]
	if not tDefaultInfo then
		return 'error_not_found_card_default_info'
	end
	tDefaultInfo = tDefaultInfo[tostring(tCardInfo.level)]
	if not tDefaultInfo then
		return 'error_not_found_card_default_level_info'
	end

	-- 验证经验已满
	local iHeroXP = tonumber(tCardInfo.xp) or 0
	local iCommonXP = 0
	local iLevelXP = tonumber(tDefaultInfo.xp) or 0
	local tTokens = NetEventData:GetTableValue('service', 'player_tokens_' .. iPlayerID)
	if tTokens then
		iCommonXP = tonumber(tTokens['heroxp']) or 0
	end
	if iHeroXP + iCommonXP < iLevelXP then
		return 'error_xp_not_enough'
	end

	-- 验证升级消耗货币
	local tCurrency = NetEventData:GetTableValue('service', 'player_currency_' .. iPlayerID)
	if tCurrency then
		local iCost = tonumber(tDefaultInfo.pay_val) or 0
		local iCurrency = 0
		local typePay = PayType[tDefaultInfo.pay_type]
		iCurrency = tonumber(tCurrency[typePay]) or 0
		if iCurrency < iCost then
			return 'error_not_enough_' .. typePay
		end
	end

	-- 请求升级
	local tData = {
		--account id
		uid = GetAccountID(iPlayerID),
		--英雄id
		sid = sCardID,
	}
	local data = Service:POSTSync('hero.up', tData)

	if data and -1 ~= data.status then
		---@class EventData_PlayerHeroCardGrowupLevelup
		local tEventData = {
			PlayerID = iPlayerID,
			sCardID = sCardID,
			sCardName = sCardName,
		}
		EventManager:fireEvent(ET_PLAYER.ON_HERO_CARD_GROWUP_LEVELUP, tEventData)
	end

	return data
end

--- 英雄卡加经验
function public:HeroCardAddXP(params)
	local iPlayerID = params.PlayerID
	local sCardName = params.card_name
	local sCardID = tostring(DotaTD:GetCardID(sCardName))

	-- 计算升级所需经验
	local iLevel = 1
	local iCurXP = 0
	local iLevelUpXP = 0
	local tPlayerCards = NetEventData:GetTableValue('service', 'player_herocards_' .. iPlayerID)
	local tCardData = tPlayerCards[sCardID]
	if tCardData then
		iLevel = tonumber(tCardData['level'])
		iCurXP = tonumber(tCardData['xp'])
	else
		local data = Service:POSTSync('hero.buy', {
			uid = PlayerResource:GetSteamAccountID(iPlayerID),
			sid = sCardID,
		})
	end
	local tHeroGrowupDefault = NetEventData:GetTableValue('service', 'info_hero_growup')
	local tDefaultCardData = tHeroGrowupDefault[sCardID]
	if tDefaultCardData then
		local tLevelData = tDefaultCardData[tostring(iLevel)]
		if tLevelData then
			iLevelUpXP = tonumber(tLevelData.xp)
		end
	end
	local iNeedXP = iLevelUpXP - iCurXP
	if 0 >= iNeedXP then
		return
	end
	-- 验证消耗
	local iCurHeroXPToken = 0
	local tPlayerTokens = NetEventData:GetTableValue('service', 'player_tokens_' .. iPlayerID)
	if tPlayerTokens then
		iCurHeroXPToken = tonumber(tPlayerTokens['heroxp'])
	end
	if iCurHeroXPToken < iNeedXP then
		return '#error_heroxp_token_not_enoght'
	end

	-- 请求加经验
	local tData = {
		--account id
		uid = PlayerResource:GetSteamAccountID(iPlayerID),
		--英雄id
		sid = sCardID,
		--经验
		xp = iNeedXP
	}

	local data = Service:POSTSync('hero.addxp', tData)
	return data
end