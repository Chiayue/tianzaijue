if Task == nil then
	---@class Task
	Task = {
	}

	---@class TaskData
	TaskData = {
		---@type string 任务类型
		type = "herogo",
		---@type number 奖励id
		reward = 2010002,
		---@type number 奖励数量
		count = 400,
		---@type number 当前进度
		value = 1,
		---@type number 任务目标
		target = 20,
		---@type [] 任务参数
		params = {}
	}
end
---@type Task
local public = Task

function public:Init(bReload)
	EventManager:register('EomDebug_PlayerChat', 'OnPlayerChatDebug', self)
	Request:Event("task.recv", Dynamic_Wrap(public, "ReqReceiveAward"), public)

	-- 注册各任务监听
	self:TaskPassRound()
	self:TaskAliveRound()
	self:TaskReforge()
	self:TaskUpgradeHero()
	self:TaskUpgradeCommander()
	self:TaskGetGold()
	self:TaskOpenBox()
	self:TaskHeroGo()
	self:TaskHeroStar()
	self:TaskReforgeTo()
	self:TaskSpellFriend()
	self:TaskAllTaxPass()
	self:TaskShareItem()
	self:TaskGrowupHero()
	self:TaskComingback()
	self:TaskUnstoppable()
	self:TaskIsthisit()
	self:TaskOnceatime()
	self:TaskOnlyuse()
	self:TaskGoldenHero()
end

--事件-------------
	do
	function public:OnPlayerChatDebug(iPlayerID, tokens)
		if tokens[1] == '-addtask' then
			if tokens[2] then
				self:ReqAddTask(iPlayerID, tokens[2])
			end
		end
	end
end

--请求更新任务进度
function public:ReqUpdateProgress(iPlayerID, iTaskid, value)
	Service:POST('task.update', {
		uid = GetAccountID(iPlayerID),
		sid = iTaskid,
		value = value
	}, function(data)
		if data then
			if data.status == 1 then
			end
		end
	end)
end

--请求更新任务进度
function public:ReqAddTask(iPlayerID, sTaskID)
	Service:POST('task.add', {
		uid = GetAccountID(iPlayerID),
		sid = sTaskID,
	}, function(data)
		if data then
			if data.status == 1 then
			end
		end
	end)
end

-- 请求领取任务奖励
function public:ReqReceiveAward(params)
	local iPlayerID = params.PlayerID
	local taskid = params.taskid
	local date = params.date

	local tTask = self:GetPlayerTask(iPlayerID, taskid, date)
	if not tTask then
		return 'error_not_have_task'
	end
	if tTask.value < tTask.target then
		return 'error_not_finished_task'
	end

	local data = Service:POSTSync('task.recv', {
		uid = GetAccountID(iPlayerID),
		sid = taskid,
		date = date,
	})

	return data
end

--- 玩家任务数据
---@return TaskData
function public:GetPlayerTask(iPlayerID, sTaskID, date)
	local tPlayerTask = NetEventData:GetTableValue('service', 'player_task_' .. iPlayerID)
	if tPlayerTask then
		for _, t in pairs(tPlayerTask) do
			local tTask = t
			if tostring(tTask[9]) == sTaskID and date == tTask[10] then
				return {
					type = tTask[1],
					reward = tTask[2],
					count = tTask[3],
					value = tTask[4],
					target = tTask[5],
					recv = tTask[6],
					plus = tTask[7],
					params = tTask[8],
					taskid = tTask[9],
					date = tTask[10],
				}
			end
		end

		return nil
	end
end

