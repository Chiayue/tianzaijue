--状态基类
if nil == State or 'table' ~= type(State) then
    ---@class State
    State = {
        m_typeState = nil, --状态类型
    }
    State = class({}, State)
end
---@type State
local public = State	-- 子类加载 StateManager:LoadState(...)

function public:init(bReload, typeState, ...)
    -- self.__base__.init(self, bReload, typeState, ...)
    self.m_typeState = typeState
end

function public:getType()
    return self.m_typeState
end

--进入当前状态
function public:start()
end
--当前状态的持续
function public:update()
end
--结束当前状态
function public:over()
end

return public