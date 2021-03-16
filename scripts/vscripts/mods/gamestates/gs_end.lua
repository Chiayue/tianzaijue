if nil == GS_End then
	---@class GS_End : State
	GS_End = {}
end
---@type GS_End
local public = GSManager:LoadState(...)

function public:init(bReload, typeState, ...)
	self.__base__.init(self, bReload, typeState, ...)

	-- EventManager:register(ET_PLAYER.ON_DEATH, 'OnPlayerDeath', self, -EVENT_LEVEL_ULTRA)
end
--进入当前状态
function public:start()
	EventManager:fireEvent(ET_GAME.GAME_END)
end

--当前状态的持续
function public:update()
end

return public