--- 获取玩家某种类型的全部任务
---@param iFlag number 不填返回全部 1仅未完成任务 2仅完成的任务
---@return TaskData[]
function public:GetTasksByType(iPlayerID, sType, iFlag)
	local t = {}
	local tTasks = NetEventData:GetTableValue('service', 'player_task_' .. iPlayerID)
	if tTasks then
		for _, tTask in pairs(tTasks) do
			local sTaskID = tTask[9]
			tTask = {
				type = tTask[1],
				reward = tTask[2],
				count = tTask[3],
				value = tTask[4],
				target = tTask[5],
				recv = tTask[6],
				plus = tTask[7],
				params = tTask[8],
				taskid = tTask[9],
				date = tTask[10],
			}
			if sType == tTask['type'] then
				local iVal = tonumber(tTask['value']) or 0
				local iTarget = tonumber(tTask['target']) or 0
				if iVal >= iTarget then
					if 1 ~= iFlag then
						t[sTaskID] = tTask
					end
				elseif 2 ~= iFlag then
					t[sTaskID] = tTask
				end
			end
		end
	end
	local tTasks = NetEventData:GetTableValue('service', 'player_title_task_' .. iPlayerID)
	if tTasks then
		for sTaskID, tTask in pairs(tTasks) do
			tTask = {
				type = tTask[1],
				value = tTask[2],
				target = tTask[3],
				params = tTask[4],
			}
			if sType == tTask['type'] then
				local iVal = tonumber(tTask['value']) or 0
				local iTarget = tonumber(tTask['target']) or 0
				if iVal >= iTarget then
					if 1 ~= iFlag then
						t[sTaskID] = tTask
					end
				elseif 2 ~= iFlag then
					t[sTaskID] = tTask
				end
			end
		end
	end
	local tTasks = NetEventData:GetTableValue('service', 'player_herotask_' .. iPlayerID)
	if tTasks then
		for sTaskID, tTask in pairs(tTasks) do
			tTask = {
				type = tTask[1],
				reward = tTask[2],
				count = tTask[3],
				value = tTask[4],
				target = tTask[5],
				params = tTask[6],
			}
			if sType == tTask['type'] then
				local iVal = tonumber(tTask['value']) or 0
				local iTarget = tonumber(tTask['target']) or 0
				if iVal >= iTarget then
					if 1 ~= iFlag then
						t[sTaskID] = tTask
					end
				elseif 2 ~= iFlag then
					t[sTaskID] = tTask
				end
			end
		end
	end
	return t
end

--各任务完成逻辑------------------------------------------------------------------------
--
---战胜某一关的任务
function public:TaskPassRound()
	---@param tData EventData_PlayerRoundResult
	EventManager:register(ET_PLAYER.ROUND_RESULT, function(tData)
		if 1 ~= tData.is_win then return end

		local tTasks = self:GetTasksByType(tData.PlayerID, 'pass', 1)
		for sTaskID, tTask in pairs(tTasks) do
			local iTaskRound = tonumber(tTask.params[1])
			if iTaskRound and iTaskRound <= Spawner:GetRound() then
				self:ReqUpdateProgress(tData.PlayerID, sTaskID, 1)
			end
		end
	end, nil, nil, 'TaskPassRound')
end
---累计存活一定关数任务，玩家存活回合+1
function public:TaskAliveRound()
	EventManager:register(ET_BATTLE.ON_BATTLEING_ENDWAIT_END, function()
		DotaTD:EachPlayer(function(_, iPlayerID)
			if PlayerData:IsAlive(iPlayerID) then
				local tTasks = self:GetTasksByType(iPlayerID, 'alive', 1)
				for sTaskID, tTask in pairs(tTasks) do
					self:ReqUpdateProgress(iPlayerID, sTaskID, 1)
				end
			end
		end)
	end, nil, nil, 'TaskAliveRound')
end
---在v1秒内，获得v2难度下v3关的胜利
function public:TaskIsthisit()
	---@param tData EventData_PlayerRoundResult
	EventManager:register(ET_PLAYER.ROUND_RESULT, function(tData)
		if 1 ~= tData.is_win then return end

		local tTasks = self:GetTasksByType(tData.PlayerID, 'isthisit', 1)
		for sTaskID, tTask in pairs(tTasks) do
			local iTime = tonumber(tTask['params'][1])
			local iDifficulty = tonumber(tTask['params'][2])
			local iRound = tonumber(tTask['params'][3])
			if nil ~= iTime and nil ~= iDifficulty and nil ~= iRound then
				if GameMode:GetDifficulty() == iDifficulty and iRound == Spawner:GetRound() then
					local iTimeLost = GSManager:getStateObj().iDuration or 0
					local iTimeUse = Spawner:GetRoundBattleTime(iRound) - iTimeLost
					if iTimeUse <= iTime then
						self:ReqUpdateProgress(tData.PlayerID, sTaskID, 1)
					end
				end
			end
		end
	end, nil, nil, 'TaskIsthisit', EVENT_LEVEL_HIGH)
