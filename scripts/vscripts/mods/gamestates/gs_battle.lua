if nil == GS_Battle then
	---@class GS_Battle : State 战斗阶段
	GS_Battle = {
		iDuration = 0,
	}
end
---@type GS_Battle
local public = GSManager:LoadState(...)

--初始化
function public:init(bReload, typeState, ...)
	self.__base__.init(self, bReload, typeState, ...)

	EventManager:register(ET_PLAYER.ROUND_RESULT, 'OnPlayerEvent_RoundResult', self)
end

--进入
function public:start()
	print('GS_Battle start')

	EmitGlobalSound("Round.WaveStart")
	--通知进入战斗状态
	EventManager:fireEvent(ET_BATTLE.ON_BATTLEING)

	--持续时间
	self.iDuration = Spawner:GetRoundBattleTime()
end

--持续
function public:update()
	self.iDuration = self.iDuration - GSManager.iUpdateTime
	-- print('GS_Battle update='..self.iDuration)
	if 0 >= self.iDuration then
		--是否有下一关
		self:SwithNextState()
	end
end

--结束
function public:over()
	print('GS_Battle over')

	--通知结束战斗
	EventManager:fireEvent(ET_BATTLE.ON_BATTLEING_END)
end

--事件监听************************************************************************************************************************
	do
	--玩家回合结果通知
	function public:OnPlayerEvent_RoundResult(tEvent)
		local bOver = true
		DotaTD:EachPlayer(function(_, iPlayerID)
			if PlayerData:IsPlayerDeath(iPlayerID) then return end
			if not PlayerData:GetPlayerRoundResult(iPlayerID, Spawner:GetRound()) then
				bOver = false
			end
		end)
		if bOver then
			self:SwithNextState()
		end
	end
end
--事件监听************************************************************************************************************************
--切换下一个状态
function public:SwithNextState()
	if GSManager:getStateType() ~= self:getType() then
		return
	end

	if Spawner:IsBossRound() then
		--boss战等待boss自爆
		local bWin = true
		DotaTD:EachPlayer(function(_, iPlayerID)
			if not PlayerData:IsPlayerDeath(iPlayerID) then
				if 1 ~= PlayerData:GetPlayerRoundResult(iPlayerID, Spawner:GetRound()) then
					-- 没淘汰的玩家失败
					bWin = false
					return true
				end
			end
		end)
		if bWin then
			GSManager:switch(GS_Battle_EndWait)
		else
			GSManager:switch(GS_BossBomb)
		end
	else
		GSManager:switch(GS_Battle_EndWait)
	end
end

return public