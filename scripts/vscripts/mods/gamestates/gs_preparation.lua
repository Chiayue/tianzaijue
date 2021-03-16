if nil == GS_Preparation then
	---@class GS_Preparation : State 备战阶段
	GS_Preparation = {
		iDuration = 0,
		tPlayerReady = {},
	}
end
---@type GS_Preparation
local public = GSManager:LoadState(...)

--构造函数
function public:init(bReload, typeState, ...)
	self.__base__.init(self, bReload, typeState, ...)

	CustomUIEvent("RoundReady", Dynamic_Wrap(public, "OnRoundReady"), public)
end

function public:UpdateNettable()
	CustomNetTables:SetTableValue("common", "round_player_ready", self.tPlayerReady)
end

--进入当前状态
function public:start()
	print('GS_Preparation start')
	--通知进入备战状态
	EventManager:fireEvent(ET_BATTLE.ON_PREPARATION)

	--持续时间
	local tRoundData = Spawner:GetRoundData(Spawner:GetRound())
	if tRoundData then
		self.iDuration = tRoundData.PreparationTime
	end

	self.tPlayerReady = {}
	DotaTD:EachPlayer(function(_, iPlayerID)
		if not PlayerData:IsPlayerDeath(iPlayerID) then
			self.tPlayerReady[iPlayerID] = false
		end
	end)
	self:UpdateNettable()
end

--当前状态的持续
function public:update()
	self.iDuration = self.iDuration - GSManager.iUpdateTime

	--首回合开战音效
	if 1 == Spawner:GetRound() and self.iDuration == 10 then
		EmitGlobalSound("Round.FirstWave")
	end

	if 0 >= self.iDuration then
		GSManager:switch(GS_Battle)
	end
end

--结束
function public:over()
	--通知结束战斗
	EventManager:fireEvent(ET_BATTLE.ON_PREPARATION_END)
end


--玩家准备
function public:OnRoundReady(_, tData)
	if GSManager:getStateType() ~= GS_Preparation then return end
	if self.tPlayerReady[tData.PlayerID] then return end
	if PlayerData:IsPlayerDeath(tData.PlayerID) then return end

	local iWait = 0
	for k, v in pairs(self.tPlayerReady) do
		if not v then
			iWait = 1 + iWait
		end
	end
	self.tPlayerReady[tData.PlayerID] = true
	self.iDuration = self.iDuration * (1 - 1 / iWait)
	self:UpdateNettable()
	Spawner.fRoundTime = GameRules:GetGameTime() + self.iDuration
	Spawner:UpdateNetTables()
end

return public