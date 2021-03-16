if SelectItem == nil then

	---@class SelectItemData 玩家选装备数据
	SelectItemData = {
		---@type number 回合数
		iRound = nil,
		---@type {sItemName:string,is_ability:boolean}[] 可选项目
		tItems = nil,
		iRefresh = SELECT_ITEM_REFRESH_COUNT,
		fTimeout = SELECT_ITEM_TIMEOUT,
		iGiveUpGold = SELECT_ITEM_REFRESH_COUNT,
		iGiveUpCrystal = SELECT_ITEM_REFRESH_COUNT,
		tRandomInfo = nil,
	}

	---@class SelectItem
	SelectItem = {
		---玩家可选的物品（个人独立）
		---@type SelectItemData[][]
		tPlayerItems = {},
		---等待队列
		---@type SelectItemData[][]
		tPlayerItemsWaitList = {},

		iSelectIndex = 0,

		--队伍内可选的物品（团队分配）
		tTeamItems = {
			--物品信息列表
			tItemsInfo = {
				{
					sItemName = nil,
					iOwnerID = nil,
					iIndex = nil,
				},
			},
			--挑选顺序 PlayerID
			tSelectOrder = nil,
			--当前挑选的玩家
			iCurPlayerID = nil,
			--当前挑选结束时间
			iOverTime = nil,
			--单次时限
			iTimeOut = nil,
		},

		tItemPools = nil, --物品权重池
		tArtifactPools = nil, --神器权重池
	}
	SelectItem = class({}, SelectItem)
end
---@type SelectItem
local public = SelectItem

function public:init(bReload)
	CustomUIEvent("ItemSelected", Dynamic_Wrap(public, "OnItemSelected"), public)
	CustomUIEvent("ItemRefresh", Dynamic_Wrap(public, "OnItemRefresh"), public)
	CustomUIEvent("ItemGiveUp", Dynamic_Wrap(public, "OnItemGiveUp"), public)
	CustomUIEvent("TeamItemSelected", Dynamic_Wrap(public, "OnTeamItemSelected"), public)

	EventManager:register(ET_PLAYER.LEVEL_CHANGED, 'OnLevelChanged', self)

	if not bReload then
		self.tPlayerItems = {}
		self.tPlayerItemsWaitList = {}
		self.tTeamItems = {}
	end

	--加载物品权重池
	self.tItemPools = {}
	for sPoolName, t in pairs(KeyValues.ItemPoolKv) do
		if sPoolName == 'Item_ALL' then
			t = {}
			for k, v in pairs(KeyValues.ItemsKv) do
				if "table" == type(v) then
					if not v.ItemRecipe or 1 ~= v.ItemRecipe then
						t[k] = 1
					end
				end
			end
		end
		self.tItemPools[sPoolName] = WeightPool(t)
	end
	--加载神器权重池
	self.tArtifactPools = {}
	for sPoolName, t in pairs(KeyValues.ArtifactPoolKv) do
		if sPoolName == 'Artifact_ALL' then
			t = {}
			for k, v in pairs(KeyValues.ArtifactKv) do
				if "table" == type(v) then
					t[k] = 1
				end
			end
		end
		self.tArtifactPools[sPoolName] = WeightPool(t)
	end
end

