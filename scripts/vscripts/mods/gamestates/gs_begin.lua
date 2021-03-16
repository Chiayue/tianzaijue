if nil == GS_Begin then
	---@class GS_Begin : State 游戏开始
	GS_Begin = {}
end
---@type GS_Begin
local public = GSManager:LoadState(...)

--构造函数
function public:init(bReload, typeState, ...)
	self.__base__.init(self, bReload, typeState, ...)
end

--进入当前状态
function public:start()
	--进入游戏地图
	print('GS_Begin start')
	EventManager:fireEvent(ET_GAME.GAME_BEGIN)
	--首章节开始
	GSManager:switch(GS_EpisodeBegin)
end

return public