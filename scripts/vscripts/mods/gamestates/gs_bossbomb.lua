if nil == GS_BossBomb then
	---@class GS_BossBomb : State BOSS爆炸
	GS_BossBomb = {
		iDuration = 0,
	}
end
---@type GS_BossBomb
local public = GSManager:LoadState(...)

--进入
function public:start()
	self.iDuration = 5
	EventManager:fireEvent(ET_BATTLE.ON_BOSS_BOMB)
end

--持续
function public:update()
	self.iDuration = self.iDuration - GSManager.iUpdateTime
	if 0 >= self.iDuration then
		GSManager:switch(GS_Battle_EndWait)
	end
end

return public