end
---在所有出战英雄品级小于或等于val1下，通过val2难度
function public:TaskOnlyuse()
	EventManager:register(ET_GAME.GAME_BALANCE, function(tData)
		DotaTD:EachPlayer(function(_, iPlayerID)
			if PlayerData:IsPlayerDeath(iPlayerID) then return end

			local tTasks = self:GetTasksByType(iPlayerID, 'onlyuse', 1)
			for sTaskID, tTask in pairs(tTasks) do
				local iRarity = tonumber(tTask.params[1])
				local iDifficulty = tonumber(tTask.params[2])
				if iDifficulty and iDifficulty == GameMode:GetDifficulty() then

					local bCheck = true
					EachUnits(iPlayerID, function(hUnit)
						local iRarityCur = DotaTD:GetRarityID(DotaTD:GetCardRarity(hUnit:GetUnitName()))
						if iRarity < iRarityCur then
							bCheck = false
							return true
						end
					end, UnitType.Building)

					if bCheck then
						self:ReqUpdateProgress(iPlayerID, sTaskID, 1)
					end
				end
			end
		end)
	end, nil, nil, 'TaskOnlyuse')
end

---每关全税金通关v1难度
function public:TaskAllTaxPass()
	local tTaxs = {}
	---@param tData EventData_PlayerTaxBalance
	EventManager:register(ET_PLAYER.ON_TAX_BALANCE, function(tData)
		local tPlayerTaxs = tTaxs[tData.PlayerID] or {}
		tTaxs[tData.PlayerID] = tPlayerTaxs
		tPlayerTaxs[Spawner:GetRound()] = tData.iGold
	end, nil, nil, 'TaskAllTaxPass')

	---@param tData EventData_PlayerDeath
	EventManager:register(ET_PLAYER.ON_DEATH, function(tData)
		tTaxs[tData.PlayerID] = nil
	end, nil, nil, 'TaskAllTaxPass')

	EventManager:register(ET_GAME.GAME_BALANCE, function()
		DotaTD:EachPlayer(function(_, iPlayerID)
			if PlayerData:IsPlayerDeath(iPlayerID) then return end
			local tPlayerTaxs = tTaxs[iPlayerID]
			if not tPlayerTaxs then return end

			local bAllTax = true
			for i = Spawner:GetRound(), 1, -1 do
				if nil == tPlayerTaxs[i] or 0 >= tPlayerTaxs[i] then
					bAllTax = false
					break
				end
			end
			if not bAllTax then return end

			local tTasks = self:GetTasksByType(iPlayerID, 'all_tax_pass', 1)
			for sTaskID, tTask in pairs(tTasks) do
				local iDifficulty = tonumber(tTask.params[1])
				if iDifficulty and iDifficulty == GameMode:GetDifficulty() then
					self:ReqUpdateProgress(iPlayerID, sTaskID, 1)
				end
			end
		end)
	end, nil, nil, 'TaskAllTaxPass')
end


---累计升级一定次数英雄星级任务
function public:TaskUpgradeHero()
	local function levelup(iLevel, iPlayerID)
		if 0 < iLevel then
			local tTasks = self:GetTasksByType(iPlayerID, 'upgrade_hero', 1)
			for sTaskID, tTask in pairs(tTasks) do
				self:ReqUpdateProgress(iPlayerID, sTaskID, iLevel)
			end
		end
	end

	---@param tData EventData_PlayerTowerLevelup
	EventManager:register(ET_PLAYER.ON_TOWER_LEVELUP, function(tData)
		levelup(tData.iLevel - tData.iLevelOld, tData.PlayerID)
	end, nil, nil, 'TaskUpgradeHero')

	---@param tData EventData_PlayerHeroCardLevelup
	EventManager:register(ET_PLAYER.ON_HERO_CARD_LEVELUP, function(tData)
		levelup(tData.iLevel - tData.iLastLevel, tData.PlayerID)
	end, nil, nil, 'TaskUpgradeHero')
end
---使用英雄提升到某星级的任务
function public:TaskHeroStar()
	local function levelup(iLevel, iPlayerID, sCardName)
		if 0 < iLevel then
			local tTasks = self:GetTasksByType(iPlayerID, 'herostar', 1)
			for sTaskID, tTask in pairs(tTasks) do
				local iTargetLevel = tonumber(tTask['params'][2])
				if iTargetLevel and iTargetLevel <= iLevel then
					local sHeroID = tTask['params'][1] and tostring(tTask['params'][1])
					if sHeroID then
						local sCardName2 = DotaTD:GetCardName(sHeroID)
						if sCardName == sCardName2 then
							self:ReqUpdateProgress(iPlayerID, sTaskID, 1)
						end
					end
				end
			end
		end
	end

	---@param tData EventData_PlayerTowerLevelup
	EventManager:register(ET_PLAYER.ON_TOWER_LEVELUP, function(tData)
		levelup(tData.iLevel, tData.PlayerID, tData.hBuilding:GetUnitEntityName())
	end, nil, nil, 'TaskHeroStar')

	---@param tData EventData_PlayerHeroCardLevelup
	EventManager:register(ET_PLAYER.ON_HERO_CARD_LEVELUP, function(tData)
		levelup(tData.iLevel, tData.PlayerID, tData.hCard.sCardName)
	end, nil, nil, 'TaskHeroStar')
