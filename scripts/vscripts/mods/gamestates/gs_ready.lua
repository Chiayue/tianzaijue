if nil == GS_Ready then
	---@class GS_Ready : State 游戏准备
	GS_Ready = {}
end
---@type GS_Ready
local public = GSManager:LoadState(...)

--构造函数
function public:init(bReload, typeState, ...)
	self.__base__.init(self, bReload, typeState, ...)
end

--进入当前状态
function public:start()
	--进入游戏地图
	print('GS_Ready start')
	EventManager:fireEvent(ET_GAME.GAME_READY)

	--60秒后结束
	self.iDuration = BORNPLACE_PREPARE_TIME
end

--当前状态的持续
function public:update()

	if TableCount(PlayerData.playerDatas) == 1 then
		self.iDuration = 300
	else
		self.iDuration = self.iDuration - GSManager.iUpdateTime
	end

	if 0 >= self.iDuration then
		--设置难度
		GameMode:SetDifficulty(Birthplace.typeDifficulty)

		-- 请求更换过的商品
		Service:ReqGoodsSet()

		GSManager:switch(GS_Begin)
	end
end

return public