if SelectSpellCard == nil then
	---@class SelectSpellCard
	SelectSpellCard = {
		---队伍内可选的物品（团队分配）
		tTeamItems = {
			---物品信息列表
			tItemsInfo = {
				{
					sItemName = nil,
					iOwnerID = nil,
					iIndex = nil,
				},
			},
			---挑选顺序 PlayerID
			tSelectOrder = nil,
			---当前挑选的玩家
			iCurPlayerID = nil,
			---当前挑选结束时间
			iOverTime = nil,
			---单次时限
			iTimeOut = nil,
			---单人挑选数量
			iTake = nil,
		},

		---法术卡牌权重池
		tSpellCardPools = nil,
	}
	SelectSpellCard = class({}, SelectSpellCard)
end

---@type SelectSpellCard
local public = SelectSpellCard

function public:init(bReload)
	CustomUIEvent("SelectedSpellCard", Dynamic_Wrap(public, "OnSelectedSpellCard"), public)

	if not bReload then
		self.tTeamItems = {}
	end

	--加载物品权重池
	self.tSpellCardPools = {}
	for sPoolName, t in pairs(KeyValues.SpellCardPoolKv) do
		if sPoolName == 'SpellCard_ALL' then
			t = {}
			for k, v in pairs(KeyValues.SpellKv) do
				if "table" == type(v) then
					t[k] = 1
				end
			end
		end
		self.tSpellCardPools[sPoolName] = WeightPool(t)
	end
end

--UI事件************************************************************************************************************************
	do
	--玩家选择法术牌
	function public:OnSelectedSpellCard(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iIndex = tonumber(events.item_index)

		if not self.tTeamItems.tItemsInfo then return end
		local tInfo = self.tTeamItems.tItemsInfo[iIndex]
		if not tInfo then return end

		--被选了
		if - 1 ~= tInfo.iOwnerID then return end

		if iPlayerID ~= self.tTeamItems.iCurPlayerID then
			--非操作玩家选择：广播公屏信息
		else
			--操作玩家选择：给物品
			self:Select(iPlayerID, iIndex)
		end
	end
end
--事件监听************************************************************************************************************************
	do
	--- 检查是否需要 选法术牌
	function public:CheckSelectSepllCard(tRoundData)
		if not tRoundData or not tRoundData.select_spellcards then
			return
		end

		--物品总数
		local iSum = tRoundData.select_spellcards_count
		if not iSum then return end

		local function GetItems(iCount)
			local tItems = {}
			for i = 1, iCount do
				local sPoolName = LoadKvMultiVal(tRoundData.select_spellcards)[1]
				---@type WeightPool
				local tItemPool = self.tSpellCardPools[sPoolName]
				if tItemPool then
					local sItem = tItemPool:Random()
					if sItem then
						table.insert(tItems, {
							sItemName = sItem,
						})
					end
				end
			end
			return tItems
		end

		--团队分配
		local tItems = GetItems(iSum)
		self.tTeamItems.tItemsInfo = {}
		for i, tItemInfo in ipairs(tItems) do
			tItemInfo.iIndex = i
			tItemInfo.iOwnerID = -1
			self.tTeamItems.tItemsInfo[i] = tItemInfo
		end

		--挑选顺序
		self.tTeamItems.tSelectOrder = {}
		DotaTD:EachPlayer(function(_, iPlayerID)
			table.insert(self.tTeamItems.tSelectOrder, iPlayerID)
		end)

		self.tTeamItems.iCurPlayerID = self.tTeamItems.tSelectOrder[1]
		self.tTeamItems.iTimeOut = tRoundData.select_spellcards_time or 10
		self.tTeamItems.iOverTime = GameRules:GetGameTime() + self.tTeamItems.iTimeOut
		self.tTeamItems.iTake = tRoundData.select_spellcards_take

		--检查超时
		GameRules:GetGameModeEntity():GameTimer('UpdateSelectSepllCardOut', 0.1, function()
			return self:UpdateSelectSepllCardOut()
		end)

		--通知UI
		self:UpdateNetTables()
	end
end
--事件监听************************************************************************************************************************
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("select_item", "spellcard", self.tTeamItems)
end

--- 随机技能卡牌
function public:RandomFromPool(iPlayerID, sPoolName)
	sPoolName = sPoolName or "SpellCard_ALL"
	---@type WeightPool
	local tItemPool = self.tSpellCardPools[sPoolName]
	if not tItemPool then return end

	local hPoolTemp = WeightPool(tItemPool.tList)
	local tIgnore = Draw:GetPlayerLockSpell(iPlayerID)
	hPoolTemp:RemoveByTable(tIgnore)

	local sItem = hPoolTemp:Random()
	if sItem then
		return sItem
	end
end


--- 遍历卡池所有法术卡
function public:EachCardinPool(iPlayerID, sPoolName, func)
	sPoolName = sPoolName or "SpellCard_ALL"
	---@type WeightPool
	local tItemPool = self.tSpellCardPools[sPoolName]
	if not tItemPool then return end

	local hPoolTemp = WeightPool(tItemPool.tList)
	local tIgnore = Draw:GetPlayerLockSpell(iPlayerID)
	hPoolTemp:RemoveByTable(tIgnore)

	for k, v in pairs(hPoolTemp.tList) do
		func(k)
	end
end

---验证玩家是否挑选完毕
function public:IsFinished(iPlayerID)
	local iTakeCur = #FindAll(self.tTeamItems.tItemsInfo, function(tInfo)
		return iPlayerID == tInfo.iOwnerID
	end)
	return iTakeCur >= self.tTeamItems.iTake
end

--验证挑选超时
function public:UpdateSelectSepllCardOut()
	if not self.tTeamItems.iOverTime then return end
	if GameRules:GetGameTime() < self.tTeamItems.iOverTime then
		return 0.1
	end

	--随机给物品
	local tItems = {}
	for _, tInfo in pairs(self.tTeamItems.tItemsInfo) do
		if - 1 == tInfo.iOwnerID then
			table.insert(tItems, tInfo)
		end
	end
	local tInfo = tItems[RandomInt(1, #tItems)]
	if tInfo then
		self:Select(self.tTeamItems.iCurPlayerID, tInfo.iIndex)
	end

	if self.tTeamItems.iOverTime then
		return 0.1
	end
end

--挑选
function public:Select(iPlayerID, iIndex)
	local tInfo = self.tTeamItems.tItemsInfo[iIndex]
	if tInfo then
		tInfo.iOwnerID = iPlayerID
		HandSpellCards:AddCard(iPlayerID, tInfo.sItemName)
	end

	if self:IsFinished(iPlayerID) then
		--切换下位挑选
		for i = KEY(self.tTeamItems.tSelectOrder, iPlayerID) + 1, #self.tTeamItems.tSelectOrder do
			local iNextPlayerID = self.tTeamItems.tSelectOrder[i]

			--找到未挑选的玩家
			if not self:IsFinished(iNextPlayerID) then
				self.tTeamItems.iCurPlayerID = iNextPlayerID
				self.tTeamItems.iOverTime = GameRules:GetGameTime() + self.tTeamItems.iTimeOut
				self:UpdateNetTables()
				return
			end
		end

		--结束挑选
		self.tTeamItems = {}
	else
		--该玩家继续选
	end

	self:UpdateNetTables()
end

return public