end
---使用英雄出战任务
function public:TaskHeroGo()
	EventManager:register(ET_BATTLE.ON_BATTLEING, function()
		DotaTD:EachPlayer(function(_, iPlayerID)
			if PlayerData:IsAlive(iPlayerID) then
				local tTasks = self:GetTasksByType(iPlayerID, 'herogo', 1)
				for sTaskID, tTask in pairs(tTasks) do
					local sHeroID = tTask['params'][1] and tostring(tTask['params'][1])
					if sHeroID then
						local sCardName = DotaTD:GetCardName(sHeroID)
						if sCardName and PlayerBuildings:HasBuildingUnit(iPlayerID, sCardName) then
							self:ReqUpdateProgress(iPlayerID, sTaskID, 1)
						end
					end
				end
				local tTasks = self:GetTasksByType(iPlayerID, 'heroup', 1)
				for sTaskID, tTask in pairs(tTasks) do
					local sHeroID = tTask['params'][1] and tostring(tTask['params'][1])
					if sHeroID then
						local sCardName = DotaTD:GetCardName(sHeroID)
						if sCardName and PlayerBuildings:HasBuildingUnit(iPlayerID, sCardName) then
							self:ReqUpdateProgress(iPlayerID, sTaskID, 1)
						end
					end
				end
			end
		end)
	end, nil, nil, 'TaskHeroGo')
end
---出战的val1个英雄装备了至少val2件SSR装备
function public:TaskGoldenHero()
	EventManager:register(ET_BATTLE.ON_BATTLEING, function()
		DotaTD:EachPlayer(function(_, iPlayerID)
			if PlayerData:IsPlayerDeath(iPlayerID) then end
			local tTasks = self:GetTasksByType(iPlayerID, 'golden_hero', 1)
			for sTaskID, tTask in pairs(tTasks) do
				local iHeroCountNeed = tonumber(tTask['params'][1])
				local iItemCountNeed = tonumber(tTask['params'][2])
				local iRarityNeed = DotaTD:GetRarityID('ssr')
				if nil ~= iItemCountNeed and nil ~= iHeroCountNeed then
					EachUnits(iPlayerID, function(hUnit)
						local iItemCount = 0
						for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_3 do
							local hItem = hUnit:GetItemInSlot(i)
							if hItem and Items:IsGameHasItem(hItem:GetAbilityName()) then
								local iRarity = DotaTD:GetRarityID(Items:GetItemRarity(hItem:GetAbilityName()))
								if iRarity >= iRarityNeed then
									iItemCount = iItemCount + 1
									if iItemCount >= iItemCountNeed then
										iHeroCountNeed = iHeroCountNeed - 1
										if 0 >= iHeroCountNeed then return true end
										break
									end
								end
							end
						end
					end, UnitType.Building)

					if 0 >= iHeroCountNeed then
						self:ReqUpdateProgress(iPlayerID, sTaskID, 1)
					end
				end
			end
		end)
	end, nil, nil, 'TaskGoldenHero')
end
---将v1个英雄成长至v2级（外围成长）
function public:TaskGrowupHero()
	---@param tData EventData_PlayerHeroCardGrowupLevelup
	EventManager:register(ET_PLAYER.ON_HERO_CARD_GROWUP_LEVELUP, function(tData)
		local tCards = NetEventData:GetTableValue('service', 'player_herocards_' .. tData.PlayerID)
		if not tCards then return end
		local tTasks = self:GetTasksByType(tData.PlayerID, 'growup_hero', 1)
		for sTaskID, tTask in pairs(tTasks) do
			local iCount = tonumber(tTask['params'][1])
			local iLevel = tonumber(tTask['params'][2])
			if nil ~= iCount and nil ~= iLevel then
				for _, tCardData in pairs(tCards) do
					if tonumber(tCardData['level']) >= iLevel then
						iCount = iCount - 1
					end
				end
				if 0 >= iCount then
					self:ReqUpdateProgress(tData.PlayerID, sTaskID, 1)
				end
			end
		end
	end, nil, nil, 'TaskGrowupHero')
