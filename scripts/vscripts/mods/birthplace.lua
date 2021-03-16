if Birthplace == nil then
	---出生岛
	---@class Birthplace
	Birthplace = {
		--- 点实体
		hMapPointEnt = nil,
		tPlayerPointEnts = {},
		tCommanderPointEnts = {},

		---玩家准备情况
		tPlayerReady = {},
		---玩家难度选择情况
		tPlayerDifficultyChose = {},
		---将要分配的难度
		typeDifficulty = nil,
	}
end
---@type Birthplace
local public = Birthplace

function public:init(bReload)
	if not bReload then
		-- 视野
		local hEnt = Entities:FindByNameLike(nil, 'birthplace_main')
		if hEnt then
			for i = 1, 4 do
				AddFOWViewer(DOTA_TEAM_CUSTOM_1 - 1 + i, hEnt:GetAbsOrigin(), 2750, -1, false)
			end
			AddFOWViewer(DOTA_TEAM_GOODGUYS, hEnt:GetAbsOrigin(), 2750, -1, false)
		end
	end


	-- find需要的点实体
	local function loadPlayerPointEnt(t, sName)
		local tEnts = Entities:FindAllByNameLike(sName)
		for _, hEnt in pairs(tEnts) do
			local tS = string.split(hEnt:GetName(), '_')
			local iPlayerID = tonumber(tS[#tS])
			t[iPlayerID] = hEnt
		end
	end
	loadPlayerPointEnt(self.tPlayerPointEnts, 'birthplace_player_')
	loadPlayerPointEnt(self.tCommanderPointEnts, 'birthplace_commander_player_')

	-- 给地图建筑添加默认modifier
	local tEnts = Entities:FindAllByNameLike('birthplace_building')
	for _, hEnt in pairs(tEnts) do
		local tKV = KeyValues.UnitsKv[hEnt:GetUnitName()]
		if tKV and tKV.AmbientModifiers then
			hEnt:RemoveModifierByName(tKV.AmbientModifiers)
			hEnt:AddNewModifier(hEnt, nil, tKV.AmbientModifiers, nil)
		end
	end

	CustomUIEvent("PlayerReady", Dynamic_Wrap(public, "OnPlayerReady"), public)
	CustomUIEvent("PlayerSetDifficulty", Dynamic_Wrap(public, "OnPlayerSetDifficulty"), public)

	EventManager:register(ET_GAME.GAME_READY, 'OnGameReady', self)
end

--UI监听************************************************************************************************************************
	do
	-- 玩家准备
	function public:OnPlayerReady(_, tEvent)
		local iPlayerID = tEvent.PlayerID
		self.tPlayerReady[tostring(iPlayerID)] = true

		local bAllReady = true
		DotaTD:EachPlayer(function(n, iPlayerID)
			if not self.tPlayerReady[tostring(iPlayerID)] then
				bAllReady = false
				return true
			end
		end)
		if bAllReady then
			if GSManager:getStateType() == GS_Ready then
				--设置难度
				GameMode:SetDifficulty(self.typeDifficulty)

				-- 请求更换过的商品
				Service:ReqGoodsSet()

				--开始游戏
				GSManager:switch(GS_Begin)
			end
		end

		NetEventData:SetTableValue("birthplace", "player_ready", self.tPlayerReady)
	end

	-- 玩家在营地选择难度
	function public:OnPlayerSetDifficulty(_, tEvent)
		local iPlayerID = tEvent.PlayerID
		if nil == iPlayerID then return end

		local typeDifficulty = tonumber(tEvent.typeDifficulty)

		if not DIFFICULTY_INFO[typeDifficulty] then
			ErrorMessage(iPlayerID, 'error_difficulty_type')
			return
		end

		-- 玩家选择难度是否解锁
		if 0 < typeDifficulty then
			local tProgress = NetEventData:GetTableValue('service', 'player_adventure_progress_' .. iPlayerID)
			if nil == tProgress or nil == tProgress[tostring(typeDifficulty)] then
				ErrorMessage(iPlayerID, 'error_difficulty_lock')
				return
			end
		elseif typeDifficulty == DIFFICULTY.Endless then
			-- 无尽轮回
			local iEndlessLayer = tonumber(NetEventData:GetTableValue('service', 'player_endless_layers_' .. iPlayerID)) or 0
			if 0 == iEndlessLayer then
				ErrorMessage(iPlayerID, 'error_difficulty_lock')
				return
			end

			-- 需要全玩家均解锁
			local bCheck = true
			DotaTD:EachPlayer(function(_, iPlayerID2)
				local iEndlessLayer = tonumber(NetEventData:GetTableValue('service', 'player_endless_layers_' .. iPlayerID2)) or 0
				if 0 == iEndlessLayer then
					bCheck = false
					return true
				end
			end)
			if not bCheck then
				ErrorMessage(iPlayerID, 'error_difficulty_lock_other')
				return
			end
		end

		self.tPlayerDifficultyChose[iPlayerID] = typeDifficulty
		NetEventData:SetTableValue("birthplace", "player_difficulty", self.tPlayerDifficultyChose)

		-- 计算系统将分配的难度：人数 > 最底难度
		local iDifficulty = nil
		local iMax = 0
		local tDifs = {}
		for iPlayerID, iDifCur in pairs(self.tPlayerDifficultyChose) do
			tDifs[iDifCur] = (tDifs[iDifCur] or 0) + 1
		end
		for iDifCur, iCount in pairs(tDifs) do
			if iCount > iMax then
				iMax = iCount
				iDifficulty = iDifCur
			elseif (iCount == iMax) then
				if not iDifficulty or iDifficulty > iDifCur then
					iDifficulty = iDifCur
				end
			end
		end
		if iDifficulty then
			self.typeDifficulty = iDifficulty
			NetEventData:SetTableValue("birthplace", "difficulty_will", self.typeDifficulty)
		end
	end
end
--事件监听************************************************************************************************************************
	do
	-- 进入准备阶段，设置默认营地难度选择
	function public:OnGameReady()
		-- 添加一个游走的年兽
		local hEnt = Entities:FindByNameLike(nil, 'birthplace_main')
		if hEnt then
			local hUnit = CreateUnitByName("npc_courier_niunian", hEnt:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NOTEAM)
			hUnit:GameTimer(0.5, function()
				hUnit:AddNewModifier(hUnit, nil, "modifier_courier_nian", nil)
				hUnit:AddNewModifier(hUnit, nil, "modifier_niunian", nil)
			end)
		end

		--设置默认难度选择
		self.typeDifficulty = DIFFICULTY_DEFAULT
		DotaTD:EachPlayer(function(_, iPlayerID)
			local tProgress = NetEventData:GetTableValue('service', 'player_adventure_progress_' .. iPlayerID) or {}
			local max = 1
			for i, v in pairs(tProgress) do
				if tonumber(i) and tonumber(i) > max then
					max = tonumber(i)
				end
			end
			-- local diffi = 'N' + max
			self.tPlayerDifficultyChose[iPlayerID] = max
		end)

		-- 计算系统将分配的难度：人数 > 最底难度
		local iDifficulty = nil
		local iMax = 0
		local tDifs = {}
		for iPlayerID, iDifCur in pairs(self.tPlayerDifficultyChose) do
			tDifs[iDifCur] = (tDifs[iDifCur] or 0) + 1
		end
		for iDifCur, iCount in pairs(tDifs) do
			if iCount > iMax then
				iMax = iCount
				iDifficulty = iDifCur
			elseif (iCount == iMax) then
				if not iDifficulty or iDifficulty > iDifCur then
					iDifficulty = iDifCur
				end
			end
		end
		if nil ~= iDifficulty then
			self.typeDifficulty = iDifficulty
		end

		NetEventData:SetTableValue("birthplace", "player_difficulty", self.tPlayerDifficultyChose)
		NetEventData:SetTableValue("birthplace", "difficulty_will", self.typeDifficulty)
	end
end
--后台请求************************************************************************************************************************
	do
end
--后台请求************************************************************************************************************************
--
function public:UpdateNetTables()

end
---将玩家放置在出生岛
function public:SetPlayerInBirthplace(iPlayerID)
	DotaTD:EachPlayer(function(_, _iPlayerID)
		if not iPlayerID or _iPlayerID == iPlayerID then
			--移动主角
			local hHero = PlayerData:GetHero(_iPlayerID)
			if IsValid(hHero) then
				local hPoint = self.tPlayerPointEnts[_iPlayerID]
				if IsValid(hPoint) then
					FindClearSpaceForUnit(hHero, hPoint:GetAbsOrigin(), true)
					LetMeSeeSee(_iPlayerID, hHero)
					hHero:SetForwardVector(hPoint:GetForwardVector())
				end
			end
		end
	end)
end


return public