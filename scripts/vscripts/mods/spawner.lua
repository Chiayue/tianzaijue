if Spawner == nil then
	---@class Spawner
	Spawner = {
		iRound = 0, --不计活动回合的正常回合数
		iActualRound = 0,
		fRoundStartTime = -1, --回合开始时间节点
		fRoundTime = -1, --回合时间节点

		PlayerMissing = {}, --玩家场面存活怪
		PublicMissing = {}, --玩家公共的怪物（boss和它的召唤怪之类）
		PlayerEnterDoor = {}, --玩家当前回合入门怪数量（进入传送门）
		PlayerKilledCount = {}, --玩家杀怪数（不计召唤单位）
		tPlayerSpawnedCount = {}, --玩家本回合已经刷怪数
		tPlayerRoundMissCount = {}, --玩家各回合漏怪数
		tPlayerBossIntensify = {}, --玩家漏怪导致的Boss加强属性

		PlayerGoldCreeps = {}, --
		---@type GoldRoundData[][]
		tPlayerGoldCreepRounData = {}, --每打金回合玩家打金数据

		tGhostEnemy = {}, --幽灵怪物

		WaveKv = {}, --回合波数KV数据

		tTeamMapPoints = {}, --各队伍地图锚点
		tTeamEnemyDoorPos = {}, --各队伍怪物传送门
		vTeamEnemyDoorDir = nil, --怪物传送门朝向
		tTeamCameraPos = {}, --各队伍镜头位置
		tTeamBossMapPoints = {}, --各队伍Boss地图锚点
		hBossMapPoint = nil, --Boss地图锚点

		tSpawner = {}, --怪物诞生点
		tPaths = {}, --寻路点

		tRoundSpawnGroups = {}, --当前回合怪物的spawngroup

		fBossStartTime = 0, --boss出生时间
		tBossKillTimes = {}, --各boss回合击杀后的存活时间

		-- 年兽挑战
		bNianRound = false, --年兽回合
	}
end
---@type Spawner
local public = Spawner

function public:init(bReload)
	EventManager:register(ET_GAME.NPC_DEATH, 'OnEvent_NpcDeath', self, EVENT_LEVEL_ULTRA)
	EventManager:register(ET_ENEMY.ON_DEATH, 'OnEnemyEvent_OnDeath', self, EVENT_LEVEL_ULTRA)
	EventManager:register(ET_ENEMY.ON_ENTER_DOOR, 'OnEnemyEvent_OnEnterDoor', self, EVENT_LEVEL_ULTRA)
	EventManager:register(ET_BATTLE.ON_BATTLEING_END, 'OnBattleEvent_OnBattleEnd', self, EVENT_LEVEL_ULTRA)

	CustomUIEvent("SeePlayer", Dynamic_Wrap(public, "OnSeePlayer"), public)

	if not bReload then
		self.iLastRound = -1
		self.iRound = 0
		self.fRoundStartTime = -1
		self.fRoundTime = -1

		self.PlayerMissing = {}
		self.PublicMissing = {}
		self.PlayerEnterDoor = {}
		self.PlayerKilledCount = {}
		self.PlayerGoldCreeps = {}
		self.tPlayerGoldCreepRounData = {}
		self.tPlayerSpawnedCount = {}

		self.tGhostEnemy = {}
	end

	local tSpawnPointsAll = {}

	-- 普通波数信息
	self.WaveKv = {}
	for k, v in pairs(KeyValues.WaveKv) do
		local tRoundEnemy = LoadKvMultiVal(v.enemy)
		local sRoundEnemyName = GetRandomElement(tRoundEnemy)
		self.WaveKv[k] = TableOverride(deepcopy(v), deepcopy(KeyValues.RoundEnemyKv[sRoundEnemyName]))

		for k2, v2 in pairs(self.WaveKv[k]) do
			if nil ~= string.find(k2, "EnemyStyle")
			and 0 < TableCount(v2)
			then
				if v2.EnemyType
				and v2.SpawnPoint
				and v2.SpawnTick
				and v2.SpawnCount
				and v2.SpawnDelay then
					local tUnits = LoadKvMultiVal(v2.EnemyType)
					local tSpawnPoints = LoadKvMultiVal(v2.SpawnPoint)

					v2.tUnitSpawnInfo = {}	--单个元素表示某单个位刷新在单个点

					for _, sPoint in pairs(tSpawnPoints) do
						tSpawnPointsAll[sPoint] = true
						--多单位在单个出生点的随机分布
						local pool = WeightPool(SPAWN_POINT_OFFSET_ARRAY)
						for _, sUnit in pairs(tUnits) do
							local vPosOffset = pool:Random()
							table.insert(v2.tUnitSpawnInfo, {
								sPoint = sPoint,
								sUnit = sUnit,
								vPosOffset = vPosOffset,
							})
							pool:Remove(vPosOffset)
						end
					end
				end
			end
		end
	end

	-- 各队伍地图坐标点
	self.tTeamMapPoints = {}
	for k, v in pairs(TEAM_MAP_POINT_ENTITY) do
		self.tTeamMapPoints[k] = Entities:FindByNameLike(nil, v)
	end

	-- 各队伍怪物传送门位置
	self.tTeamEnemyDoorPos = {}
	local hDoor = Entities:FindByNameLike(nil, TEAM_ENEMY_DOOR_NAME)
	self.vTeamEnemyDoorDir = hDoor:GetForwardVector()
	local vOffsetDoor
	for k, v in pairs(self.tTeamMapPoints) do
		if not vOffsetDoor then
			vOffsetDoor = hDoor:GetAbsOrigin() - v:GetAbsOrigin()
		end
		self.tTeamEnemyDoorPos[k] =	v:GetAbsOrigin() + vOffsetDoor
	end

	--Boss区域和视野
	self.hBossMapPoint = Entities:FindByNameLike(nil, BOSS_MAP_POINT_NAME)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, self.hBossMapPoint:GetAbsOrigin(), 2500, -1, false)

	-- 各队伍镜头位置
	self.tTeamCameraPos = {}
	local hCamera = Entities:FindByNameLike(nil, 'CameraTarget_Player')
	local vOffsetDoor
	for k, v in pairs(self.tTeamMapPoints) do
		if not vOffsetDoor then
			vOffsetDoor = hCamera:GetAbsOrigin() - v:GetAbsOrigin()
		end
		local vPos = v:GetAbsOrigin() + vOffsetDoor
		self.tTeamCameraPos[k] = vPos
		NetEventData:SetTableValue('PlayerTeamCameraPos', PlayerData:GetPlayerIDByTeamID(k), { x = vPos.x, y = vPos.y, z = vPos.z })

		-- 视野
		self:SetTeamFow(k, k, -1)
	end

	-- 各队伍Boss地图坐标点
	self.tTeamBossMapPoints = {}
	for k, v in pairs(TEAM_BOSS_MAP_POINT_ENTITY) do
		self.tTeamBossMapPoints[k] = Entities:FindByNameLike(nil, v)
	end

	-- 契约诞生点
	local tConstractSpawnPoints = string.rsplit(string.gsub(CONTRACT_SPAWN_POINT, " ", ""), "|")
	for v, s in pairs(tConstractSpawnPoints) do
		if not tSpawnPointsAll[s] then
			tSpawnPointsAll[s] = true
		end
	end

	-- 怪物诞生点
	self.tSpawner = {}
	for v, _ in pairs(tSpawnPointsAll) do
		local hSpawner = Entities:FindByNameLike(nil, v)
		if hSpawner then
			local vDir
			for iTeam, hPoint in pairs(self.tTeamMapPoints) do
				if not vDir then
					vDir = hSpawner:GetAbsOrigin() - hPoint:GetAbsOrigin()
				end
				if not self.tSpawner[iTeam] then
					self.tSpawner[iTeam] = {}
				end
				local vSpawnPos = hPoint:GetAbsOrigin() + vDir
				self.tSpawner[iTeam][v] = vSpawnPos
			end
		end
	end

	--寻路点
	self.tPaths = {}
	for iTeam = 1, 4 do
		self.tPaths[iTeam] = {}
		for k, v in pairs(ENEMY_MOVE_PATH) do
			self.tPaths[iTeam][k] = Entities:FindByName(nil, iTeam .. '_' .. v)
		end
	end
