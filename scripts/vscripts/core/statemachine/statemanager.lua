--状态管理基类
if nil == StateManager then
	local tReqArg = string.split(({ ... })[1], "/")

	---@class StateManager
	StateManager = {
		---状态对象
		m_tStates = nil,
		---当前状态
		m_typeStateCur = nil,
		---上个状态
		m_typeStateLast = nil,


		---状态枚举
		_tStatas = {
			State_None = 0,
			State_End = 1,
		},
		_sReqPath = table.concat(tReqArg, "/", 1, #tReqArg - 1)
	}
	StateManager = class({}, StateManager)
end
---@type StateManager
local public = StateManager
require(public._sReqPath .. "/State")

--初始化
function public:init(bReload)
	if not bReload then
		self.m_tStates = {}
	end

	--加载状态对象
	for sState, typeState in pairs(self._tStatas) do
		local bSuccess, hState = xpcall(function()
			return require(self._sReqPath .. "/" .. sState)
		end, function()
		end)
		if bSuccess then
			self.m_tStates[typeState] = hState
			_G[sState] = typeState
			self:getStateObj(typeState):init(bReload, typeState)
		end
	end
end

--构造函数
function public:constructor()
end

--加载状态管理器
function public:Load(...)
	local tReqArg = string.split(({ ... })[1], "/")
	local sClass = tReqArg[#tReqArg]
	local hManager = _G[sClass]
	if not instanceof(hManager, public) then
		hManager = class({}, hManager, public)
		hManager._sReqPath = table.concat(tReqArg, "/", 1, #tReqArg - 1)
	end
	return hManager
end
--加载状态对象
function public:LoadState(...)
	local arg = { ... }
	local tReqArg = string.split(arg[1], "/")
	local sState = tReqArg[#tReqArg]
	local val = _G[sState]
	local hState, typeState
	if 'table' == type(val) then
		hState = class({}, val, State)
		typeState = self._tStatas[sState]
	else
		typeState = val
		hState = self:getStateObj(typeState)
	end

	local bDynamicLoad = arg[2]
	if nil ~= bDynamicLoad then
		--动态加载时在这里初始化状态对象
		self.m_tStates[typeState] = hState
		_G[sState] = typeState
		hState:init(bDynamicLoad, typeState)
	end

	return hState
end

--状态切换
function public:switch(typeState)
	if typeState == self.m_typeStateCur then
		return
	end

	local oState = self:getStateObj()

	self.m_typeStateLast = self.m_typeStateCur
	self.m_typeStateCur = typeState

	if oState then
		oState:over()
	end
	oState = self:getStateObj()
	if oState then
		oState:start()
	end

	return true
end

--持续触发当前状态
function public:update()
	local oState = self:getStateObj()
	if oState then
		oState:update()
	end
end

--获取状态对象
---@return State
function public:getStateObj(typeState)
	return self.m_tStates[typeState or self:getStateType()]
end

--获取当前状态类型
function public:getStateType()
	return self.m_typeStateCur
end

--获取当前状态名
function public:GetStateName(typeState)
	for k, v in pairs(self._tStatas) do
		if v == typeState then
			return k
		end
	end
end

return public