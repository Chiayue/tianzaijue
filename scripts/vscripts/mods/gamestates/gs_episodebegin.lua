if nil == GS_EpisodeBegin then
	---@class GS_EpisodeBegin : State 章节开始
	GS_EpisodeBegin = {}
end
---@type GS_EpisodeBegin
local public = GSManager:LoadState(...)

--构造函数
function public:init(bReload, typeState, ...)
	self.__base__.init(self, bReload, typeState, ...)
end

--进入当前状态
function public:start()
	print('GS_EpisodeBegin start')

	self.iDuration = 10

	EventManager:fireEvent(ET_GAME.EPISODE_BEGIN, { iDuration = self.iDuration })
end


--持续
function public:update()
	self.iDuration = self.iDuration - GSManager.iUpdateTime
	if 0 >= self.iDuration then
		GSManager:switch(GS_Preparation)
	end
end


return public