if Contract == nil then
	---@class Contract
	Contract = {
		---契约配置
		tContractConfig = nil,
		---玩家契约数据
		tPlayerContractData = nil,
		---玩家成功的契约列表
		tPlayerCompletedContracts = nil,
		---玩家失败的契约列表
		tPlayerFailedContracts = nil,
		---契约怪物
		tContractMonsterData = nil,
		---契约怪物诞生点表
		tSpawnPoints = nil,
		---契约怪物表
		tContractMonsters = nil,
	}
	Contract = class({}, Contract)
end
---@type Contract
local public = Contract

function public:init(bReload)
	if not bReload then
		self.tPlayerContractData = {}
		self.tPlayerCompletedContracts = {}
		self.tPlayerFailedContracts = {}
		self.tContractMonsters = {}
	end

	self.tContractConfig = {}
	for n, tData in pairs(KeyValues.ContractKv) do
		self.tContractConfig[tonumber(n)] = tData
	end

	self.tContractMonsterData = {}
	for sUnitName, tData in pairs(KeyValues.UnitsKv) do
		if type(tData) == "table" then
			if tonumber(tData.IsContractMonster) == 1 then
				table.insert(self.tContractMonsterData, {
					name = sUnitName,
					health = tData.StatusHealth or 0,
					physical_attack = tData.PhysicalAttack or 0,
					magical_attack = tData.MagicalAttack or 0,
					physical_armor = tData.PhysicalArmor or 0,
					magical_armor = tData.MagicalArmor or 0,
				})
			end
		end
	end

	self.tSpawnPoints = string.rsplit(string.gsub(CONTRACT_SPAWN_POINT, " ", ""), "|")

	CustomUIEvent("RefreshContract", Dynamic_Wrap(public, "OnRefreshContract"), public)
	CustomUIEvent("SelectContract", Dynamic_Wrap(public, "OnSelectContract"), public)

	EventManager:register(ET_ENEMY.ON_DEATH, "OnEnemyDeath", public, EVENT_LEVEL_NONE)
	EventManager:register(ET_ENEMY.ON_ENTER_DOOR, "OnEnemyEnterDoor", public, EVENT_LEVEL_NONE)

	EventManager:register(ET_BATTLE.ON_PREPARATION, "OnPreparation", public, EVENT_LEVEL_NONE)
	EventManager:register(ET_BATTLE.ON_BATTLEING, "OnBattleing", public, EVENT_LEVEL_NONE)
	EventManager:register(ET_BATTLE.ON_BATTLEING_END, "OnBattleingEnd", public, EVENT_LEVEL_NONE)

	self:UpdateNetTables()
end

function public:GetPlayerContractRewardName(iPlayerID)
	local tContract = self.tPlayerContractData[iPlayerID].tContracts[self.tPlayerContractData[iPlayerID].iSelectedContractIndex]
	if tContract then
		return tContract.reward_data.name
	end
end

function public:OnPlayerAddItemOrArtifact(iPlayerID, sName)
	for iIndex, tContract in pairs(self.tPlayerContractData[iPlayerID].tContracts) do
		if tContract.reward_data.name == sName then
			self:ResetConstractReward(iPlayerID, iIndex)
			break
		end
	end
