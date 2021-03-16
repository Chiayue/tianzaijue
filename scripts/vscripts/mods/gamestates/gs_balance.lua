if nil == GS_Balance then
	---@class GS_Balance : State
	GS_Balance = {}
end
---@type GS_Balance
local public = GSManager:LoadState(...)

function public:init(bReload, typeState, ...)
	self.__base__.init(self, bReload, typeState, ...)
	self.tPlayerBalanceState = {}
	self.tPlayerBalanceData = {}

	EventManager:register(ET_PLAYER.ON_DEATH, 'OnPlayerDeath', self, -EVENT_LEVEL_ULTRA)
	EventManager:register(ET_PLAYER.ON_LOADED_FINISHED, 'OnLoaded_Finished', self, EVENT_LEVEL_ULTRA)
	-- CustomUIEvent("Balance_Over", Dynamic_Wrap(self, "GameIsOver"), self)
	CustomUIEvent("Balance_Over", Dynamic_Wrap(self, "GameIsOver"), self)
	-- CustomUIEvent("Balance_FeedBack", Dynamic_Wrap(self, "PlayerFeedBack"), self)
	Request:Event("player.feedback", Dynamic_Wrap(public, "PlayerFeedback"), public)
	Request:Event("player.get_balance_data", Dynamic_Wrap(public, "GetBalanceData"), public)
	Request:Event("endless.goto", Dynamic_Wrap(public, "PlayerEndlessReset"), public)
end


--UI监听************************************************************************************************************************
	do
	-- 所有人确认游戏结果
	function public:GameIsOver(eventSourceIndex, tEvent)
		local iPlayerID = tEvent.PlayerID
		self.tPlayerBalanceState[iPlayerID] = 2

		for _, iState in pairs(self.tPlayerBalanceState) do
			if iState ~= 2 then
				return
			end
		end
		GSManager:switch(GS_End)
	end
	-- 玩家反馈
	function public:PlayerFeedBack(eventSourceIndex, tEvent)
		local tData = {
			uid = GetAccountID(tEvent.PlayerID),
			match = GetMatchID(),
			vote = tEvent.vote,
			msg = tEvent.msg
		}
		Service:POST('player.feedback', tData, function(data)
		end)
	end

	function public:PlayerFeedback(params)
		local iPlayerID = params.PlayerID
		local vote = params.vote
		local msg = params.msg

		local data = Service:POSTSync("player.feedback", {
			uid = GetAccountID(iPlayerID),
			match = GetMatchID(),
			vote = vote,
			msg = msg
		})

		return data
	end
	function public:GetBalanceData(params)
		local iPlayerID = params.PlayerID

		return self.tPlayerBalanceData[iPlayerID] or {}
	end

	-- 玩家结算时重置轮回层数
	function public:PlayerEndlessReset(params)
		local iPlayerID = params.PlayerID
		local iLayer = params.layer

		local data = Service:POSTSync("endless.goto", {
			--第几层（第一层，或者上一层）
			uid = GetAccountID(iPlayerID),
			layer = iLayer,
		})

		return data
	end

end
--进入当前状态
function public:start()
	print('GS_Balance')
	EventManager:fireEvent(ET_GAME.GAME_BALANCE)
	DotaTD:EachPlayer(function(_, iPlayerID)
		if not PlayerData:IsPlayerDeath(iPlayerID) then
			local result = PlayerData:GetPlayerRoundResult(iPlayerID, Spawner:GetActualRound())
			self:GameBalance(iPlayerID, result)
			-- SendGameEvent2Player(iPlayerID, 'show_balance_info', {})
		end
	end)
end
function public:OnLoaded_Finished()
	DotaTD:EachPlayer(function(_, iPlayerID)
		self.tPlayerBalanceState[iPlayerID] = 0
	end)
end

--玩家死亡，检测全部玩家死亡游戏结束
function public:OnPlayerDeath(params)
	self:GameBalance(params.PlayerID, 0)

	local bAllDeath = true
	DotaTD:EachPlayer(function(_, iPlayerID)
		if not PlayerData:IsPlayerDeath(iPlayerID) then
			bAllDeath = false
			return true
		end
	end)
	-- 如果玩家全部死亡，整体结算判断ui显示结果->若点击->游戏结束
	if bAllDeath then
		GSManager:switch(GS_Balance)
		DotaTD:EachPlayer(function(_, iPlayerID)
			SendGameEvent2Player(iPlayerID, 'GameOver_ShowAll', {})
		end)
	end
end
-- 结算完成游戏结束
--当前状态的持续
function public:update()
end