end
---在第v1回合之前购买v2张SSR英雄
function public:TaskUnstoppable()
	local tCounts = {}
	---@param tData EventData_PlayerHeroCardBuyInDraw
	EventManager:register(ET_PLAYER.ON_HERO_CARD_BUY_IN_DRAW, function(tData)
		if 'ssr' ~= DotaTD:GetCardRarity(tData.sCardName) then return end
		tCounts[tData.PlayerID] = (tCounts[tData.PlayerID] or 0) + 1
		local tTasks = self:GetTasksByType(tData.PlayerID, 'unstoppable', 1)
		for sTaskID, tTask in pairs(tTasks) do
			local iRound = tonumber(tTask['params'][1])
			local iCount = tonumber(tTask['params'][2])
			if nil ~= iRound and nil ~= iCount then
				if iRound <= Spawner:GetRound() and iCount <= tCounts[tData.PlayerID] then
					self:ReqUpdateProgress(tData.PlayerID, sTaskID, 1)
				end
			end
		end
	end, nil, nil, 'TaskUnstoppable')
end
---一次性刷新出val1张val2品质的英雄
function public:TaskOnceatime()
	---@param tData EventData_PlayerDrawCard
	EventManager:register(ET_PLAYER.ON_DRAW_CARD, function(tData)
		local tRaritys = {}
		for _, tCardData in pairs(tData.tHeroCards) do
			local sRarity = DotaTD:GetCardRarity(tCardData.sCardName)
			tRaritys[sRarity] = 1 + (tRaritys[sRarity] or 0)
		end
		local tTasks = self:GetTasksByType(tData.PlayerID, 'onceatime', 1)
		for sTaskID, tTask in pairs(tTasks) do
			local iCount = tonumber(tTask['params'][1])
			local iRarity = tonumber(tTask['params'][2])
			if nil ~= iCount and nil ~= iRarity then
				local sRarity = DotaTD:GetCardRarityByNumber(iRarity)
				if tRaritys[sRarity] and iCount <= tRaritys[sRarity] then
					self:ReqUpdateProgress(tData.PlayerID, sTaskID, 1)
				end
			end
		end
	end, nil, nil, 'TaskOnceatime')
end



---累计升级一定次数指挥官任务
function public:TaskUpgradeCommander()
	local function levelup(iLevel, iPlayerID)
		if 0 < iLevel then
			local tTasks = self:GetTasksByType(iPlayerID, 'upgrade_cmd', 1)
			for sTaskID, tTask in pairs(tTasks) do
				self:ReqUpdateProgress(iPlayerID, sTaskID, iLevel)
			end
		end
	end

	---@param tData EventData_PlayerCommanderLevelup
	EventManager:register(ET_PLAYER.ON_COMMANDER_LEVELUP, function(tData)
		levelup(tData.iLevel - tData.iLastLevel, tData.PlayerID)
	end, nil, nil, 'TaskUpgradeCommander')
end


---累计获得金币任务
function public:TaskGetGold()
	local tCheckPlayers = {}
	local function doonce(iPlayerID)
		if tCheckPlayers[iPlayerID] then return end
		local tTasks = self:GetTasksByType(iPlayerID, 'gold', 1)
		for sTaskID, tTask in pairs(tTasks) do
			tCheckPlayers[iPlayerID] = true
			self:ReqUpdateProgress(iPlayerID, sTaskID, PlayerData:GetTotalGold(iPlayerID))
		end
	end

	EventManager:register(ET_GAME.GAME_BALANCE, function()
		DotaTD:EachPlayer(function(_, iPlayerID)
			doonce(iPlayerID)
		end)
	end, nil, nil, 'TaskGetGold')

	---@param tData EventData_PlayerDeath
	EventManager:register(ET_PLAYER.ON_DEATH, function(tData)
		doonce(tData.PlayerID)
	end, nil, nil, 'TaskGetGold')
end


---打开宝箱任务
function public:TaskOpenBox()
	---@param tData EventData_OpenBox
	EventManager:register(ET_PLAYER.ON_OPEN_BOX, function(tData)
		local tTasks = self:GetTasksByType(tData.PlayerID, 'box', 1)
		for sTaskID, tTask in pairs(tTasks) do
			self:ReqUpdateProgress(tData.PlayerID, sTaskID, tData.iCount)
		end
	end, nil, nil, 'TaskOpenBox')