end

--UI监听************************************************************************************************************************
	do
	function public:OnSeePlayer(_, tEvent)
		if tEvent.bOnlyFow == 0 then
			Spawner:SeePlayer(tEvent.PlayerID, tEvent.iSelectID)
		end

		local iTeamID = PlayerData:GetPlayerTeamID(tEvent.PlayerID)
		local iTeamIDSelect = PlayerData:GetPlayerTeamID(tEvent.iSelectID)

		--战场视野
		-- 关闭其他队伍视野
		DotaTD:EachPlayer(function(_, iPlayerID)
			Spawner:SetTeamFow(iTeamID, PlayerData:GetPlayerTeamID(iPlayerID), nil, true)
		end)
		if PlayerResource:IsValidPlayerID(tEvent.iSelectID) then
			-- 开启目标地区视野
			Spawner:SetTeamFow(iTeamID, iTeamIDSelect, nil, false)
		end
	end
end
--事件监听************************************************************************************************************************
	do
	--玩家加载完成
	function public:InitPlayerSpawnerData(tEvent)
		local iPlayerID = tEvent.PlayerID
		self.PlayerMissing[iPlayerID] = {}
		self.PlayerEnterDoor[iPlayerID] = 0
		self.PlayerKilledCount[iPlayerID] = 0
		self.PlayerGoldCreeps[iPlayerID] = {}
		self.tPlayerGoldCreepRounData[iPlayerID] = {}
		self.tPlayerRoundMissCount[iPlayerID] = {}
		self.tPlayerSpawnedCount[iPlayerID] = 0
		self.tPlayerBossIntensify[iPlayerID] = {}
	end
	--单位死亡
	function public:OnEvent_NpcDeath(tEvent)
		local hUnit = EntIndexToHScript(tEvent.entindex_killed)
		if not IsValid(hUnit) then return end

		if self:ClearEnemyOne(hUnit) then
			---单个刷怪点的怪物都死了，直接刷新下个怪
			if hUnit.funcSpawnOnce and hUnit.tSpawnPointUnit then
				remove(hUnit.tSpawnPointUnit, hUnit)
				if 0 == #hUnit.tSpawnPointUnit then
					hUnit.funcSpawnOnce()
				end
			end
		end
	end
	--怪物死亡
	function public:OnEnemyEvent_OnDeath(tEvent)
		local hUnit = EntIndexToHScript(tEvent.entindex_killed)
		local hAtker = tEvent.entindex_attacker and EntIndexToHScript(tEvent.entindex_attacker) or nil
		if not IsValid(hUnit) then return end


		if hUnit:IsBoss() then
			local iKillTime = GameRules:GetGameTime() - self.fBossStartTime
			self.tBossKillTimes[self:GetRound()] = iKillTime

			if IsValid(hAtker) and hAtker ~= hUnit then
				Notification:Combat({
					boss_name = hUnit:GetUnitName(),
					boss_kill = tostring(Round(iKillTime, 2)),
					message = "#Boss_Kill",
				})
			end
		end

		-- 漏怪，Boss额外加强属性
		if not hUnit:IsBoss() and hUnit == hAtker and not self:IsGoldRound() then
			local iPlayerID = GetPlayerID(hUnit)
			if Spawner.tPlayerBossIntensify[iPlayerID] then
				local tAttribute = MISS_ENEMY_BOSS_INTENSIFY_ATTRIBUTE(hUnit)
				for typeEMDF, val in pairs(tAttribute) do
					if not Spawner.tPlayerBossIntensify[iPlayerID][typeEMDF] then
						Spawner.tPlayerBossIntensify[iPlayerID][typeEMDF] = val
					else
						Spawner.tPlayerBossIntensify[iPlayerID][typeEMDF] = val + Spawner.tPlayerBossIntensify[iPlayerID][typeEMDF]
					end

					Notification:Boss_Enhance({
						boss_enhance = Spawner.tPlayerBossIntensify[iPlayerID][typeEMDF],
						-- tAttribute = typeEMDF,
						message = "#Boss_Enhance",
					})
					break
				end
			end
		end
	end
	--怪物进入传送门
	function public:OnEnemyEvent_OnEnterDoor(tEvent)
		local hUnit = EntIndexToHScript(tEvent.entindex)
		if not IsValid(hUnit) then return end
		local iPlayerID = hUnit.Spawner_spawnerPlayerID
		self.PlayerEnterDoor[iPlayerID] = self.PlayerEnterDoor[iPlayerID] + 1
	end
	---战斗结束
	function public:OnBattleEvent_OnBattleEnd()
		DotaTD:EachPlayer(function(_, iPlayerID)
			self.tPlayerRoundMissCount[iPlayerID][self:GetRound()] = self:GetPlayerMissingCount(iPlayerID) + self:GetPlayerEnterDoorCount(iPlayerID)
		end)
	end
end
--API************************************************************************************************************************
--
--更新网表
function public:UpdateNetTables()
	local tRoundData = self:GetRoundData(self:GetRound())
	-- local nextRoundData = self:GetRoundData(self:GetRound() + 1)
	local table = {
		round = self:GetRound(),
		round_type = self:GetRoundType(),
		round_gold = tRoundData.round_gold, -- 固定奖励
		bonus_round_gold = tRoundData.bonus_round_gold, -- 全清奖励
		bonus_round_crystal = tRoundData.bonus_round_crystal, -- 全清奖励

		select_items = tRoundData.select_items,
		select_items_count = tRoundData.select_items_count,
		select_items_mode = tRoundData.select_items_mode,

		round_title = tRoundData ~= nil and tRoundData.Title or "",
		round_description = tRoundData ~= nil and tRoundData.Description or "",

		round_time = self.fRoundTime,
		round_enemys_total = self:GetRoundEnemyTotal(self:GetRound()),
	}
	CustomNetTables:SetTableValue("common", "round_info", table)

	local tPlayerData = {}
	DotaTD:EachPlayer(function(_, iPlayerID)
		tPlayerData[iPlayerID] = {
			kill_enemy = self:GetPlayerRoundKilledCount(iPlayerID),
		}
	end)
	CustomNetTables:SetTableValue("common", "round_player_info", tPlayerData)
end

--获取真实回合
function public:GetRound()
	return self.iRound
end
function public:GetActualRound()
	return self.iActualRound
end
function public:SetRound(iVal)
	self.iLastRound = self.iRound
	self.iRound = iVal
	if 10000 > iVal then
		self.iActualRound = iVal
	end
end

---获取回合数据
function public:GetRoundData(round)
	if not round then round = self:GetRound() end
	local sRoundName = "round_" .. round
	local tData = self.WaveKv[sRoundName]
	return tData, sRoundName