--结算游戏
function public:GameBalance(iPlayerID, gameresult)
	if self.tPlayerBalanceState[iPlayerID] and self.tPlayerBalanceState[iPlayerID] > 0 then return end
	self.tPlayerBalanceState[iPlayerID] = 1

	local iRound = Spawner:GetActualRound()

	if 0 == gameresult then
		iRound = iRound - 1
	end

	self._time = Spawner:GetBossKillTime(iRound)

	local iPlayerCount = 0
	local tPlayerIDs = {}
	local allwin = 1
	DotaTD:EachPlayer(function(_, playerid)
		iPlayerCount = iPlayerCount + 1
		table.insert(tPlayerIDs, GetAccountID(playerid))
		if PlayerData:GetPlayerRoundResult(playerid, Spawner:GetActualRound()) ~= 1 then
			allwin = 0
		end
	end)

	local tData = {
		uid = GetAccountID(iPlayerID),
		round = iRound,
		win = gameresult,
		diff = GameMode:GetDifficulty(),
		total_gold = PlayerData:GetTotalGold(iPlayerID),
		total_crystal = PlayerData:GetTotalCrystal(iPlayerID),
		layer = GameMode:GetEndlessLayer(),
		commander = Commander:GetChloseCommanderID(iPlayerID),
		duration = math.round(GameRules:GetDOTATime(true, false), 0),
		boss_kill_time = self._time,
		game_time = GameRules:GetDOTATime(false, false),
		player_count = iPlayerCount,
		playerids = tPlayerIDs,
		allwin = allwin,
		nian = Spawner.bNianRound and 1 or 0, -- TODO： 是否击杀年兽
		-- nian = Spawner.bNianRound and 1 or 0, -- TODO： 是否开启年兽活动
		kill_nian = PlayerData:GetPlayerRoundResult(iPlayerID, 10001),
	}
	DeepPrintTable(tData)
	Service:POST('player.game_over', tData, function(data)
		-- 金币回合数据
		local goldRound = self:GetGoldRoundData(iRound)
		local tGoldRound = Spawner:GetPlayerGoldRoundData(iPlayerID, goldRound)
		if tGoldRound then
			-- 打金钱数
			self._iGold = tGoldRound.iGold
			-- 箱子伤害
			self._damage = tGoldRound.damage
			-- 箱子层数
			self._iDeath = tGoldRound.iDeath
		end

		------------------------------------------
		-- 本局加成档案经验
		local iaddxp = 0
		-- 本局天赋经验加成档案经验
		local italentaddxp = 0
		-- 本局vip加成档案经验
		local ivipaddxp = 0

		-- 本局加成bp经验
		local iaddbpxp = 0
		-- 本局双倍bp加成经验
		local idoublebpxp = 0
		-- 本局vip bp加成经验
		local ivipbpxp = 0

		local beAddCmdExp = 0
		local beAddherobox = 0

		-- 本局游戏评级
		local sRating = 0
		-- 结算星石星辉
		local istarstone = 0
		local istardust = 0
		local icmdxp = 0
		-- 结算运气奖励
		local tdropreward = {
		-- '4010003' = 1
		}
		local tlevelreward = {
		-- '4010003' == 1
		}
		local tnextlevelreward = {
		-- '4010003' = 1
		}
		local tHongbao = {
		}
		--
		-- 结算非运气奖励
		-- local tfirstPassReward = {
		-- -- 首通奖励
		-- -- '4020009' = 1
		-- }
		if data and type(data.data) == "table" then
			print('HuoShao')
			DeepPrintTable(data)
			tlevelreward['4020006'] = data.data['herobox'] or 0
			-- 档案经验
			italentaddxp = data.data['talentaddxp'] or 0
			iaddxp = data.data['addxp'] or 0
			ivipaddxp = data.data['vipaddxp'] or 0
			iaddxp = iaddxp + italentaddxp + ivipaddxp
			icmdxp = data.data['cmdxp'] or 0
			-- bp经验
			iaddbpxp = data.data['bpxp'] or 0
			idoublebpxp = data.data['doublebpxp'] or 0
			ivipbpxp = data.data['vipbpxp'] or 0
			iaddbpxp = iaddbpxp + idoublebpxp + ivipbpxp

			-- 结算奖励
			istarstone = data.data['starstone']
			istardust = data.data['stardust']
			-- 红包
			tHongbao = data.data['hongbao']
			print('asdasdasdasd')
			DeepPrintTable(tHongbao)

			-- 上限显示
			-- 结算运气奖励
			if data.data['nextlevelreward'] then
				for sID, iCount in pairs(data.data['nextlevelreward']) do
					if sID then
						tnextlevelreward[sID] = iCount
					end
				end
			end
			if data.data['nianreward'] then
				for sID, iCount in pairs(data.data['nianreward']) do
					if sID and tdropreward[sID] then
						tdropreward[sID] = (tonumber(iCount) + tonumber(tlevelreward[sID]))
					else
						tdropreward[sID] = iCount
					end
				end
			end
			if data.data['dropreward'] then
				for sID, iCount in pairs(data.data['dropreward']) do
					if sID then
						tdropreward[sID] = iCount
					end
				end
			end
			if data.data['levelreward'] then
				for sID, iCount in pairs(data.data['levelreward']) do
					if sID and tlevelreward[sID] then
						tlevelreward[sID] = (tonumber(iCount) + tonumber(tlevelreward[sID]))
					else
						tlevelreward[sID] = iCount
					end
				end
			end
			if data.data['firstpassreward'] then
				for sID, iCount in pairs(data.data['firstpassreward']) do
					if sID and tlevelreward[sID] then
						tlevelreward[sID] = (tonumber(iCount) + tonumber(tlevelreward[sID]))
					else
						tlevelreward[sID] = iCount
					end
					-- tlevelreward[sID] = iCount
				end
			end
			DeepPrintTable(tdropreward)
			DeepPrintTable(tlevelreward)

			sRating = data.data['rating']
			sRating = data.data['rating']
			-- 限制
			if data.data['dayuplimit'] then
				beAddCmdExp =	data.data['dayuplimit'][4]
				beAddherobox = data.data['dayuplimit'][7]
				DeepPrintTable(data.data['dayuplimit'])
			end
		end

		-- 档案等级
		local sInfoLevel = 0
		-- 当前档案升级经验
		local ilevelxp = 0
		-- 当前档案经验
		local ixp = 0
		-- 档案所有经验总和
		local itotalxp = 0

		local tPlayerLevelData = NetEventData:GetTableValue('service', 'player_level_' .. iPlayerID)
		if tPlayerLevelData then
			sInfoLevel = tonumber(tPlayerLevelData['level']) or 0
			ilevelxp = tonumber(tPlayerLevelData['levelxp']) or 0
			ixp = tonumber(tPlayerLevelData['xp']) or 0
			itotalxp = tonumber(tPlayerLevelData['totalxp']) or 0
		end

		-- bp等级
		local ibplevel = 0
		-- bp经验
		local ibpxp = 0
		local tPlayerBPLevelData = NetEventData:GetTableValue('service', 'player_bp_level_' .. iPlayerID)
		if tPlayerBPLevelData then
			ibplevel = tPlayerBPLevelData['level']
			ibpxp = tPlayerBPLevelData['xp']
		end

		self.tPlayerBalanceData[iPlayerID] = {
			sInfoLevel = sInfoLevel,
			sRating = sRating,
			ilevelxp = ilevelxp,
			itotalxp = itotalxp,
			iaddxp = iaddxp,
			iaddbpxp = iaddbpxp,
			ixp = ixp,
			gameresult = gameresult,
			bosskilledtime = self._time,
			iGold = self._iGold or 0,
			damage = self._damage or 0,
			iDeath = self._iDeath or 0,
			ibplevel = ibplevel,
			ibpxp = ibpxp,
			tHongbao = tHongbao,
			-- 经验附加系统
			italentaddxp = italentaddxp,
			ivipaddxp = ivipaddxp,
			ivipbpxp = ivipbpxp,
			idoublebpxp = idoublebpxp,
			tdropreward = tdropreward,
			tlevelreward = tlevelreward,
			tnextlevelreward = tnextlevelreward,
			istarstone = istarstone,
			istardust = istardust,
			icmdxp = icmdxp,
			beAddCmdExp = beAddCmdExp,
			beAddherobox = beAddherobox
		}
		SendGameEvent2Player(iPlayerID, 'show_balance_info', self.tPlayerBalanceData[iPlayerID])

		local allresult = true
		DotaTD:EachPlayer(function(_, iPlayerID)
			if not self.tPlayerBalanceData[iPlayerID] then
				allresult = false
			end
		end)
		if allresult then
			Recorder:GameEnd()
		end
	end)