--UI事件************************************************************************************************************************
	do
	--玩家选择物品（个人挑选界面）
	function public:OnItemSelected(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local sItemName = events.item_name
		local index = tonumber(events.index)

		local tSelectData = self.tPlayerItems[iPlayerID][index]
		local tInfo
		if not tSelectData or not exist(tSelectData.tItems, function(tData)
			if tData.sItemName == sItemName then
				tInfo = tData
				return true
			end
		end) then return end

		if PlayerData:IsPlayerDeath(iPlayerID) then return end

		if tInfo.is_ability then
			Artifact:Add(iPlayerID, sItemName)
		else
			Items:AddItem(iPlayerID, sItemName)
		end

		self:DelPlayerSelection(iPlayerID, index)
	end
	--玩家刷新物品
	function public:OnItemRefresh(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local index = tonumber(events.index)

		local tSelectData = self.tPlayerItems[iPlayerID][index]
		if not tSelectData then return end
		if PlayerData:IsPlayerDeath(iPlayerID) then return end

		tSelectData.iRefresh = PlayerData:GetRefreshTimes(iPlayerID)
		if 0 >= tSelectData.iRefresh then return end
		if 0 >= tSelectData.imax_refreshtimes then return end

		-- 请求
		local tData = {
			uid = GetAccountID(iPlayerID),
			sid = '1129001',
		}
		local data = Service:POST('item.use', tData, function(data)
			if data and data.status == 0 then

				tSelectData.imax_refreshtimes = tSelectData.imax_refreshtimes - 1
				PlayerData:ModifyRefreshTimes(iPlayerID)

				local tItemsOld = {}
				for _, v in pairs(tSelectData.tItems) do
					table.insert(tItemsOld, v.sItemName)
				end

				tSelectData.tItems = {}
				for _, v in pairs(tSelectData.tRandomInfo) do
					local tIgnore = deepcopy(tItemsOld)
					for _, v in pairs(tSelectData.tItems) do
						table.insert(tIgnore, v.sItemName)
					end
					tSelectData.tItems = concat(tSelectData.tItems, self:GetRandomItems(v.iCount, iPlayerID, v.sPool, tIgnore))
				end
				self:UpdateNetTables()

			else
				ErrorMessage(iPlayerID, 'dota_hud_error_not_enough_cunsumable')
			end
		end)
	end
	--玩家放弃物品
	function public:OnItemGiveUp(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local index = tonumber(events.index)

		local tSelectData = self.tPlayerItems[iPlayerID][index]
		if not tSelectData then return end
		if PlayerData:IsPlayerDeath(iPlayerID) then return end

		if 0 ~= tSelectData.iGiveUpGold then
			PlayerData:ModifyGold(iPlayerID, tSelectData.iGiveUpGold)
		end
		if 0 ~= tSelectData.iGiveUpCrystal then
			PlayerData:ModifyCrystal(iPlayerID, tSelectData.iGiveUpCrystal)
		end

		self:DelPlayerSelection(iPlayerID, index)
	end
	--玩家选择物品（团队挑选界面）
	function public:OnTeamItemSelected(eventSourceIndex, events)
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
			self:SelectTeamItem(iPlayerID, iIndex)
		end
	end
end
--事件监听************************************************************************************************************************
	do
	--- 玩家全部加载
	function public:InitPlayerSelectItemData(tEvent)
		local iPlayerID = tEvent.PlayerID
		self.tPlayerItems[iPlayerID] = {}
		self.tPlayerItemsWaitList[iPlayerID] = {}
	end
	--- 检查是否需要 五谷丰登
	function public:CheckSelectItemOnBattleEnd(tRoundData)
		if not tRoundData or not tRoundData.select_items then
			return
		end

		--物品总数
		local iSum = tRoundData.select_items_count
		if not iSum then return end

		--挑选模式
		if not tRoundData.select_items_mode or 1 == tRoundData.select_items_mode then
			--各人独立
			DotaTD:EachPlayer(function(_, iPlayerID)
				if PlayerData:IsPlayerDeath(iPlayerID) then return end

				local iSum = iSum
				if Spawner:IsMobsRound() and 1 ~= PlayerData:GetPlayerRoundResult(iPlayerID, Spawner:GetRound()) then
					--精英关该玩家没过不给奖励
					return
				end

				---@type SelectItemData
				local tData = {
					iRound = Spawner:GetRound(),
					iRefresh = PlayerData:GetPlayerRefreshTimes(iPlayerID),
					imax_refreshtimes = 1,
					-- imax_refreshtimes = PlayerData:GetPlayerRefreshTimesLeft(iPlayerID),
					fTimeout = GameRules:GetGameTime() + SELECT_ITEM_TIMEOUT,
					iGiveUpGold = SELECT_ITEM_GIVEUP_GOLD,
					iGiveUpCrystal = SELECT_ITEM_GIVEUP_CRYSTAL,
					tItems = {},
					tRandomInfo = {
						{
							sPool = tRoundData.select_items,
							iCount = iSum,
						},
					},
				}


				if Spawner:IsBossRound() and 1 == PlayerData:GetPlayerRoundResult(iPlayerID, Spawner:GetRound()) then
					--BOSS胜利玩家
					local sPoolName = LoadKvMultiVal(tRoundData.select_items)[1]
					local bAblt = nil == self.tItemPools[sPoolName]
					if bAblt then
						--额外抽一次装备
						local tSelectInfo = SELECT_ITEM_BY_BOSS_WIN[Spawner:GetRound()]
						if tSelectInfo and 0 < tSelectInfo.select_items_count then
							table.insert(tData.tRandomInfo, {
								sPool = tSelectInfo.select_items,
								iCount = tSelectInfo.select_items_count,
							})
						end
					end
				end

				self:AddPlayerSelection(iPlayerID, tData)
			end)
		elseif 2 == tRoundData.select_items_mode then
			--团队分配
			--物品
			local tItems = self:GetRandomItems(iSum, nil, tRoundData.select_items)
			self.tTeamItems.tItemsInfo = {}
			for i, tItemInfo in ipairs(tItems) do
				tItemInfo.iIndex = i
				tItemInfo.iOwnerID = -1
				self.tTeamItems.tItemsInfo[i] = tItemInfo
			end

			--挑选顺序
			self.tTeamItems.tSelectOrder = {}
			DotaTD:EachPlayer(function(_, iPlayerID)
				if not PlayerData:IsPlayerDeath(iPlayerID) then
					table.insert(self.tTeamItems.tSelectOrder, iPlayerID)
				end
			end)

			self.tTeamItems.iCurPlayerID = self.tTeamItems.tSelectOrder[1]
			self.tTeamItems.iTimeOut = tRoundData.select_items_time or 10
			self.tTeamItems.iOverTime = GameRules:GetGameTime() + self.tTeamItems.iTimeOut

			--检查超时
			GameRules:GetGameModeEntity():GameTimer('UpdateSelectTeamTimeOut', 0.1, function()
				return self:UpdateSelectTeamTimeOut()
			end)
		end

		--通知UI
		self:UpdateNetTables()
	end
	---玩家升级给神器
	---@param tEvent EventData_PLAYER_LEVEL_CHANGED
	function public:OnLevelChanged(tEvent)
		local iPlayerID = tEvent.PlayerID
		for i = tEvent.iCount - tEvent.iChange + 1, tEvent.iCount do
			if i >= PLAYER_LEVEL_GIEVE_ARTIFACT then
				--给一次神器选择
				---@type SelectItemData
				local tData = {
					iRound = Spawner:GetRound(),
					iRefresh = PlayerData:GetPlayerRefreshTimes(iPlayerID),
					imax_refreshtimes = 1,
					-- imax_refreshtimes = PlayerData:GetPlayerRefreshTimesLeft(iPlayerID),
					fTimeout = GameRules:GetGameTime() + SELECT_ITEM_TIMEOUT,
					iGiveUpGold = SELECT_ITEM_GIVEUP_GOLD,
					iGiveUpCrystal = SELECT_ITEM_GIVEUP_CRYSTAL,
					tItems = {},
					tRandomInfo = {
						{
							sPool = PLAYER_LEVEL_GIEVE_ARTIFACT_POOL,
							iCount = PLAYER_LEVEL_GIEVE_ARTIFACT_COUNT,
						},
					},
				}
				self:AddPlayerSelection(tEvent.PlayerID, tData)
			end
		end
	end
	---玩家死亡清理数据
	function public:OnPlayerDeath(iPlayerID)
		self.tPlayerItems[iPlayerID] = {}
		self:UpdateNetTables()
	end
end
--事件监听************************************************************************************************************************
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("select_item", "player_items", self.tPlayerItems)
	CustomNetTables:SetTableValue("select_item", "team_items", self.tTeamItems)
end

function public:GetSelectIndex()
	self.iSelectIndex = self.iSelectIndex + 1
	return self.iSelectIndex
end

--验证团队物品分配超时
function public:UpdateSelectTeamTimeOut()
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
		self:SelectTeamItem(self.tTeamItems.iCurPlayerID, tInfo.iIndex)
	end

	if self.tTeamItems.iOverTime then
		return 0.1
	end
end

--挑选团队分配的物品
function public:SelectTeamItem(iPlayerID, iIndex)
	local tInfo = self.tTeamItems.tItemsInfo[iIndex]
	if tInfo then
		tInfo.iOwnerID = self.tTeamItems.iCurPlayerID
		if not PlayerData:IsPlayerDeath(iPlayerID) then
			if tInfo.is_ability then
				EmitSoundForPlayer('T3.wow', iPlayerID)
				Artifact:Add(tInfo.iOwnerID, tInfo.sItemName)
			else
				self:GiveItem(tInfo.sItemName, tInfo.iOwnerID)
			end
		end
	end

	--切换下位挑选
	for i = KEY(self.tTeamItems.tSelectOrder, iPlayerID) + 1, #self.tTeamItems.tSelectOrder do
		local bHas = false
		local iNextPlayerID = self.tTeamItems.tSelectOrder[i]
		for _, tInfo in pairs(self.tTeamItems.tItemsInfo) do
			if tInfo.iOwnerID == iNextPlayerID then
				bHas = true
				break
			end
		end

		--找到未挑选的玩家
		if not bHas then
			self.tTeamItems.iCurPlayerID = iNextPlayerID
			self.tTeamItems.iOverTime = GameRules:GetGameTime() + self.tTeamItems.iTimeOut
			self:UpdateNetTables()
			return
		end
	end

	--结束挑选
	self.tTeamItems = {}
	self:UpdateNetTables()
end

---添加一次玩家物品选择任务
---@param tData SelectItemData
function public:AddPlayerSelection(iPlayerID, tData)
	local tPlayerSelect = self.tPlayerItems[iPlayerID]

	if 0 == TableCount(tPlayerSelect) then
		--直接开始任务
		for _, v in pairs(tData.tRandomInfo) do
			local tIgnore = {}
			for _, v2 in pairs(tData.tItems) do
				table.insert(tIgnore, v2.sItemName)
			end
			tData.tItems = concat(tData.tItems, self:GetRandomItems(v.iCount, iPlayerID, v.sPool, tIgnore))
		end
		local iSelectionID = self:GetSelectIndex()
		tPlayerSelect[iSelectionID] = tData
		GameTimer('ProcessSelectTimeOut' .. iSelectionID, SELECT_ITEM_TIMEOUT, function()
			self:ProcessSelectTimeOut(iPlayerID, iSelectionID)
		end)
		self:UpdateNetTables()
	else
		--加入等待队列
		local tPlayerWaitList = self.tPlayerItemsWaitList[iPlayerID]
		table.insert(tPlayerWaitList, tData)
	end
end

---移除一次玩家物品选择任务
---@param tData SelectItemData
function public:DelPlayerSelection(iPlayerID, iSelectionID)
	local tPlayerSelect = self.tPlayerItems[iPlayerID]
	tPlayerSelect[iSelectionID] = nil
	StopGameTimer('ProcessSelectTimeOut' .. iSelectionID)

	if 0 == TableCount(tPlayerSelect) then
		local tPlayerWaitList = self.tPlayerItemsWaitList[iPlayerID]
		if 0 < #tPlayerWaitList then
			--开启一等待任务
			local tData = tPlayerWaitList[1]
			table.remove(tPlayerWaitList, 1)
			self:AddPlayerSelection(iPlayerID, tData)
			return
		end
	end

	self:UpdateNetTables()
end

--处理一次选择物品超时
function public:ProcessSelectTimeOut(iPlayerID, iSelectID)
	local tSelectData = self.tPlayerItems[iPlayerID][iSelectID]
	if not tSelectData then return end

	if 0 < #tSelectData.tItems then
		local tItemData = tSelectData.tItems[RandomInt(1, #tSelectData.tItems)]
		if tItemData.is_ability then
			Artifact:Add(iPlayerID, tItemData.sItemName)
		else
			Items:AddItem(iPlayerID, tItemData.sItemName)
		end
	end

	self:DelPlayerSelection(iPlayerID, iSelectID)
end

--获取随机多个物品
function public:GetRandomItems(iCount, iPlayerID, sItemPools, tIgnore)
	local tIgnore = tIgnore or {}
	local tIgnoreLock = self:GetPlayerLockItems(iPlayerID)
	local tIgnoreLockAblt = self:GetPlayerLockArtifacts(iPlayerID)

	local tItemWeight = {}

	if type(Contract) == "table" and type(Contract.GetPlayerContractRewardName) == "function" then
		local sContractRewardName = Contract:GetPlayerContractRewardName(iPlayerID)
		if sContractRewardName then
			table.insert(tIgnore, sContractRewardName)
		end
	end

	-- 分配所有池子内物品的权重
	local tPools = DecodeKvMultiVal(sItemPools)
	for sPoolName, fPoolWeight in pairs(tPools) do
		---@type WeightPool
		local tItemPool = self.tItemPools[sPoolName]
		local bAblt = false
		if not tItemPool then
			bAblt = true
			tItemPool = self.tArtifactPools[sPoolName]
		end
		if tItemPool then
			local tTmpPool = WeightPool(tItemPool.tList)

			--移除重复
			tTmpPool:RemoveByTable(tIgnore)
			tTmpPool:RemoveByTable(tIgnoreLock)
			if bAblt then
				--神器
				tTmpPool:RemoveByTable(tIgnoreLockAblt)
				--移除自身拥有
				local tArts = Artifact:GetPlayerArtifacts(iPlayerID)
				tTmpPool:RemoveByTable(tArts)
				--移除未选的
				if iPlayerID and self.tPlayerItems[iPlayerID] then
					local tSelectItems = self.tPlayerItems[iPlayerID]
					for _, tSelectData in pairs(tSelectItems) do
						for _, t in pairs(tSelectData.tItems) do
							if t.is_ability then
								tTmpPool:Remove(t.sItemName)
							end
						end
					end
				end
			else
				--物品：计算现存数量
				local tNotMore = {}
				---@param tItemData ItemData
				Items:EachItems(iPlayerID, function(tItemData)
					if Items:IsItemCountToMax(iPlayerID, tItemData.sItemName) then
						table.insert(tNotMore, tItemData.sItemName)
					end
				end)
				tTmpPool:RemoveByTable(tNotMore)
			end

			-- 加入抽取权重
			for sItemName, fItemWeight in pairs(tTmpPool.tList) do
				local fChancePct = 100
				if bAblt then
				else
					fChancePct = GetDrawItemChancePercentage(iPlayerID, sItemName, sPoolName)
				end
				tItemWeight[sItemName] = (tItemWeight[sItemName] or 0) + fPoolWeight * fItemWeight * (fChancePct * 0.01)
			end
		end
	end

	local tItems = {}
	local arrItems = WeightPool(tItemWeight):RandomMulti(iCount)
	for _, sItem in ipairs(arrItems) do
		table.insert(tItems, {
			sItemName = sItem,
			is_ability = nil ~= KeyValues.AbilitiesKv[sItem],
		})
		table.insert(tIgnore, sItem)
	end
	return tItems
end

---获取玩家未解锁的物品数组
function public:GetPlayerLockItems(iPlayerID)
	local t = NetEventData:GetTableValue('service', 'player_item_' .. iPlayerID)
	if t then
		-- id转name
		local t2 = {}
		for _, sItemID in pairs(t) do
			local sItemName = Items:GetItemNameByGoodsID(sItemID)
			if sItemName then
				t2[sItemName] = true
			end
		end
		-- 反选未解锁
		t = {}
		for sItemName, v in pairs(KeyValues.ItemsKv) do
			if type(v) == 'table' and v.ID and not t2[sItemName] then
				-- 未解锁物品
				table.insert(t, sItemName)
			end
		end
		return t
	end

	-- 未获取到玩家解锁数据，使用默认配置
	if nil == self._GetPlayerLockItems_DefaultItems then
		t = {}
		self._GetPlayerLockItems_DefaultItems = t
		local tDefaultItem = LoadKeyValues("scripts/npc/kv/default_items.kv") or {}
		for sItemName, v in pairs(KeyValues.ItemsKv) do
			if type(v) == 'table' and v.ID and not tDefaultItem[sItemName] then
				-- 非默认物品
				table.insert(t, sItemName)
			end
		end
	end
	return self._GetPlayerLockItems_DefaultItems
end
---获取玩家未解锁的神器数组
function public:GetPlayerLockArtifacts(iPlayerID)
	local t = NetEventData:GetTableValue('service', 'player_artifact_' .. iPlayerID)
	if t then
		-- id转name
		local t2 = {}
		for _, sItemID in pairs(t) do
			local sItemName = Artifact:GetArtifactNameByGoodsID(sItemID)
			if sItemName then
				t2[sItemName] = true
			end
		end
		-- 反选未解锁
		t = {}
		for sItemName, v in pairs(KeyValues.ArtifactKv) do
			if type(v) == 'table' and not t2[sItemName] then
				-- 未解锁物品
				table.insert(t, sItemName)
			end
		end
		return t
	end

	-- 未获取到玩家解锁数据，使用默认配置
	if nil == self._GetPlayerLockArtifacts_DefaultItems then
		t = {}
		self._GetPlayerLockArtifacts_DefaultItems = t
		local tDefaultItem = LoadKeyValues("scripts/npc/kv/default_items.kv") or {}
		for sItemName, v in pairs(KeyValues.ArtifactKv) do
			if type(v) == 'table' and not tDefaultItem[sItemName] then
				-- 非默认物品
				table.insert(t, sItemName)
			end
		end
	end
	return self._GetPlayerLockArtifacts_DefaultItems
end

return public