end
---获取某回合扣血模式
---@return number x=0按漏怪单位扣血 x>0回合失败扣x条命 x=-1回合失败直接扣到1血
function public:GetRoundLoseHPMode(round)
	local tData = self:GetRoundData(round)
	return tData and tData.lose_hp_mode or 0
end

---获取某回合战斗时间
function public:GetRoundBattleTime(iRound)
	local fTime = 0
	local tRoundData = self:GetRoundData(iRound)
	if tRoundData then
		fTime = tRoundData.MaxBattleTime

		-- 计算宝箱关加成时间
		if self:IsGoldRound(iRound) then
			local iMax = 0
			DotaTD:EachPlayer(function(_, iPlayerID)
				if PlayerData:IsPlayerDeath(iPlayerID) then return end
				local fTimeBonus = GetGoldRoundDurationBonus(iPlayerID)
				if iMax < fTimeBonus then
					iMax = fTimeBonus
				end
			end)
			fTime = fTime + iMax
		end
	end
	return fTime
end

--获取回合怪物刷新数量总数
function public:GetRoundEnemyTotal(round)
	local iCount = 0
	local tData = self:GetRoundData(round)
	if tData then
		for k, tEnemyStyle in pairs(tData) do
			if 'table' == type(tEnemyStyle) and tEnemyStyle.tUnitSpawnInfo then
				local iSpawnCount = tonumber(tEnemyStyle.SpawnCount) or 0
				iCount = iCount + (#tEnemyStyle.tUnitSpawnInfo * iSpawnCount)
			end
		end
	end
	return iCount
end

--获取玩家当前回合怪物击杀数
function public:GetPlayerRoundKilledCount(iPlayerID)
	return self.PlayerKilledCount[iPlayerID]
end

--获取玩家当前回合待刷新怪物数
function public:GetPlayerNoSpawnCount(iPlayerID)
	local iCount = self:GetRoundEnemyTotal(self:GetRound()) - (self.tPlayerSpawnedCount[iPlayerID] or 0)
	return iCount
end

--获取玩家剩余怪物数量
function public:GetPlayerMissingCount(iPlayerID)
	local iMissingCount = 0

	if self.PlayerMissing[iPlayerID] then
		for i = #self.PlayerMissing[iPlayerID], 1, -1 do
			local hUnit = self.PlayerMissing[iPlayerID][i]
			if IsValid(hUnit) and hUnit:IsAlive() then
				iMissingCount = iMissingCount + 1
			else
				table.remove(self.PlayerMissing[iPlayerID], i)
			end
		end
	end

	iMissingCount = iMissingCount + #self.PublicMissing
	return iMissingCount
end
--获取玩家剩余原生进攻怪物数量（即不含怪物分裂或者召唤的额外单位）
function public:GetPlayerMissingRoundEnemyCount(iPlayerID)
	local iMissingCount = 0
	for i = #self.PlayerMissing[iPlayerID], 1, -1 do
		local hUnit = self.PlayerMissing[iPlayerID][i]
		if IsValid(hUnit) and hUnit:IsAlive() then
			if hUnit.bRoundEnemy then
				iMissingCount = iMissingCount + 1
			end
		else
			table.remove(self.PlayerMissing[iPlayerID], i)
		end
	end
	return iMissingCount
end

--获取玩家当前回合入门怪数量
function public:GetPlayerEnterDoorCount(iPlayerID)
	return self.PlayerEnterDoor[iPlayerID] or 0
end

--获取玩家某回合漏怪数量（时间到了没杀死+进门的）
function public:GetPlayerRoundMissCount(iPlayerID, iRound)
	return self.tPlayerRoundMissCount[iPlayerID][iRound or self:GetRound()] or 0
end

--选取进攻怪物，bIncludeGoldCreep为是否选择打金怪（默认为true）
-- 例：
-- 1.选取所有的单位
-- 	Spawner:GetMissing()、Spawner:GetMissing(-1)
-- 2.选择非打金单位
-- 	Spawner:GetMissing(false)、Spawner:GetMissing(-1/0/1/2/3, false)
-- 3.选择玩家单位
-- 	Spawner:GetMissing(0)
function public:GetMissing(iPlayerID, bIncludeGoldCreep)
	if iPlayerID == nil then
		iPlayerID = -1
		bIncludeGoldCreep = nil
	elseif type(iPlayerID) == "boolean" then
		bIncludeGoldCreep = iPlayerID
		iPlayerID = -1
	end
	if bIncludeGoldCreep == nil then
		bIncludeGoldCreep = true
	end
	local tUnits = {}

	for i = #self.PublicMissing, 1, -1 do
		local hUnit = self.PublicMissing[i]
		if IsValid(hUnit) and hUnit:IsAlive() then
			table.insert(tUnits, hUnit)
		end
	end

	if iPlayerID == -1 then
		for iPlayerID, tMissing in pairs(self.PlayerMissing) do
			for i = #tMissing, 1, -1 do
				local hUnit = tMissing[i]
				if IsValid(hUnit) and hUnit:IsAlive() then
					table.insert(tUnits, hUnit)
				end
			end
		end
		if bIncludeGoldCreep then
			for iPlayerID, tMissing in pairs(self.PlayerGoldCreeps) do
				for i = #tMissing, 1, -1 do
					local hUnit = tMissing[i]
					if IsValid(hUnit) and hUnit:IsAlive() then
						table.insert(tUnits, hUnit)
					end
				end
			end
		end
	else
		for i = #self.PlayerMissing[iPlayerID], 1, -1 do
			local hUnit = self.PlayerMissing[iPlayerID][i]
			if IsValid(hUnit) and hUnit:IsAlive() then
				table.insert(tUnits, hUnit)
			end
		end
		if bIncludeGoldCreep then
			for i = #self.PlayerGoldCreeps[iPlayerID], 1, -1 do
				local hUnit = self.PlayerGoldCreeps[iPlayerID][i]
				if IsValid(hUnit) and hUnit:IsAlive() then
					table.insert(tUnits, hUnit)
				end
			end
		end
	end
	return tUnits
end

--- 获取一个玩家的进攻怪包含宝箱
function public:GetPlayerMissing(iPlayerID)
	local tUnits = {}

	if self.PlayerMissing[iPlayerID] then
		for i = #self.PlayerMissing[iPlayerID], 1, -1 do
			local hUnit = self.PlayerMissing[iPlayerID][i]
			if IsValid(hUnit) and hUnit:IsAlive() then
				table.insert(tUnits, hUnit)
			end
		end
	end

	if self.PlayerGoldCreeps[iPlayerID] then
		for i = #self.PlayerGoldCreeps[iPlayerID], 1, -1 do
			local hUnit = self.PlayerGoldCreeps[iPlayerID][i]
			if IsValid(hUnit) and hUnit:IsAlive() then
				table.insert(tUnits, hUnit)
			end
		end
	end

	for i = #self.PublicMissing, 1, -1 do
		local hUnit = self.PublicMissing[i]
		if IsValid(hUnit) and hUnit:IsAlive() then
			table.insert(tUnits, hUnit)
		end
	end

	return tUnits
end

---遍历进攻怪物
---@param func function function(hUnit)
function public:EachEnemies(iPlayerID, func)

	for i = #self.PublicMissing, 1, -1 do
		local hUnit = self.PublicMissing[i]
		if IsValid(hUnit) and func(hUnit) then
			return true
		end
	end

	if iPlayerID and self.PlayerMissing[iPlayerID] then
		for i = #self.PlayerMissing[iPlayerID], 1, -1 do
			local hUnit = self.PlayerMissing[iPlayerID][i]
			if IsValid(hUnit) and func(hUnit) then
				return true
			end
		end
	else
		for iPlayerID, _ in pairs(self.PlayerMissing) do
			for i = #self.PlayerMissing[iPlayerID], 1, -1 do
				local hUnit = self.PlayerMissing[iPlayerID][i]
				if IsValid(hUnit) and func(hUnit) then
					return true
				end
			end
		end
	end
end

---圆形范围选择进攻怪物
function public:FindMissingInRadius(iTeamNumber, vPosition, fRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, iPlayerID, bIncludeGoldCreep)
	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, fRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)

	if iPlayerID ~= nil then
		local tMissing = self:GetMissing(iPlayerID, bIncludeGoldCreep)
		for i = #tTargets, 1, -1 do
			if TableFindKey(tMissing, tTargets[i]) == nil then
				table.remove(tTargets, i)
			end
		end
	end
	if self:IsBossRound() and #tTargets == 0 then
		return self:GetMissing()
	end
	return tTargets