end
function public:GetGoldRoundData(iRound)
	if 9 <= iRound then
		if 19 <= iRound then
			if 29 <= iRound then
				if 39 <= iRound then
					return 39
				else
					return 29
				end
			else
				return 19
			end
		else
			return 9
		end
	else
		return -1
	end
end
-- local ttData = {
-- 	uid = GetAccountID(0),
-- 	round = 10,
-- 	win = 0,
-- 	diff = 1,
-- 	total_gold = 1,
-- 	total_crystal = 1,
-- 	layer = 0,
-- 	commander = '1030001'
-- }
-- Service:POST('player.game_over', ttData, function(Data)
-- 	print("~~~~~~")
-- 	local asd = tostring(10018)
-- 	local dsa = tostring('rating')
-- 	local sInfoLevel = Data.data[dsa]
-- 	print('sInfoLevel', sInfoLevel)
-- 	DeepPrintTable(Data)
-- 	SendGameEvent2Player(0, 'show_balance_info', {
-- 		sInfoLevel = 1,
-- 		sRating = 'S',
-- 		ilevelxp = 1575,
-- 		itotalxp = 30,
-- 		iaddxp = 100,
-- 		iaddbpxp = 100,
-- 		ixp = 1000,
-- 		gameresult = 0,
-- 		bosskilledtime = 12,
-- 		iGold = 0,
-- 		damage = 0,
-- 		iDeath = 0,
-- 		ibplevel = 5,
-- 		ibpxp = 300,
-- 		italentaddxp = 1,
-- 		ivipaddxp = 1,
-- 		ivipbpxp = 1,
-- 		idoublebpxp = 1,
-- 		tdropreward = {},
-- 		tlevelreward = {},
-- 		tnextlevelreward = {},
-- 		istarstone = 2,
-- 		istardust = 3,
-- 		icmdxp = 4,
-- 	})
-- end)
-- print('commander', Commander:GetChloseCommanderID(0))
-- print(GameRules:GetGameTime())
-- print('999')
-- print(GameRules:GetDOTATime(false, false))
return public