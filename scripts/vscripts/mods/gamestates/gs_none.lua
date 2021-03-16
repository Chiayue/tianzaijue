if nil == GS_None then
	---@class GS_None : State
	GS_None = {}
end
---@type GS_None
local public = GSManager:LoadState(...)

--初始化
function public:init(bReload, typeState, ...)
	self.__base__.init(self, bReload, typeState, ...)

	GameEvent("game_rules_state_change", Dynamic_Wrap(self, "OnGameRulesStateChange"), self)
end

--进入当前状态
function public:start()
	print('GS_None start')
end

--当前状态的持续
function public:update()
end

--DOTA状态改变
function public:OnGameRulesStateChange()
	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		GameMode:InitActiveInfo()
	end

	-- 选择英雄
	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- EventManager:fireEvent(ET_PLAYER.ALL_LOADED_FINISHED)
		DotaTD:EachPlayer(function(n, iPlayerID)
			EventManager:fireEvent(ET_PLAYER.ON_LOADED_FINISHED, { PlayerID = iPlayerID })
		end)
	end

	-- 策略时间
	if state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
	end

	-- 准备阶段
	if state == DOTA_GAMERULES_STATE_PRE_GAME then
		--进入地图，游戏开始
		GSManager:switch(GS_Ready)
	end

	-- 游戏开始
	if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	end
end

return public