end
--- 备战新回合
function public:StartRoundTimer()
	for i, _ in pairs(self.PlayerKilledCount) do
		self.PlayerKilledCount[i] = 0
	end
	for i, _ in pairs(self.tPlayerSpawnedCount) do
		self.tPlayerSpawnedCount[i] = 0
	end
	--重置当前回合入门怪数量
	for iPlayerID, _ in pairs(self.PlayerEnterDoor) do self.PlayerEnterDoor[iPlayerID] = 0 end

	-- 重置漏怪BOSS加强的属性
	if Spawner:IsBossRound() or 0 == self:GetRound() then
		for iPlayerID, _2 in pairs(self.tPlayerBossIntensify) do
			self.tPlayerBossIntensify[iPlayerID] = {}
		end
	end


	--触发回合转换事件
	if self.bNianRound then
		Spawner:SetRound(10001)
	else
		Spawner:SetRound(Spawner:GetRound() + 1)
	end

	---@class EventData_RoundChange
	local tEvent = { round = self:GetRound(), iLastRount = self.iLastRound }
	EventManager:fireEvent(ET_GAME.ROUND_CHANGE, tEvent)

	local tRoundData = self:GetRoundData()
	self.fRoundTime = GameRules:GetGameTime() + (tRoundData.PreparationTime or 25)

	--Boss回合 设置Boss区域视野
	if Spawner:IsBossRound() then
		--肉山区域视角切入
		self:SeeBoos(nil, self:GetRound(), true)
	end

	--清理上回合spawngroup
	for _, sg in pairs(self.tRoundSpawnGroups) do
		UnloadSpawnGroupByHandle(sg)
	end
	self.tRoundSpawnGroups = {}
	--获取spawngroup
	for k, v in pairs(tRoundData) do
		if "table" == type(v) and v.tUnitSpawnInfo then
			for _, tInfo in pairs(v.tUnitSpawnInfo) do
				PrecacheUnitByNameAsync(tInfo.sUnit, function(sg, b, c)
					table.insert(self.tRoundSpawnGroups, sg)
				end)
			end
		end
	end

	--幽灵单位
	self:GhostCome()

	self:UpdateNetTables()
end

