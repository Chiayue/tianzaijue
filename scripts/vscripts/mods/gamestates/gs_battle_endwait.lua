if nil == GS_Battle_EndWait then
	---@class GS_Battle_EndWait : State 战斗阶段结束等待
	GS_Battle_EndWait = {
		iDuration = 0,
	}
end
---@type GS_Battle_EndWait
local public = GSManager:LoadState(...)

--初始化
function public:init(bReload, typeState, ...)
	self.__base__.init(self, bReload, typeState, ...)
end

--进入
function public:start()
	print('GS_Battle_EndWait start')

	self.iDuration = 10
	local tRoundData = Spawner:GetRoundData(Spawner:GetRound())
	if tRoundData then
		self.iDuration = tRoundData.BattleEndTime
	end

	EventManager:fireEvent(ET_BATTLE.ON_BATTLEING_ENDWAIT_START)
end

--持续
function public:update()
	self.iDuration = self.iDuration - GSManager.iUpdateTime
	if 0 >= self.iDuration then


		-- 验证活动关卡
		local function hasActivityRound()
			-- 年兽挑战
			if not Spawner.bNianRound and 1 ~= GameMode:GetDifficulty() then
				local tNianDate = NetEventData:GetTableValue('service', 'info_nian_time')
				-- if tNianDate and 1 == tNianDate['active'] then
				if tNianDate then
					local tInfoDifficulty = NetEventData:GetTableValue('service', 'info_difficulty')
					if tInfoDifficulty then
						tInfoDifficulty = tInfoDifficulty[tostring(GameMode:GetDifficulty())]
						if tInfoDifficulty['nian'] and RollPercentage(100 * tInfoDifficulty['nian']) then
							-- 触发
							Spawner.bNianRound = true
							return true
						end
					end
				end
			end
		end

		local function checkOverRound(iRound)
			-- 当前是否达到配置的最后一关
			if DIFFICULTY_INFO and DIFFICULTY_INFO[GameMode:GetDifficulty()] then
				local iOverRound = tonumber(DIFFICULTY_INFO[GameMode:GetDifficulty()].game_over_round)
				if iOverRound and iRound >= iOverRound then
					if hasActivityRound() then
						return false
					end
					return true
				end
			end
			--是否有下一关
			local tRoundData = Spawner:GetRoundData(iRound + 1)
			if not tRoundData then
				-- 没有下一关游戏结束
				if hasActivityRound() then
					return false
				end
				return true
			end
			-- 如果人死光了
			if PlayerData:GetAlivePlayerCount() <= 0 then
				return true
			end
		end

		if checkOverRound(Spawner:GetRound()) then
			GSManager:switch(GS_Balance)
			return
		end

		if Spawner:IsBossRound() then
			-- 当前是BOSS关结束，进入下一个章节
			if Spawner.bNianRound then
				GSManager:switch(GS_Preparation)
			else
				GSManager:switch(GS_EpisodeBegin)
			end
		else
			if _G.PASSBOSS and Spawner:IsBossRound(Spawner:GetRound() + 1) then
				-- 跳过BOSS关
				if checkOverRound(Spawner:GetRound() + 1) then
					-- 下关游戏结束
					GSManager:switch(GS_Balance)
					return
				else
					Spawner:SetRound(Spawner:GetRound() + 1)
				end
			end
			GSManager:switch(GS_Preparation)
		end
	end
end

--结束
function public:over()
	print('GS_Battle_EndWait over')
	EventManager:fireEvent(ET_BATTLE.ON_BATTLEING_ENDWAIT_END)
end

--事件监听************************************************************************************************************************
	do
end
--事件监听************************************************************************************************************************
return public