--游戏状态管理
if nil == GSManager then
	---@class GSManager:StateManager
	GSManager = {
		iUpdateTime = 0.1, --update间隔时间
		_tStatas = {
			GS_None = 0,
			GS_Ready = 5, --游戏准备
			GS_Begin = 10, --游戏开始
			GS_EpisodeBegin = 15, --章节开始
			GS_Preparation = 20, --备战阶段
			GS_Battle = 30, --战斗阶段
			GS_BossBomb = 35, --Boss爆炸
			GS_Battle_EndWait = 40, --战斗结束等待阶段
			GS_Balance = 50, -- 结算界面
			GS_End = 100, --真正游戏结束
		}
	}
end
GSManager = StateManager:Load(...)
---@type GSManager
local public = GSManager

--初始化
function public:init(bReload)
	self.__base__.init(self, bReload)

	if not bReload then
		self:switch(GS_None)
		GameRules:GetGameModeEntity():GameTimer(self.iUpdateTime, self.update)
	end
end

function public:update()
	public.__base__.update(public)
	return public.iUpdateTime
end

--状态切换
function public:switch(typeState)
	if self.__base__.switch(self, typeState) then
		self:UpdateNetTable()
		return true
	end
end

function public:UpdateNetTable()
	local tData = {
		state_cur = self:GetStateName(self.m_typeStateCur),
		state_last = self:GetStateName(self.m_typeStateLast),
	}
	local hState = self:getStateObj(self.m_typeStateCur)
	if hState and hState.iDuration and 0 < hState.iDuration then
		tData.time_end = GameRules:GetGameTime() + hState.iDuration
	end
	CustomNetTables:SetTableValue("common", "game_state", tData)
end

return public