--幽灵单位上场
function public:GhostCome()

	local tRoundData = self:GetRoundData()

	--清除上轮幽灵单位
	for _, v in pairs(self.tGhostEnemy) do
		if IsValid(v) then
			self:KillEnemy(v, true, false)
		end
	end
	self.tGhostEnemy = {}

	if self:IsBossRound() then
		for k, v in pairs(tRoundData) do
			if "table" == type(v) and v.tUnitSpawnInfo then
				for _, tInfo in pairs(v.tUnitSpawnInfo) do
					tInfo.tGhosts = {}
					local vPos, vDir = self:GetCreatePosDir(0, tInfo)
					local hUnit = self:CreateGhostWave(tInfo.sUnit, vPos, -vDir, 0)
					hUnit:AddNewModifier(hUnit, nil, "modifier_ghost_enemy", nil)
					table.insert(tInfo.tGhosts, hUnit)
				end
			end
		end
	else
		--普通关卡出怪动画
		DotaTD:EachPlayer(function(_, iPlayerID)
			if PlayerData:IsPlayerDeath(iPlayerID) then return end

			local iTeamID = PlayerData:GetPlayerTeamID(iPlayerID)
			local vPos = self.tTeamEnemyDoorPos[iTeamID]

			--传送门
			local iParticleID = ParticleManager:CreateParticle("particles/door/enemy_spawne_door.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 1, vPos)
			ParticleManager:SetParticleControlForward(iParticleID, 1, self.vTeamEnemyDoorDir)
			--
			--出怪 创建幽灵单位
			GameTimer(1.5, function()
				for k, v in pairs(tRoundData) do
					if "table" == type(v) and v.tUnitSpawnInfo then
						for _, tInfo in pairs(v.tUnitSpawnInfo) do
							tInfo.tGhosts = {}
							local vPos2, vDir = self:GetCreatePosDir(iPlayerID, tInfo)

							GameTimer(RandomFloat(0, 1), function()
								local hUnit = self:CreateGhostWave(tInfo.sUnit, vPos2, vDir, iPlayerID)
								vPos2 = GetGroundPosition(vPos2, hUnit)
								if not tInfo.tGhosts then tInfo.tGhosts = {} end
								table.insert(tInfo.tGhosts, hUnit)

								local fDuration = 0.5	--从传送门出来的时间
								hUnit:AddBuff(hUnit, BUFF_TYPE.INVINCIBLE, fDuration, true)
								hUnit:AddBuff(hUnit, BUFF_TYPE.HEX, fDuration, true)

								local hPtcl = CreateUnitByName("npc_dota_dummy", vPos, false, nil, nil, DOTA_TEAM_NOTEAM)
								hPtcl:SetAbsOrigin(vPos)
								hPtcl:AddNewModifier(hUnit, nil, "modifier_outdoor", { duration = fDuration })
								hPtcl:AddNewModifier(hPtcl, nil, "modifier_motion", {
									duration = fDuration,
									position_x = vPos2.x,
									position_y = vPos2.y,
									position_z = vPos2.z,
								})

								hUnit:GameTimer(fDuration, function()
									hUnit:AddNewModifier(hUnit, nil, "modifier_pudding", PUDDING_VALUES)
									hUnit:AddNewModifier(hUnit, nil, "modifier_ghost_enemy", nil)
								end)
							end)
						end
					end
				end
			end)

			--关闭
			GameTimer(5, function()
				ParticleManager:DestroyParticle(iParticleID, false)
			end)
		end)
	end
end

--开始刷怪
function public:StartWaveTimer(iRound)
	local tRoundData = self:GetRoundData(iRound)
	if tRoundData == nil then
		return
	end

	self.fRoundTime = GameRules:GetGameTime() + self:GetRoundBattleTime(iRound)
	self.fRoundStartTime = GameRules:GetGameTime()
	self:UpdateNetTables()

	-- 创建单位
	for sEnemyStyle, tEnemyStyle in pairs(tRoundData) do
		if "table" == type(tEnemyStyle) and tEnemyStyle.tUnitSpawnInfo then
			local fDelay = tonumber(tEnemyStyle.SpawnDelay) or 0
			GameTimer(sEnemyStyle, fDelay, function()
				self:StartWavePointTimer(iRound, sEnemyStyle, tEnemyStyle)
			end)
		end
	end
end
--开始刷各别点的怪
function public:StartWavePointTimer(round, sEnemyStyle, tEnemyStyle)
	for _, tInfo in pairs(tEnemyStyle.tUnitSpawnInfo) do

		local iCount = tonumber(tEnemyStyle.SpawnCount) or 0
		local fTick = tonumber(tEnemyStyle.SpawnTick) or 1
		local tInfo = tInfo
		local sPoint = tInfo.sPoint

		local tSpawnPointUnit = {}

		local function spawn_once(iPlayerID, tPlayerSpawnData)
			if self:GetRound() ~= round or GSManager:getStateType() ~= GS_Battle then
				return
			end
			if not Spawner:IsBossRound() and PlayerData:IsPlayerDeath(iPlayerID) then return end

			if not tPlayerSpawnData then
				tPlayerSpawnData = {
					iCount = iCount
				}
			end

			if 0 < tPlayerSpawnData.iCount then
				tPlayerSpawnData.iCount = tPlayerSpawnData.iCount - 1

				local vPos, vDir = self:GetCreatePosDir(iPlayerID, tInfo)
				local hUnit = self:CreateWave(tInfo.sUnit, vPos, vDir, iPlayerID, true)

				if not tSpawnPointUnit[iPlayerID] then tSpawnPointUnit[iPlayerID] = {} end
				table.insert(tSpawnPointUnit[iPlayerID], hUnit)

				if 0 < tPlayerSpawnData.iCount then
					hUnit.funcSpawnOnce = function()
						spawn_once(iPlayerID, tPlayerSpawnData)
					end
					hUnit.tSpawnPointUnit = tSpawnPointUnit[iPlayerID]
					GameTimer(sEnemyStyle .. sPoint .. iPlayerID, fTick, function()
						GameTimer(0, function()
							spawn_once(iPlayerID, tPlayerSpawnData)
						end)
					end)
					return
				end
			end

			--刷怪完成杀死幽灵
			if tInfo.tGhosts then
				for _, hGhost in pairs(tInfo.tGhosts) do
					if IsValid(hGhost) then
						local iPlayerIDGhost = GetPlayerID(hGhost)
						if iPlayerIDGhost == -1 then
							self:KillEnemy(hGhost, true, false)
						elseif iPlayerIDGhost == iPlayerID then
							self:KillEnemy(hGhost, true, false)
						end
					end
				end
				if 0 == #tInfo.tGhosts then
					tInfo.tGhosts = nil
				end
			end
		end

		if Spawner:IsBossRound() then
			spawn_once(0)
		else
			DotaTD:EachPlayer(function(n, iPlayerID)
				spawn_once(iPlayerID)
			end)
		end
	end
end

---获取怪物生成点和朝向
function public:GetCreatePosDir(iPlayerID, tInfo)
	local iTeamID = PlayerData:GetPlayerTeamID(iPlayerID)
	local tSpawner = self.tSpawner[iTeamID]
	local vSpawnPos = tSpawner[tInfo.sPoint]
	if vSpawnPos then
		local vDir = (self.tTeamMapPoints[iTeamID]:GetAbsOrigin() - vSpawnPos):Normalized()
		vDir.z = 0
		return vSpawnPos + tInfo.vPosOffset, vDir
	end
end

--创建原始怪物
function public:CreateBaseWave(sUnitName, vPos, vForward, iPlayerID)
	local hUnit = CreateUnitByName(sUnitName, vPos, true, nil, nil, DOTA_TEAM_BADGUYS)
	hUnit.Spawner_spawnerPlayerID = iPlayerID
	hUnit.sUnitName = sUnitName
	hUnit:SetForwardVector(vForward)

	-- 注册属性
	Attributes:Register(hUnit)
	hUnit:AddNewModifier(hUnit, nil, "modifier_enemy_attribute", nil)

	if hUnit:IsBoss() then
		hUnit.Spawner_spawnerPlayerID = -1 --标记为公共怪物
	end

	return hUnit
end

--创建进攻怪物
---@param bRoundEnemy bool 是否本回合配置进攻怪
function public:CreateWave(sUnitName, vPos, vForward, iPlayerID, bRoundEnemy)
	local hUnit = self:CreateBaseWave(sUnitName, vPos, vForward, iPlayerID)

	hUnit:AddNewModifier(hUnit, nil, "modifier_wave", nil)
	hUnit:AddNewModifier(hUnit, nil, "modifier_death_knockback", nil)
	hUnit:SetWaveTag(true)

	hUnit.bRoundEnemy = bRoundEnemy
	if bRoundEnemy then
		if self:IsBossRound() then
			DotaTD:EachPlayer(function(_, iPlayerID2)
				self.tPlayerSpawnedCount[iPlayerID2] = (self.tPlayerSpawnedCount[iPlayerID2] or 0) + 1
			end)
		else
			self.tPlayerSpawnedCount[iPlayerID] = (self.tPlayerSpawnedCount[iPlayerID] or 0) + 1
		end
	end

	-- 朝向
	hUnit:SetForwardVector(vForward)

	-- 经验
	hUnit.deathXP = hUnit:GetDeathXP()
	hUnit:SetDeathXP(0)

	-- 默认技能按难度设置等级
	self:ModifyAbilityLevelByDiffculty(hUnit)

	--
	if self:IsBossRound() then
		--Boss关卡
		hUnit:AddNewModifier(hUnit, nil, "modifier_enemy_boss_ai", nil)
		table.insert(self.PublicMissing, hUnit)
		self.fBossStartTime = GameRules:GetGameTime()
	elseif self:IsGoldRound() then
		--宝箱关卡
		hUnit:AddNewModifier(hUnit, nil, "modifier_enemy_gold", nil)
		hUnit:AddNewModifier(hUnit, nil, "modifier_enemy_gold_ai", nil)
		table.insert(self.PlayerGoldCreeps[iPlayerID], hUnit)
		table.insert(self.PlayerMissing[iPlayerID], hUnit)
	else
		--正常关卡
		hUnit:AddNewModifier(hUnit, nil, "modifier_enemy_ai", nil)
		table.insert(self.PlayerMissing[iPlayerID], hUnit)
	end

	EventManager:fireEvent(ET_ENEMY.ON_SPAWNED, {
		PlayerID = iPlayerID,
		hUnit = hUnit,
	})

	EventManager:fireEvent(ET_PLAYER.ENEMY_COUNT_CHANGE, {
		PlayerID = iPlayerID,
		MissingCount = Spawner:GetPlayerMissingCount(iPlayerID),
	})

	return hUnit
end

--创建契约怪物
function public:PrepareContractMonster(tMonsterData, vPos, vForward, iPlayerID)
	vPos = GetGroundPosition(vPos, nil)
	local hUnit = CreateUnitByName(tMonsterData.name, vPos + Vector(0, 0, 1600), false, nil, nil, DOTA_TEAM_BADGUYS)
	hUnit.Spawner_spawnerPlayerID = iPlayerID
	hUnit.sUnitName = sUnitName
	hUnit:SetForwardVector(vForward)

	-- 注册属性
	Attributes:Register(hUnit)
	hUnit:SetVal(ATTRIBUTE_KIND.StatusHealth, tMonsterData.health, ATTRIBUTE_KEY.BASE)
	AttributeSystem[ATTRIBUTE_KIND.StatusHealth]:UpdateClient(hUnit, ATTRIBUTE_KEY.BASE)
	hUnit:SetVal(ATTRIBUTE_KIND.PhysicalAttack, tMonsterData.physical_attack, ATTRIBUTE_KEY.BASE)
	AttributeSystem[ATTRIBUTE_KIND.PhysicalAttack]:UpdateClient(hUnit, ATTRIBUTE_KEY.BASE)
	hUnit:SetVal(ATTRIBUTE_KIND.MagicalAttack, tMonsterData.magical_attack, ATTRIBUTE_KEY.BASE)
	AttributeSystem[ATTRIBUTE_KIND.MagicalAttack]:UpdateClient(hUnit, ATTRIBUTE_KEY.BASE)
	hUnit:SetVal(ATTRIBUTE_KIND.PhysicalArmor, tMonsterData.physical_armor, ATTRIBUTE_KEY.BASE)
	AttributeSystem[ATTRIBUTE_KIND.PhysicalArmor]:UpdateClient(hUnit, ATTRIBUTE_KEY.BASE)
	hUnit:SetVal(ATTRIBUTE_KIND.MagicalArmor, tMonsterData.magical_armor, ATTRIBUTE_KEY.BASE)
	AttributeSystem[ATTRIBUTE_KIND.MagicalArmor]:UpdateClient(hUnit, ATTRIBUTE_KEY.BASE)
	hUnit:AddNewModifier(hUnit, nil, "modifier_enemy_attribute", nil)
	hUnit:AddNewModifier(hUnit, nil, "modifier_death_knockback", nil)
	hUnit:AddNewModifier(hUnit, nil, "modifier_ghost_enemy", nil)

	local fDuration = 0.5

	hUnit:AddNewModifier(hUnit, nil, "modifier_motion", {
		duration = fDuration,
		position_x = vPos.x,
		position_y = vPos.y,
		position_z = vPos.z,
	})

	hUnit:GameTimer(fDuration, function()
		if hUnit:HasModifier("modifier_ghost_enemy") then
			hUnit:AddNewModifier(hUnit, nil, "modifier_pudding", PUDDING_VALUES)
		end
	end)

	hUnit:SetWaveTag(true)

	-- 朝向
	hUnit:SetForwardVector(vForward)

	-- 经验
	hUnit.deathXP = hUnit:GetDeathXP()
	hUnit:SetDeathXP(0)

	-- 默认技能按难度设置等级
	self:ModifyAbilityLevelByDiffculty(hUnit)

	return hUnit
end

--创建幽灵怪物
function public:CreateGhostWave(sUnitName, vPos, vForward, iPlayerID)
	local hUnit = self:CreateBaseWave(sUnitName, vPos, vForward, iPlayerID)
	table.insert(self.tGhostEnemy, hUnit)
	return hUnit
end
-- 获取boss击杀存活时间
function public:GetBossKillTime(iRound)
	return self.tBossKillTimes[iRound or self:GetRound()]
end


--修改怪物默认技能等级
function public:ModifyAbilityLevelByDiffculty(hUnit)
	-- for i = 0, 16 do
	-- 	local hDefaultAbility = hUnit:GetAbilityByIndex(i)
	-- 	if hDefaultAbility ~= nil then
	-- 		local iMaxAbilityLevel = hDefaultAbility:GetMaxLevel()
	-- 		local iMinAbilityLevel = 1
	-- 		local difficulty = GameMode:GetDifficulty()
	-- 		local iDefaultAbilityLevel = difficulty + 1
	-- 		hDefaultAbility:SetLevel(math.min(iMaxAbilityLevel, iDefaultAbilityLevel))
	-- 	end
	-- end
	--伤害玩家的技能，宝箱怪不造伤害
	if not self:IsGoldRound() then
		if self:IsBossRound() then
			hUnit:AddAbility('boss_damage_player')
		else
			hUnit:AddAbility('enemy_damage_player')
		end
	end
end

--获取怪物属于的玩家ID
function public:GetEnemyPlayerID(hUnit)
	return hUnit.Spawner_spawnerPlayerID
end

--清除玩家的怪物
function public:ClearEnemy(iPlayerID)

	for i = #self.PublicMissing, 1, -1 do
		local hUnit = self.PublicMissing[i]
		table.remove(self.PublicMissing, i)
		if IsValid(hUnit) then
			self:KillEnemy(hUnit, true, true)
		end
	end

	for _iPlayerID, v in pairs(self.PlayerMissing) do
		if nil == iPlayerID or iPlayerID == _iPlayerID then
			for i = #v, 1, -1 do
				local hUnit = v[i]
				table.remove(v, i)
				if IsValid(hUnit) then
					self:KillEnemy(hUnit, true, true)
				end
			end
		end
	end
end
--清除一个怪物数据
function public:ClearEnemyOne(hUnit)
	if not hUnit.Spawner_spawnerPlayerID then return end
	local iPlayerID = hUnit.Spawner_spawnerPlayerID

	if - 1 ~= iPlayerID then
		--个人怪物
		local i = KEY(self.PlayerMissing[iPlayerID], hUnit)
		if i then
			table.remove(self.PlayerMissing[iPlayerID], i)
			self.PlayerKilledCount[iPlayerID] = 1 + self.PlayerKilledCount[iPlayerID]
			EventManager:fireEvent(ET_PLAYER.ENEMY_COUNT_CHANGE, {
				PlayerID = iPlayerID,
				MissingCount = Spawner:GetPlayerMissingCount(iPlayerID),
			})
			self:UpdateNetTables()
			return true
		end
	else
		--公共怪物
		local i = KEY(self.PublicMissing, hUnit)
		if i then
			table.remove(self.PublicMissing, i)
			for iPlayerID, _ in pairs(self.PlayerKilledCount) do
				self.PlayerKilledCount[iPlayerID] = 1 + self.PlayerKilledCount[iPlayerID]
				EventManager:fireEvent(ET_PLAYER.ENEMY_COUNT_CHANGE, {
					PlayerID = iPlayerID,
					MissingCount = Spawner:GetPlayerMissingCount(iPlayerID),
				})
			end
			self:UpdateNetTables()
			return true
		end
	end
end
--杀死一个怪物
function public:KillEnemy(hUnit, bImmediate, bDamagePlayer)
	if bImmediate then
		hUnit:AddNoDraw()
	end

	if not bDamagePlayer then
		hUnit:RemoveAbility('enemy_damage_player')
		-- hUnit:RemoveModifierByName("modifier_enemy_damage_player")
	end
	hUnit:ForceKill(false)
end

--获取寻路点
function public:GetEnemyMovePath(hEnemy)
	local iTeam = PlayerData:GetPlayerTeamID(hEnemy.Spawner_spawnerPlayerID)
	local vPos = hEnemy:GetAbsOrigin()
	local fDis
	local hPath
	for k, hPath2 in pairs(self.tPaths[iTeam]) do
		local fDisCur = (hPath2:GetAbsOrigin() - vPos):Length2D()
		if nil == fDis or fDisCur < fDis then
			fDis = fDisCur
			hPath = hPath2
		end
	end
	return hPath
end

--宝箱关卡处理
function public:CheckGoldCreeps()
	local damageInfo = {}
	for iPlayerID, goldCreeps in pairs(self.PlayerGoldCreeps) do
		if PlayerData:IsAlive(iPlayerID) then
			local damage = 0
			local iDeath = 0
			local iGold = 0
			local iCrystal = 0
			for i, goldCreep in pairs(goldCreeps) do
				if (goldCreep ~= nil and goldCreep.iDamageSum ~= nil) then
					damage = damage + (goldCreep.iDamageSum or 0)
					iDeath = iDeath + (goldCreep.iDeath or 0)
					iGold = iGold + (goldCreep.iGold or 0)
					iCrystal = iCrystal + (goldCreep.iCrystal or 0)
				end
			end
			self.PlayerGoldCreeps[iPlayerID] = {}

			---@class GoldRoundData
			local tGoldRoundData = {
				iPlayerID = iPlayerID,
				damage = damage,
				iDeath = iDeath,
				iGold = iGold,
				iCrystal = iCrystal,
			}
			table.insert(damageInfo, tGoldRoundData)
			self.tPlayerGoldCreepRounData[iPlayerID][self:GetRound()] = tGoldRoundData
		end
	end

	table.sort(damageInfo, function(a, b) return a.damage > b.damage end)

	Notification:Combat({ teamnumber = -1, message = "#Custom_DividingLine" })
	Notification:Combat({ teamnumber = -1, message = "#Custom_WaveGold" })

	for n, info in ipairs(damageInfo) do
		local totalDamage = info.damage
		local iPlayerID = info.iPlayerID
		local hero = PlayerData:GetHero(iPlayerID)
		local round = math.max(self:GetRound() - 1, 1)

		local bounty = 0

		--
		local gameEvent = {}
		gameEvent["player_id"] = iPlayerID
		gameEvent["int_value"] = bounty
		gameEvent["locstring_value"] = totalDamage
		gameEvent["int_death_count"] = info.iDeath
		gameEvent["int_good"] = info.iGold
		gameEvent["int_crystal"] = info.iCrystal
		gameEvent["string_unit_of_measurement"] = ''
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#Custom_WaveGold_" .. n

		local iVal, sUnit = NumberUnitization(totalDamage)
		if sUnit then
			gameEvent["locstring_value"] = string.format("%.2f", iVal)
			gameEvent["string_unit_of_measurement"] = '#' .. sUnit
		else
			gameEvent["locstring_value"] = string.format("%.0f", iVal)
			gameEvent["string_unit_of_measurement"] = ''
		end
		Notification:Combat(gameEvent)

		if n == 1 then
			Notification:Upper(gameEvent)
		end

		if IsValid(hero) then
			SendOverheadEventMessage(PlayerResource:GetPlayer(iPlayerID), OVERHEAD_ALERT_GOLD, hero, bounty, nil)
			hero:EmitSound("General.CoinsBig")
		end
	end
	Notification:Combat({ teamnumber = -1, message = "#Custom_DividingLine" })
end

---获取玩家打金回合数据
---@return GoldRoundData
function public:GetPlayerGoldRoundData(iPlayerID, iRound)
	local t = self.tPlayerGoldCreepRounData[iPlayerID]
	if t then
		return t[iRound or self:GetRound()]
	end
end

---获取玩家Boss区域位置
function public:GetPlayerBossPos(iPlayerID)
	local vPos = self.hBossMapPoint:GetAbsOrigin()
	local iTeamID = PlayerData:GetPlayerTeamID(iPlayerID)
	vPos = vPos + (self.tTeamBossMapPoints[iTeamID]:GetAbsOrigin() - self.hBossMapPoint:GetAbsOrigin()) / 2
	return vPos
end

---镜头切入Boss区域
function public:SeeBoos(iPlayerID, iRound, bOffset, fTime)
	local vPos = self.hBossMapPoint:GetAbsOrigin()
	if iPlayerID then
		if fTime then
			AddFOWViewer(DOTA_TEAM_CUSTOM_1 + iPlayerID, vPos, 2500, fTime, false)
		end
		if bOffset then
			--向玩家棋盘位置偏移
			vPos = self:GetPlayerBossPos(iPlayerID)
		end
		LetMeSeeSee(iPlayerID, vPos, fTime)
	else
		DotaTD:EachPlayer(function(_, iPlayerID)
			vPos = self:SeeBoos(iPlayerID, iRound, bOffset, fTime)
		end)
	end
	return vPos
end

---镜头切入点击头像玩家区域
function public:SeePlayer(iPlayerID, iTargetPlayerID)
	local hPoint = Spawner.tTeamCameraPos[PlayerData:GetPlayerTeamID(iTargetPlayerID)]
	if hPoint then
		LetMeSeeSee(iPlayerID, hPoint)
	end
end
---给某队伍添加某队伍场地的视野
function public:SetTeamFow(iTeamID, iTeamIDTarget, iDuration, bStop)
	if not self.tTeamFow then
		self.tTeamFow = {}
	end
	if not self.tTeamFow[iTeamID] then
		self.tTeamFow[iTeamID] = {}
	end

	if self.tTeamFow[iTeamID][iTeamIDTarget] == -1 then
		-- 已经开启永久视野
		return
	end

	local function setFow()
		for k, vPos in pairs(self.tTeamCameraPos) do
			if k == iTeamIDTarget then
				AddFOWViewer(DOTA_TEAM_CUSTOM_1 - 1 + iTeamID, Vector(vPos.x, vPos.y + 1100, 0), 2300, iDuration, false)	--上方刷怪区
				-- DebugDrawSphere(Vector(vPos.x, vPos.y + 1100, 0), Vector(0, 255, 0), 2300, 1000, false, 400)
				--
				AddFOWViewer(DOTA_TEAM_CUSTOM_1 - 1 + iTeamID, Vector(vPos.x, vPos.y, 0), 1500, iDuration, false)		--中间
				AddFOWViewer(DOTA_TEAM_CUSTOM_1 - 1 + iTeamID, Vector(vPos.x - 1000, vPos.y - 800, 0), 1000, iDuration, false)		--中左下
				AddFOWViewer(DOTA_TEAM_CUSTOM_1 - 1 + iTeamID, Vector(vPos.x + 1000, vPos.y - 800, 0), 1000, iDuration, false)		--中右下

				AddFOWViewer(DOTA_TEAM_CUSTOM_1 - 1 + iTeamID, Vector(vPos.x, vPos.y - 1100, 0), 1000, iDuration, false)	--下方中间
				AddFOWViewer(DOTA_TEAM_CUSTOM_1 - 1 + iTeamID, Vector(vPos.x - 800, vPos.y - 1650, 0), 1000, iDuration, false)--下方左
				AddFOWViewer(DOTA_TEAM_CUSTOM_1 - 1 + iTeamID, Vector(vPos.x + 800, vPos.y - 1650, 0), 1000, iDuration, false)--下方右
			end
		end
	end

	if iDuration then
		self.tTeamFow[iTeamID][iTeamIDTarget] = iDuration
		if 0 < iDuration then
			GameTimer('SetTeamFow' .. iTeamID .. '_' .. iTeamIDTarget, iDuration, function()
				self.tTeamFow[iTeamID][iTeamIDTarget] = nil
			end)
		end
		setFow()
	else
		if not bStop then
			-- 持续性
			iDuration = 1
			self.tTeamFow[iTeamID][iTeamIDTarget] = iDuration
			setFow()
			GameTimer('SetTeamFow' .. iTeamID .. '_' .. iTeamIDTarget, iDuration, function()
				setFow()
				return iDuration
			end)
		else
			self.tTeamFow[iTeamID][iTeamIDTarget] = nil
			StopGameTimer('SetTeamFow' .. iTeamID .. '_' .. iTeamIDTarget)
		end
	end
end

---展示某章节的Boss (章节开始时)
function public:ShowBoos(iRound, fTime)
	local iRoundBoss = (math.floor((iRound or self:GetRound()) / 10) + 1) * 10
	if self.bNianRound then
		iRoundBoss = 10001
	end
	local tRoundData = self:GetRoundData(iRoundBoss)
	local tEnt = {}

	for k, v in pairs(tRoundData) do
		if "table" == type(v) and v.tUnitSpawnInfo then
			for _, tInfo in pairs(v.tUnitSpawnInfo) do
				local vPos, vDir = self:GetCreatePosDir(0, tInfo)
				table.insert(tEnt, self:CreateBaseWave(tInfo.sUnit, vPos, Vector(0, -1, 0), 0))
			end
		end
	end

	for _, hUnit in pairs(tEnt) do
		hUnit:AddNewModifier(hUnit, nil, 'modifier_tpscroll', {
			duration = 2.5,
			x = hUnit:GetAbsOrigin().x,
			y = hUnit:GetAbsOrigin().y,
			z = hUnit:GetAbsOrigin().z,
		})
		hUnit:AddNewModifier(hUnit, nil, 'modifier_invincible', nil)
		hUnit:StartGesture(ACT_DOTA_VICTORY)
		hUnit:SetAbsOrigin(hUnit:GetAbsOrigin() + Vector(0, 0, 10000))
	end

	GameRules:GetGameModeEntity():GameTimer(fTime, function()
		for _, hUnit in pairs(tEnt) do
			self:KillEnemy(hUnit, true, false)
		end
	end)
end

---检测怪物进入传送门
function public:CheckEnterDoor(hEnemy)
	local iPlayerID = hEnemy.Spawner_spawnerPlayerID
	local iTeamID = PlayerData:GetPlayerTeamID(iPlayerID)

	if not self.tPlayerDoorPos then
		self.tPlayerDoorPos = {}
		for k, v in pairs(self.tTeamMapPoints) do
			local hDoor = Entities:FindByNameLike(nil, k .. TEAM_DOOR_POINT)
			self.tPlayerDoorPos[k] = hDoor
		end

		--开启检测
		self:CheckDoorOnOff()
	end

	local vPos = self.tPlayerDoorPos[iTeamID]:GetAbsOrigin()

	--进入开启范围
	if hEnemy:IsPositionInRange(vPos, TEAM_DOOR_RANGE) then
		EventManager:fireEvent(ET_ENEMY.ON_ENTER_DOOR, {
			entindex = hEnemy:entindex()
		})
		self:KillEnemy(hEnemy, true, true)
		return true
	end
	return false
end
---检测怪物进入的传送门的开启和关闭
function public:CheckDoorOnOff()
	DotaTD:EachPlayer(function(_, iPlayerID)
		local hPoint = self.tPlayerDoorPos[PlayerData:GetPlayerTeamID(iPlayerID)]
		local vPos = hPoint:GetAbsOrigin()
		local vDir = hPoint:GetForwardVector()
		local bOpen = false
		local iPtcl = nil

		local bHas
		local function EnemyInRange(hUnit)
			bHas = hUnit:IsPositionInRange(vPos, TEAM_DOOR_OPEN_RANGE)
			return bHas
		end

		GameTimer(iPlayerID * 0.2, function()
			bHas = false
			EachUnits(iPlayerID, EnemyInRange, UnitType.AllEnemies)

			if bHas then
				if not bOpen then
					bOpen = true
					iPtcl = ParticleManager:CreateParticle("particles/door/enemy_in_door_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(iPtcl, 1, vPos)
					ParticleManager:SetParticleControlForward(iPtcl, 1, vDir)
					GameTimer('OpeningEnemyInDoor' .. iPlayerID, 0.6, function()
						bOpen = 2
						ParticleManager:DestroyParticle(iPtcl, false)
						iPtcl = ParticleManager:CreateParticle("particles/door/enemy_in_door_permanent.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(iPtcl, 1, vPos)
						ParticleManager:SetParticleControlForward(iPtcl, 1, vDir)
					end)
				elseif bOpen == 3 then
					bOpen = 2
					StopGameTimer('OpeningEnemyInDoor' .. iPlayerID)
				end
			else
				if bOpen and bOpen ~= 3 then
					if bOpen == 2 then
						--延迟1秒在关闭
						bOpen = 3
						GameTimer('OpeningEnemyInDoor' .. iPlayerID, 1, function()
							bOpen = false
							ParticleManager:DestroyParticle(iPtcl, false)
							iPtcl = ParticleManager:CreateParticle("particles/door/enemy_in_door_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
							ParticleManager:SetParticleControl(iPtcl, 1, vPos)
							ParticleManager:ReleaseParticleIndex(iPtcl)
						end)
					else
						StopGameTimer('OpeningEnemyInDoor' .. iPlayerID)
						ParticleManager:DestroyParticle(iPtcl, false)
						iPtcl = ParticleManager:CreateParticle("particles/door/enemy_in_door_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(iPtcl, 1, vPos)
						ParticleManager:ReleaseParticleIndex(iPtcl)
						bOpen = false
					end
				end
			end

			return 0.5
		end)
	end)
end

--是否Boss回合
function public:IsBossRound(iRound)
	return 'boss' == self:GetRoundType(iRound)
end
--是否年兽回合
function public:IsNianRound(iRound)
	return iRound == 10001
end
--是否宝箱回合
function public:IsGoldRound(iRound)
	return 'chest' == self:GetRoundType(iRound)
end
--是否精英回合
function public:IsMobsRound(iRound)
	return 'mobs' == self:GetRoundType(iRound)
end
--获取某回合的回合类型
function public:GetRoundType(iRound)
	local tData = self:GetRoundData(iRound)
	return (tData and tData.RoundType) and tData.RoundType or 'normal'
end
-- 加入玩家怪物表
function public:AddMissing(iPlayerID, hUnit)
	if iPlayerID ~= nil then
		hUnit.Spawner_spawnerPlayerID = iPlayerID
		table.insert(self.PlayerMissing[iPlayerID], hUnit)
	else
		hUnit.Spawner_spawnerPlayerID = -1
		table.insert(self.PublicMissing, hUnit)
	end
end
-- 魅惑单位
function public:Charm(hCaster, hTarget, hAblt)
	if not IsValid(hCaster) or not IsValid(hTarget) then return end

	local iPlayerIDCaster = GetPlayerID(hCaster)
	hTarget:RemoveModifierByName("modifier_enemy_ai")
	hTarget:RemoveModifierByName("modifier_enemy_damage_player")
	hTarget:SetUnitCanRespawn(true)
	hTarget:Kill(hAblt, hCaster)
	-- PlayerData:ModifyGold(iPlayerIDCaster, hTarget:GetGoldBounty())
	-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, hTarget, hTarget:GetGoldBounty(), nil)
	hTarget:RespawnUnit()
	hTarget:SetUnitCanRespawn(false)
	hTarget:SetTeam(hCaster:GetTeam())
	hTarget:SetControllableByPlayer(-1, true)
	hTarget:SetOwner(hCaster)
	hTarget:FireSummonned(hCaster)
	ArrayRemove(self.PlayerMissing[iPlayerIDCaster], hTarget)
end

return public