end


---累计重铸装备
function public:TaskReforge()
	---@param tData EventData_PlayerItemRemake
	EventManager:register(ET_PLAYER.ON_ITEM_REMAKE, function(tData)
		local tTasks = self:GetTasksByType(tData.PlayerID, 'reforge', 1)
		for sTaskID, tTask in pairs(tTasks) do
			self:ReqUpdateProgress(tData.PlayerID, sTaskID, 1)
		end
	end, nil, nil, 'TaskReforge')
end
---单局重铸v1个装备至v2品质
function public:TaskReforgeTo()
	local tCounts = {}
	---@param tData EventData_PlayerItemRemake
	EventManager:register(ET_PLAYER.ON_ITEM_REMAKE, function(tData)
		if tData.tItemDataOld.iRarity < tData.tItemData.iRarity then
			local tTasks = self:GetTasksByType(tData.PlayerID, 'reforgeto', 1)
			for sTaskID, tTask in pairs(tTasks) do
				local iValRarity = tonumber(tTask.params[2])
				if iValRarity == tData.tItemData.iRarity then
					tCounts[tData.PlayerID] = (tCounts[tData.PlayerID] or 0) + 1
					local iValCount = tonumber(tTask.params[1]) or 0
					if tCounts[tData.PlayerID] >= iValCount then
						self:ReqUpdateProgress(tData.PlayerID, sTaskID, 1)
					end
				end
			end
		end
	end, nil, nil, 'TaskReforgeTo')
end
---单局共享v1个v2品质装备
function public:TaskShareItem()
	local tCounts = {}
	---@param tData EventData_PlayerItemShare
	EventManager:register(ET_PLAYER.ON_ITEM_SHARE, function(tData)
		local tPlayerCount = tCounts[tData.PlayerID] or {}
		tCounts[tData.PlayerID] = tPlayerCount
		tPlayerCount[tData.iItemRarity] = (tPlayerCount[tData.iItemRarity] or 0) + 1

		local tTasks = self:GetTasksByType(tData.PlayerID, 'share_item', 1)
		for sTaskID, tTask in pairs(tTasks) do
			local iCount = tonumber(tTask.params[1])
			local iRarity = tonumber(tTask.params[2])
			if nil ~= iRarity and nil ~= iCount and nil ~= tPlayerCount[iRarity] then
				if tPlayerCount[iRarity] >= iCount then
					self:ReqUpdateProgress(tData.PlayerID, sTaskID, 1)
				end
			end
		end
	end, nil, nil, 'TaskShareItem')
end

---战胜任意BOSS时，存活英雄数量等于v1
function public:TaskComingback()
	---@param tData EventData_PlayerRoundResult
	EventManager:register(ET_PLAYER.ROUND_RESULT, function(tData)
		if 1 ~= tData.is_win then return end

		local iAliveCount = 0
		EachUnits(tData.PlayerID, function(hUnit)
			if hUnit:IsAlive() then
				iAliveCount = iAliveCount + 1
			end
		end, UnitType.Building)

		local tTasks = self:GetTasksByType(tData.PlayerID, 'comingback', 1)
		for sTaskID, tTask in pairs(tTasks) do
			local iCount = tonumber(tTask.params[1])
			if iCount and iCount == iAliveCount then
				self:ReqUpdateProgress(tData.PlayerID, sTaskID, 1)
			end
		end
	end, nil, nil, 'TaskComingback')
end


---对其他玩家区域释放法术卡
function public:TaskSpellFriend()
	---@param tData EventData_PLAYER_USE_SPELL
	EventManager:register(ET_PLAYER.ON_HERO_USE_SPELL, function(tData)
		if not IsValid(tData.hAblt)
		or DOTA_ABILITY_BEHAVIOR_POINT ~= bit.band(DOTA_ABILITY_BEHAVIOR_POINT, GetAbilityBehavior(tData.hAblt))
		then return end

		local vPos = tData.hAblt:GetCursorPosition()
		if vPos and PlayerData:IsPointInPlayerRange(tData.iPlayerID, vPos) then
			local tTasks = self:GetTasksByType(tData.iPlayerID, 'spell_friend', 1)
			for sTaskID, tTask in pairs(tTasks) do
				self:ReqUpdateProgress(tData.iPlayerID, sTaskID, 1)
			end
		end
	end, nil, nil, 'TaskSpellFriend')
end