end
--UI事件************************************************************************************************************************
	do
	--刷新契约
	function public:OnRefreshContract(eventSourceIndex, events)
		local iPlayerID = events.PlayerID

		if not DIFFICULTY_INFO[GameMode:GetDifficulty()].contract then
			return
		end

		-- if self.tPlayerContractData[iPlayerID].iFreeRefreshPoints <= 0 then
		if self.tPlayerContractData[iPlayerID].iState > 0 then
			ErrorMessage(iPlayerID, "dota_hud_error_has_ongoing_contract")
			return
		end

		local bIsStart = self.tPlayerContractData[iPlayerID].iState == -1

		local iGoldCost = bIsStart and self.tPlayerContractData[iPlayerID].iStartRefreshGoldCost or self.tPlayerContractData[iPlayerID].iRefreshGoldCost
		if PlayerData:GetGold(iPlayerID) < iGoldCost then
			ErrorMessage(iPlayerID, "dota_hud_error_not_enough_gold")
			return
		end

		local iCrystalCost = bIsStart and self.tPlayerContractData[iPlayerID].iStartRefreshCrystalCost or self.tPlayerContractData[iPlayerID].iRefreshCrystalCost
		if PlayerData:GetCrystal(iPlayerID) < iCrystalCost then
			ErrorMessage(iPlayerID, "dota_hud_error_not_enough_crystal")
			return
		end

		if bIsStart then
			self.tPlayerContractData[iPlayerID].iStartRefreshCount = self.tPlayerContractData[iPlayerID].iStartRefreshCount + 1
			self.tPlayerContractData[iPlayerID].iStartRefreshGoldCost = CONTRACT_START_REFRESH_GOLD_COST(self.tPlayerContractData[iPlayerID].iStartRefreshCount)
			self.tPlayerContractData[iPlayerID].iStartRefreshCrystalCost = CONTRACT_START_REFRESH_CRYSTAL_COST(self.tPlayerContractData[iPlayerID].iStartRefreshCount)
		else
			self.tPlayerContractData[iPlayerID].iContinuousRefreshCount = self.tPlayerContractData[iPlayerID].iContinuousRefreshCount + 1
			self.tPlayerContractData[iPlayerID].iRefreshGoldCost = CONTRACT_REFRESH_GOLD_COST(self.tPlayerContractData[iPlayerID].iContinuousRefreshCount)
			self.tPlayerContractData[iPlayerID].iRefreshCrystalCost = CONTRACT_REFRESH_CRYSTAL_COST(self.tPlayerContractData[iPlayerID].iContinuousRefreshCount)
		end

		PlayerData:ModifyGold(iPlayerID, -iGoldCost, false)
		PlayerData:ModifyCrystal(iPlayerID, -iCrystalCost, false)
		-- else
		-- 	self:ModifyFreeRefreshPoints(iPlayerID, -1)
		-- end
		self:RefreshConstract(iPlayerID)
	end
	function public:OnSelectContract(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iContractIndex = tonumber(events.contract_index)

		if not DIFFICULTY_INFO[GameMode:GetDifficulty()].contract then
			return
		end

		if type(iContractIndex) ~= "number" then
			return
		end

		if self.tPlayerContractData[iPlayerID].iState ~= 0 then
			ErrorMessage(iPlayerID, "dota_hud_error_has_ongoing_contract")
			return
		end
		if iContractIndex <= 0 or iContractIndex > #(self.tPlayerContractData[iPlayerID].tContracts) then
			return
		end

		self.tPlayerContractData[iPlayerID].iSelectedContractIndex = iContractIndex
		self.tPlayerContractData[iPlayerID].iState = 1

		if GSManager:getStateType() == GS_Preparation then
			if not Spawner:IsBossRound() and not Spawner:IsGoldRound() then
				self:StartContract(iPlayerID)
			end
		end

		self:UpdateNetTables()
	end
end
--事件监听
	do
	--- 初始化玩家数据
	function public:InitPlayerData(iPlayerID)
		self.tPlayerContractData[iPlayerID] = {
			iStartRefreshGoldCost = CONTRACT_START_REFRESH_GOLD_COST(0), -- 开始契约金币花费
			iStartRefreshCrystalCost = CONTRACT_START_REFRESH_CRYSTAL_COST(0), -- 开始契约魂晶花费
			iRefreshGoldCost = CONTRACT_REFRESH_GOLD_COST(0), -- 刷新契约金币花费
			iRefreshCrystalCost = CONTRACT_REFRESH_CRYSTAL_COST(0), -- 刷新契约魂晶花费
			tContracts = {}, -- 契约列表
			iCompletedContractCount = 0, -- 完成契约数
			iFailedContractCount = 0, -- 失败契约数
			iSelectedContractIndex = -1, -- 已选择的契约索引
			iState = -1, -- 进度 -1没有任何契约，0未接受任何其余，1接受了契约，2契约进行中，3成功完成契约，4失败契约
			iFreeRefreshPoints = 0, -- 免费刷新点
			iContinuousRefreshCount = 0, -- 连续刷新次数
			iStartRefreshCount = 0, -- 开始契约次数
		}
		self.tPlayerCompletedContracts[iPlayerID] = {}
		self.tPlayerFailedContracts[iPlayerID] = {}

		self:UpdateNetTables()
	end
	function public:OnPreparation()
		for i = #self.tContractMonsters, 1, -1 do
			local hMonster = self.tContractMonsters[i]
			table.remove(self.tContractMonsters, i)
			if IsValid(hMonster) then
				Spawner:KillEnemy(hMonster, true, false)
			end
		end
		self.tContractMonsters = {}

		local iRound = Spawner:GetRound()

		DotaTD:EachPlayer(function(n, iPlayerID)
			if self.tPlayerContractData[iPlayerID].iState == 3 or self.tPlayerContractData[iPlayerID].iState == 4 then
				self:ClearConstracts(iPlayerID)
				-- self:RefreshConstract(iPlayerID)
				-- elseif iRound % CONTRACT_AUTO_REFRESH_ROUND == 1 then
				-- 	self.tPlayerContractData[iPlayerID].iContinuousRefreshCount = 0
				-- 	self:RefreshConstract(iPlayerID)
			end
			-- if (iRound-CONTRACT_ADD_FREE_REFRESH_POINTS_START_ROUND) % CONTRACT_ADD_FREE_REFRESH_POINTS_ROUND == 0 then
			-- 	self:ModifyFreeRefreshPoints(iPlayerID, CONTRACT_ADD_FREE_REFRESH_POINTS)
			-- end
			if self.tPlayerContractData[iPlayerID].iState == 1 then
				if not Spawner:IsBossRound() and not Spawner:IsGoldRound() then
					self:StartContract(iPlayerID)
				end
			end
		end)
	end
	function public:OnBattleing()
		if Spawner:IsBossRound() or Spawner:IsGoldRound() then
			return
		end
		DotaTD:EachPlayer(function(n, iPlayerID)
			if self.tPlayerContractData[iPlayerID].iState == 1 then
				self.tPlayerContractData[iPlayerID].iState = 2
			end
		end)
		for _, hMonster in pairs(self.tContractMonsters) do
			if IsValid(hMonster) then
				local iPlayerID = hMonster.Spawner_spawnerPlayerID

				hMonster:RemoveModifierByName("modifier_ghost_enemy")
				hMonster:RemoveModifierByName("modifier_motion")
				hMonster:RemoveModifierByName("modifier_pudding")
				hMonster:AddNewModifier(hMonster, nil, "modifier_wave", nil)
				hMonster:AddNewModifier(hMonster, nil, "modifier_enemy_ai", nil)
				hMonster:AddNewModifier(hMonster, nil, "modifier_contract_monster", nil)
				table.insert(Spawner.PlayerMissing[iPlayerID], hMonster)

				EventManager:fireEvent(ET_ENEMY.ON_SPAWNED, {
					PlayerID = iPlayerID,
					hUnit = hMonster,
				})

				EventManager:fireEvent(ET_PLAYER.ENEMY_COUNT_CHANGE, {
					PlayerID = iPlayerID,
					MissingCount = Spawner:GetPlayerMissingCount(iPlayerID),
				})
			end
		end
		self:UpdateNetTables()
	end
	function public:OnBattleingEnd()
		DotaTD:EachPlayer(function(n, iPlayerID)
			-- 契约失败
			if self.tPlayerContractData[iPlayerID].iState == 2 then
				self:EndContract(iPlayerID, false)
			end
		end)
	end
	function public:OnEnemyDeath(events)
		local iPlayerID = events.PlayerID
		local hMonster = EntIndexToHScript(events.entindex_killed)
		if IsValid(hMonster) and TableFindKey(self.tContractMonsters, hMonster) ~= nil then
			-- 契约成功
			if self.tPlayerContractData[iPlayerID].iState == 2 then
				self:EndContract(iPlayerID, true)
			end
		end
	end
	function public:OnEnemyEnterDoor(events)
		local hMonster = EntIndexToHScript(events.entindex)
		if IsValid(hMonster) then
			ArrayRemove(self.tContractMonsters, hMonster)
		end
	end
end
--
function public:ClearConstracts(iPlayerID)
	self.tPlayerContractData[iPlayerID].iContinuousRefreshCount = 0
	self.tPlayerContractData[iPlayerID].iRefreshGoldCost = CONTRACT_REFRESH_GOLD_COST(self.tPlayerContractData[iPlayerID].iContinuousRefreshCount)
	self.tPlayerContractData[iPlayerID].iRefreshCrystalCost = CONTRACT_REFRESH_CRYSTAL_COST(self.tPlayerContractData[iPlayerID].iContinuousRefreshCount)

	self.tPlayerContractData[iPlayerID].tContracts = {}
	self.tPlayerContractData[iPlayerID].iSelectedContractIndex = -1
	self.tPlayerContractData[iPlayerID].iState = -1
	if self.tPlayerContractData[iPlayerID].iFreeRefreshPoints > 0 then
		self.tPlayerContractData[iPlayerID].iFreeRefreshPoints = self.tPlayerContractData[iPlayerID].iFreeRefreshPoints - 1
		self:RefreshConstract(iPlayerID)
	end
	self:UpdateNetTables()
end
function public:ResetConstractReward(iPlayerID, iIndex)
	if iIndex == nil then
		for iIndex, v in pairs(self.tPlayerContractData[iPlayerID].tContracts) do
			self:ResetConstractReward(iPlayerID, iIndex)
		end
		return
	end
	local tContract = self.tPlayerContractData[iPlayerID].tContracts[iIndex]
	local tContractData = self.tContractConfig[tContract.level]
	local tReservoirs = WeightPool({})

	local tItemReservoir = {}
	if type(tContractData.item_pool) == "string" then
		local str = string.gsub(tContractData.item_pool, " ", "")
		local a = string.split(str, "|")
		for _, s in pairs(a) do
			local b = string.split(s, "#")
			if type(b[1]) == "string" then
				if tonumber(b[2]) ~= nil then
					tItemReservoir[b[1]] = b[2]
				end
			end
		end
	end
	for k, v in pairs(tItemReservoir) do
		tReservoirs:Add(k, v)
	end

	local tArtifactReservoir = {}
	if type(tContractData.artifact_pool) == "string" then
		local str = string.gsub(tContractData.artifact_pool, " ", "")
		local a = string.split(str, "|")
		for _, s in pairs(a) do
			local b = string.split(s, "#")
			if type(b[1]) == "string" then
				if tonumber(b[2]) ~= nil then
					tArtifactReservoir[b[1]] = b[2]
				end
			end
		end
	end
	for k, v in pairs(tArtifactReservoir) do
		tReservoirs:Add(k, v)
	end

	local tSpellCardReservoir = {}
	if type(tContractData.spellcard_pool) == "string" then
		local str = string.gsub(tContractData.spellcard_pool, " ", "")
		local a = string.split(str, "|")
		for _, s in pairs(a) do
			local b = string.split(s, "#")
			if type(b[1]) == "string" then
				if tonumber(b[2]) ~= nil then
					tSpellCardReservoir[b[1]] = b[2]
				end
			end
		end
	end
	for k, v in pairs(tSpellCardReservoir) do
		tReservoirs:Add(k, v)
	end

	local tHeroCardReservoir = {}
	if type(tContractData.herocard_pool) == "string" then
		local str = string.gsub(tContractData.herocard_pool, " ", "")
		local a = string.split(str, "|")
		for _, s in pairs(a) do
			local b = string.split(s, "#")
			if type(b[1]) == "string" then
				if tonumber(b[2]) ~= nil then
					tHeroCardReservoir[b[1]] = b[2]
				end
			end
		end
	end
	for k, v in pairs(tHeroCardReservoir) do
		tReservoirs:Add(k, v)
	end
	local tPlayerCardList = {}
	if type(Draw.tPlayerCards[iPlayerID]) == "table" then
		for sRarity, tList in pairs(Draw.tPlayerCards[iPlayerID]) do
			for sCardName, iCount in pairs(tList) do
				tPlayerCardList[sCardName] = 1
			end
		end
	end

	local tRewards = {}
	for k, v in pairs(self.tPlayerContractData[iPlayerID].tContracts) do
		table.insert(tRewards, v.reward_data.name)
	end
	local sReward
	local sRewardType
	local iRewardAmount = 1
	local iMaxAttempts = 16
	local iAttempts = 0
	while iAttempts < iMaxAttempts do
		local sResultPool = tReservoirs:Random()
		if tItemReservoir[sResultPool] ~= nil and SelectItem.tItemPools[sResultPool] ~= nil then
			local tItemInfo = SelectItem:GetRandomItems(1, iPlayerID, sResultPool, { unpack(tRewards) })
			if tItemInfo[1] ~= nil then
				sReward = tItemInfo[1].sItemName
				sRewardType = "item"
			end
		end
		if tArtifactReservoir[sResultPool] ~= nil and SelectItem.tArtifactPools[sResultPool] ~= nil then
			local tItemInfo = SelectItem:GetRandomItems(1, iPlayerID, sResultPool, { unpack(tRewards) })
			if tItemInfo[1] ~= nil then
				sReward = tItemInfo[1].sItemName
				sRewardType = "artifact"
			end
		end
		if tSpellCardReservoir[sResultPool] ~= nil and SelectSpellCard.tSpellCardPools[sResultPool] ~= nil then
			sReward = SelectSpellCard:RandomFromPool(iPlayerID, sResultPool)
			local a = string.split(sReward, ",")
			sReward = a[1]
			iRewardAmount = tonumber(a[2]) or iRewardAmount
			sRewardType = "spellcard"
		end
		if tHeroCardReservoir[sResultPool] ~= nil and Draw.tHeroCardPools[sResultPool] ~= nil then
			local tHeroCardPool = WeightPool(Draw.tHeroCardPools[sResultPool].tList)
			for sCardName, iWeight in pairs(tHeroCardPool.tList) do
				local a = string.split(sCardName, ",")
				if tPlayerCardList[a[1]] == nil then
					tHeroCardPool.tList[sCardName] = nil
				end
			end
			tHeroCardPool:update()

			sReward = tHeroCardPool:Random()
			local a = string.split(sReward, ",")
			sReward = a[1]
			iRewardAmount = tonumber(a[2]) or iRewardAmount
			sRewardType = "herocard"
		end
		if TableFindKey(tRewards, sReward) == nil and sReward ~= nil then
			break
		end
		iAttempts = iAttempts + 1
	end

	print(sReward)
	if sReward then
		tContract.reward_data = {
			name = sReward,
			type = sRewardType,
			amount = iRewardAmount,
		}
	end

	self:UpdateNetTables()
end
function public:RefreshConstract(iPlayerID)
	local iContinuousRefreshCount = self.tPlayerContractData[iPlayerID].iContinuousRefreshCount
	local iRound = Spawner:GetRound()
	local iLevel = Clamp(iRound + self.tPlayerContractData[iPlayerID].iCompletedContractCount * CONTRACT_LEVEL_FACTOR + CONTRACT_CONTINUOUS_LEVEL_FACTOR(iContinuousRefreshCount), 1, #self.tContractConfig)
	local tContractData = self.tContractConfig[iLevel]
	local tReservoirs = WeightPool({})

	local tItemReservoir = {}
	if type(tContractData.item_pool) == "string" then
		local str = string.gsub(tContractData.item_pool, " ", "")
		local a = string.split(str, "|")
		for _, s in pairs(a) do
			local b = string.split(s, "#")
			if type(b[1]) == "string" then
				if tonumber(b[2]) ~= nil then
					tItemReservoir[b[1]] = b[2]
				end
			end
		end
	end
	for k, v in pairs(tItemReservoir) do
		tReservoirs:Add(k, v)
	end

	local tArtifactReservoir = {}
	if type(tContractData.artifact_pool) == "string" then
		local str = string.gsub(tContractData.artifact_pool, " ", "")
		local a = string.split(str, "|")
		for _, s in pairs(a) do
			local b = string.split(s, "#")
			if type(b[1]) == "string" then
				if tonumber(b[2]) ~= nil then
					tArtifactReservoir[b[1]] = b[2]
				end
			end
		end
	end
	for k, v in pairs(tArtifactReservoir) do
		tReservoirs:Add(k, v)
	end

	local tSpellCardReservoir = {}
	if type(tContractData.spellcard_pool) == "string" then
		local str = string.gsub(tContractData.spellcard_pool, " ", "")
		local a = string.split(str, "|")
		for _, s in pairs(a) do
			local b = string.split(s, "#")
			if type(b[1]) == "string" then
				if tonumber(b[2]) ~= nil then
					tSpellCardReservoir[b[1]] = b[2]
				end
			end
		end
	end
	for k, v in pairs(tSpellCardReservoir) do
		tReservoirs:Add(k, v)
	end

	local tHeroCardReservoir = {}
	if type(tContractData.herocard_pool) == "string" then
		local str = string.gsub(tContractData.herocard_pool, " ", "")
		local a = string.split(str, "|")
		for _, s in pairs(a) do
			local b = string.split(s, "#")
			if type(b[1]) == "string" then
				if tonumber(b[2]) ~= nil then
					tHeroCardReservoir[b[1]] = b[2]
				end
			end
		end
	end
	for k, v in pairs(tHeroCardReservoir) do
		tReservoirs:Add(k, v)
	end
	local tPlayerCardList = {}
	if type(Draw.tPlayerCards[iPlayerID]) == "table" then
		for sRarity, tList in pairs(Draw.tPlayerCards[iPlayerID]) do
			for sCardName, iCount in pairs(tList) do
				tPlayerCardList[sCardName] = 1
			end
		end
	end

	self.tPlayerContractData[iPlayerID].tContracts = {}
	local tRewards = {}
	local tMonsters = {}
	for i = 1, CONTRACT_REFRESH_AMOUNT, 1 do
		local sReward
		local sRewardType
		local iRewardAmount = 1
		local iMaxAttempts = 16
		local iAttempts = 0
		while iAttempts < iMaxAttempts do
			local sResultPool = tReservoirs:Random()
			if tItemReservoir[sResultPool] ~= nil and SelectItem.tItemPools[sResultPool] ~= nil then
				local tItemInfo = SelectItem:GetRandomItems(1, iPlayerID, sResultPool, { unpack(tRewards) })
				if tItemInfo[1] ~= nil then
					sReward = tItemInfo[1].sItemName
					sRewardType = "item"
				end
			end
			if tArtifactReservoir[sResultPool] ~= nil and SelectItem.tArtifactPools[sResultPool] ~= nil then
				local tItemInfo = SelectItem:GetRandomItems(1, iPlayerID, sResultPool, { unpack(tRewards) })
				if tItemInfo[1] ~= nil then
					sReward = tItemInfo[1].sItemName
					sRewardType = "artifact"
				end
			end
			if tSpellCardReservoir[sResultPool] ~= nil and SelectSpellCard.tSpellCardPools[sResultPool] ~= nil then
				sReward = SelectSpellCard:RandomFromPool(iPlayerID, sResultPool)
				local a = string.split(sReward, ",")
				sReward = a[1]
				iRewardAmount = tonumber(a[2]) or iRewardAmount
				sRewardType = "spellcard"
			end
			if tHeroCardReservoir[sResultPool] ~= nil and Draw.tHeroCardPools[sResultPool] ~= nil then
				local tHeroCardPool = WeightPool(Draw.tHeroCardPools[sResultPool].tList)
				for sCardName, iWeight in pairs(tHeroCardPool.tList) do
					local a = string.split(sCardName, ",")
					if tPlayerCardList[a[1]] == nil then
						tHeroCardPool.tList[sCardName] = nil
					end
				end
				tHeroCardPool:update()

				sReward = tHeroCardPool:Random()
				local a = string.split(sReward, ",")
				sReward = a[1]
				iRewardAmount = tonumber(a[2]) or iRewardAmount
				sRewardType = "herocard"
			end
			if TableFindKey(tRewards, sReward) == nil and sReward ~= nil then
				break
			end
			iAttempts = iAttempts + 1
		end

		if sReward then
			table.insert(tRewards, sReward)
			local tMonsterData
			local iMaxAttempts = 16
			local iAttempts = 0
			while iAttempts < iMaxAttempts do
				tMonsterData = GetRandomElement(self.tContractMonsterData)
				if TableFindKey(tMonsters, tMonsterData.name) == nil and tMonsterData ~= nil then
					tMonsterData = shallowcopy(tMonsterData)
					break
				end
				iAttempts = iAttempts + 1
			end

			if tMonsterData then
				table.insert(tMonsters, tMonsterData.name)
				tMonsterData.health = tMonsterData.health * (1 + (tonumber(tContractData.bonus_health) or 0) * 0.01)
				tMonsterData.physical_attack = tMonsterData.physical_attack * (1 + (tonumber(tContractData.bonus_attack) or 0) * 0.01)
				tMonsterData.magical_attack = tMonsterData.magical_attack * (1 + (tonumber(tContractData.bonus_attack) or 0) * 0.01)
				tMonsterData.physical_armor = tMonsterData.physical_armor * (1 + (tonumber(tContractData.bonus_armor) or 0) * 0.01)
				tMonsterData.magical_armor = tMonsterData.magical_armor * (1 + (tonumber(tContractData.bonus_armor) or 0) * 0.01)
			end

			table.insert(self.tPlayerContractData[iPlayerID].tContracts, {
				level = iLevel,
				monster_data = tMonsterData,
				reward_data = {
					name = sReward,
					type = sRewardType,
					amount = iRewardAmount,
					bounty_gold = CONTRACT_BOUNTY_GOLD(iContinuousRefreshCount, iRound),
					bounty_crystal = CONTRACT_BOUNTY_CRYSTAL(iContinuousRefreshCount, iRound),
				},
			})
		end
	end

	self.tPlayerContractData[iPlayerID].iSelectedContractIndex = -1
	self.tPlayerContractData[iPlayerID].iState = 0

	DeepPrintTable(self.tPlayerContractData[iPlayerID])

	self:UpdateNetTables()
end
function public:StartContract(iPlayerID)
	local tContract = self.tPlayerContractData[iPlayerID].tContracts[self.tPlayerContractData[iPlayerID].iSelectedContractIndex]
	if tContract then
		local sPoint = GetRandomElement(self.tSpawnPoints)
		if sPoint then
			local vPos, vDir = Spawner:GetCreatePosDir(iPlayerID, {
				sPoint = sPoint,
				vPosOffset = Vector(0, 0, 0),
			})
			local hMonster = Spawner:PrepareContractMonster(tContract.monster_data, vPos, vDir, iPlayerID)
			table.insert(self.tContractMonsters, hMonster)
			hMonster:CreatureLevelUp(tContract.level - hMonster:GetLevel())
		end
	end
end
function public:EndContract(iPlayerID, bComplete)
	local tContract = self.tPlayerContractData[iPlayerID].tContracts[self.tPlayerContractData[iPlayerID].iSelectedContractIndex]
	if bComplete == true then
		if tContract then
			table.insert(self.tPlayerCompletedContracts[iPlayerID], tContract)
			self.tPlayerContractData[iPlayerID].iCompletedContractCount = #(self.tPlayerCompletedContracts[iPlayerID])

			-- 发放奖励
			local tRewardData = tContract.reward_data
			if tRewardData.type == "item" then
				Items:AddItem(iPlayerID, tRewardData.name)
			elseif tRewardData.type == "artifact" then
				Artifact:Add(iPlayerID, tRewardData.name)
			elseif tRewardData.type == "spellcard" then
				for i = 1, tRewardData.amount do
					HandSpellCards:AddCard(iPlayerID, tRewardData.name)
				end
			elseif tRewardData.type == "herocard" then
				if not HeroCardData:TryAddCardByName(iPlayerID, tRewardData.name, tRewardData.amount) then
					ErrorMessage(iPlayerID, 'dota_hud_error_hand_hero_card_max')
				end
			end
			if type(tRewardData.bounty_gold) == "number" then
				PlayerData:ModifyGold(iPlayerID, tRewardData.bounty_gold)
			end
			if type(tRewardData.bounty_crystal) == "number" then
				PlayerData:ModifyCrystal(iPlayerID, tRewardData.bounty_crystal)
			end
		end

		self.tPlayerContractData[iPlayerID].iState = 3
	else
		if tContract then
			table.insert(self.tPlayerFailedContracts[iPlayerID], tContract)
			self.tPlayerContractData[iPlayerID].iFailedContractCount = #(self.tPlayerFailedContracts[iPlayerID])
		end

		self.tPlayerContractData[iPlayerID].iState = 4
	end
	self:UpdateNetTables()
end
function public:ModifyFreeRefreshPoints(iPlayerID, n)
	self.tPlayerContractData[iPlayerID].iFreeRefreshPoints = self.tPlayerContractData[iPlayerID].iFreeRefreshPoints + n
	if self.tPlayerContractData[iPlayerID].iFreeRefreshPoints > 0 and self.tPlayerContractData[iPlayerID].iState == -1 then
		self.tPlayerContractData[iPlayerID].iFreeRefreshPoints = self.tPlayerContractData[iPlayerID].iFreeRefreshPoints - 1
		self:RefreshConstract(iPlayerID)
	end
	self:UpdateNetTables()
end
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("common", "player_contracts", self.tPlayerContractData)
end

return public