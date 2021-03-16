if EModifier == nil then
	---@class EModifier
	EModifier = {
		--emdf事件
		tModifierEvents = {},
		--全部修改器
		tModifier = {},
	}
end

--- 注册EomModifier事件监听
function EModifier:RegEvt(sEvtName, hSource, func)
	self.tModifierEvents[sEvtName] = self.tModifierEvents[sEvtName] or {}
	local tModify = self.tModifierEvents[sEvtName]
	if tModify[hSource] ~= func then
		tModify[hSource] = func
	end
end
--- 通知EomModifier事件
function EModifier:NotifyEvt(sEvtName, ...)
	local tModify = shallowcopy(self.tModifierEvents[sEvtName])
	if tModify then
		if E_DECLARE_FUNCTION[sEvtName].funcNotifyEvt then
			return E_DECLARE_FUNCTION[sEvtName].funcNotifyEvt(tModify, ...)
		end
		for hSource, func in pairs(tModify) do
			if IsValid(hSource) and func then
				xpcall(function(...)
					func(hSource, ...)
				end, debug.traceback, ...)
			end
		end
	end
end
--- 自定义事件监听
function EModifier:RegCustomEvt(hSource, typeEvent, func, iLevel) end
function EModifier:UnRegCustomEvt(hSource, typeEvent, func_name) end
if IsServer() then
	function EModifier:RegCustomEvt(hSource, typeEvent, func, iLevel)
		EventManager:register(typeEvent, func, hSource, iLevel)
	end
	function EModifier:UnRegCustomEvt(hSource, typeEvent, func_name)
		EventManager:unregister(typeEvent, func_name, hSource)
	end
end

--- 注册属性修改
function EModifier:RegAttribute(tData, hSource, val, ...)
	if tData.RegAttribute then
		tData.RegAttribute(tData, hSource, val, ...)
	else
		local hParent = hSource:GetParent()
		if hParent.SetVal then
			hParent:SetVal(tData.attribute_kind, val, hSource, tData.attribute_flags, ...)
		end
	end
end
--- 注册属性百分比修改
function EModifier:RegAttributePct(tData, hSource, val, ...)
	if tData.RegAttributePct then
		tData.RegAttributePct(tData, hSource, val, ...)
	else
		local hParent = hSource:GetParent()
		if hParent.SetValPercent then
			hParent:SetValPercent(tData.attribute_kind, val, hSource, tData.attribute_flags, ...)
		end
	end
end
function EModifier.RegAttribute_LevelVal(tData, hSource, val, iLevel)
	local hParent = hSource:GetParent()
	if hParent.SetVal then
		hParent:SetVal(tData.attribute_kind, val, hSource, iLevel, tData.attribute_flags)
	end
end
function EModifier.RegAttributePct_LevelVal(tData, hSource, val, iLevel)
	local hParent = hSource:GetParent()
	if hParent.SetValPercent then
		hParent:SetValPercent(tData.attribute_kind, val, hSource, iLevel, tData.attribute_flags)
	end
end

function EModifier:RegOriginEvt(sEvtName, hSource, params)
	if params then
		AddModifierEvents(sEvtName, hSource, params[1], params[2])
	else
		AddModifierEvents(sEvtName, hSource)
	end
end
function EModifier:UnRegOriginEvt(sEvtName, hSource, params)
	if params then
		RemoveModifierEvents(sEvtName, hSource, params[1], params[2])
	else
		RemoveModifierEvents(sEvtName, hSource)
	end
end

--- 拆解参数 如参数是带key时：{b=2,a=1}，EModifier:unpacker('a','b')表示a，b分别是参数1，2
function EModifier:unpacker(...)
	local tK = { ... }
	return function(parmas)
		if 0 < #parmas then return _G.unpack(parmas) end
		local tV = {}
		for _, s in ipairs(tK) do
			table.insert(tV, parmas[s])
		end
		return _G.unpack(tV)
	end
end
function EModifier:unpack(parmas, unpack)
	if unpack then
		return unpack(parmas)
	end
	return _G.unpack(parmas)
end

--- 创建一组修改器
---@param sMdf 修改名
---@param funcReg 注册时回调 funcReg()
---@return function 返回获取所有修改值的函数 (...)=>{k1:[v1,v2,...],...}
function EModifier:CreateModifier(sMdf, funcReg)
	local tModifier = {
		-- 注册的修改数据
		tData = {},
	}
	self.tModifier[sMdf] = tModifier
	-- 注册函数
	tModifier.funcReg = function(key, val, ...)
		if tModifier.tData[key] ~= val then
			tModifier.tData[key] = val
		end
		if funcReg then
			funcReg(key, val, ...)
		end
	end
	-- 获取修改后值
	tModifier.funcGet = function(...)
		local tResults = {}
		for key, val in pairs(tModifier.tData) do
			if type(val) == 'function' then
				local func
				if type(key) == 'table' then
					func = function(...) return val(key, ...) end
				else
					func = function(...) return val(...) end
				end
				local t = { xpcall(func, debug.traceback, ...) }
				if true == t[1] then
					table.remove(t, 1)
					tResults[key] = t
				end
			else
				tResults[key] = { val }
			end
		end
		return tResults
	end

	return tModifier.funcGet
end
function EModifier:HasModifier(sMdf)
	return nil ~= self.tModifier[sMdf]
end
function EModifier:RegModifierKeyVal(sMdf, key, val, ...)
	local tModifier = self.tModifier[sMdf]
	if tModifier then
		tModifier.funcReg(key, val, ...)
	end
end
function EModifier:GetModifierVals(sMdf, ...)
	local tModifier = self.tModifier[sMdf]
	if tModifier then
		return tModifier.funcGet(...)
	end
	return {}
end

----------------------------------------------------------------------------------------------------
-- eom_modifier
--[[eom_modifier 继承需要调用：
	重写 EDeclareFunctions() 方法
	使用上面 E_DECLARE_FUNCTION 中定义的方法

	新增接口：
	GetPlayerID()
]]
if eom_modifier == nil then
	---@class eom_modifier
	eom_modifier = class({}, nil, BaseModifier)
	eom_modifier.constructor = function(self)
		if type(self.OnCreated) == "function" then
			if self.OnCreated ~= eom_modifier.OnCreated then
				local _OnCreated = self.OnCreated
				self.OnCreated = function(...)
					local result = _OnCreated(...)
					eom_modifier.OnCreated(...)
					return result
				end
			end
		else
			self.OnCreated = eom_modifier.OnCreated
		end

		if type(self.OnRefresh) == "function" then
			if self.OnRefresh ~= eom_modifier.OnRefresh then
				local _OnRefresh = self.OnRefresh
				self.OnRefresh = function(...)
					local result = _OnRefresh(...)
					eom_modifier.OnRefresh(...)
					return result
				end
			end
		else
			self.OnRefresh = eom_modifier.OnRefresh
		end

		if type(self.OnDestroy) == "function" then
			if self.OnDestroy ~= eom_modifier.OnDestroy then
				local _OnDestroy = self.OnDestroy
				self.OnDestroy = function(...)
					local result = _OnDestroy(...)
					eom_modifier.OnDestroy(...)
					return result
				end
			end
		else
			self.OnDestroy = eom_modifier.OnDestroy
		end
	end

	eom_modifier_class = {}
	local mt = {}
	mt.__call = function(_, ...)
		local c = class(...)
		c.constructor = eom_modifier.constructor
		for _, k in pairs({
			'RegDeclareFunctions',
			'EDeclareFunctions',
			'RegCheckState',
			'ECheckState',
			'GetPlayerID',
		}) do
			if nil == c[k] then
				c[k] = eom_modifier[k]
			end
		end
		return c
	end
	setmetatable(eom_modifier_class, mt)
end
local public = eom_modifier

--[[ 无参数写法示例：
	return {
		EMDF_MOVEMENT_SPEED_BONUS,
		MODIFIER_EVENT_ON_ATTACK
	}
	带参数写法示例：
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { hSource, hTarget }
	}
	可以两种相结合使用
]]
function public:EDeclareFunctions(bUnregister)
	return {}
end
function public:ECheckState(bUnregister)
	return {}
end
function public:GetPlayerID()
	if not self.e_playerid then
		self.e_playerid = GetPlayerID(self:GetParent())
	end
	return self.e_playerid
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	self:GetPlayerID()
	if not self.bDestroy then
		self:RegDeclareFunctions(true)
		self:RegCheckState(true)
	end
end
function public:OnRefresh(params)
	local hParent = self:GetParent()
	if not self.bDestroy then
		self:RegDeclareFunctions()
		self:RegCheckState()
	end
end
function public:OnDestroy()
	self.bDestroy = true
	local tDeclareFunction = self:EDeclareFunctions(true)

	--无参
	for _, key in ipairs(tDeclareFunction) do
		local hSource = self
		local func = self[key]
		local t = E_DECLARE_FUNCTION[key]
		if t ~= nil then
			-- 外部修改器
			if t == 1 then
				EModifier:UnRegOriginEvt(key, hSource)
			elseif t.source == nil then
				if t.evt == true then
					EModifier:RegEvt(key, hSource, nil)
				elseif t.evt == "attribute_const" then
					EModifier:RegAttribute(t, hSource, nil)
				elseif t.evt == "attribute_pct" then
					EModifier:RegAttributePct(t, hSource, nil)
				end
			else
				local handel = _G[t.source]
				if handel and handel[key] then
					handel[key](handel, hSource, nil)
				end
			end
		else
			-- 内部修改器
			EModifier:RegModifierKeyVal(key, hSource, nil)
		end
	end

	--带参
	for key, params in pairs(tDeclareFunction) do
		local sPT = type(params)
		local hSource = self
		local t = E_DECLARE_FUNCTION[key]
		if 'table' == type(params) then
			local func = self[key]
			if t ~= nil then
				-- 外部修改器
				if t == 1 then
					EModifier:UnRegOriginEvt(key, hSource, params)
				elseif t.source == nil then
					if t.evt == 'custom_event' then
						if type(params[1]) == 'table' then
							for _, params2 in ipairs(params) do
								EModifier:UnRegCustomEvt(hSource, EModifier:unpack(params2, t.unpack))
							end
						else
							EModifier:UnRegCustomEvt(hSource, EModifier:unpack(params, t.unpack))
						end
					elseif t.evt == "attribute_const" then
						EModifier:RegAttribute(t, hSource, nil)
					elseif t.evt == "attribute_pct" then
						EModifier:RegAttributePct(t, hSource, nil)
					end
				else
					local handel = _G[t.source]
					if handel and handel[key] then
						handel[key](handel, hSource, nil)
					end
				end
			else
				-- 内部修改器
				EModifier:RegModifierKeyVal(key, hSource, nil, EModifier:unpack(params))
			end
		elseif 'number' == sPT then
			if t ~= nil and t.source == nil then
				if t.evt == "attribute_const" then
					EModifier:RegAttribute(t, hSource, nil)
				elseif t.evt == "attribute_pct" then
					EModifier:RegAttributePct(t, hSource, nil)
				end
			end
		end
	end

	local tCheckState = self:ECheckState()
	local hParent = self:GetParent()
	for key, bEnable in pairs(tCheckState) do
		if hParent["_AttributeSystem_State_" .. key] ~= nil then
			ArrayRemove(hParent["_AttributeSystem_State_" .. key], self)
		end
	end
end
function public:RegDeclareFunctions(bCreated)
	local tDeclareFunction = self:EDeclareFunctions()
	--无参
	for _, key in ipairs(tDeclareFunction) do
		local hSource = self
		local func = self[key]
		local t = E_DECLARE_FUNCTION[key]
		if t ~= nil then
			-- 外部修改器
			if t == 1 then
				if bCreated then
					EModifier:RegOriginEvt(key, hSource)
				end
			elseif t.source == nil then
				if t.evt == true then
					EModifier:RegEvt(key, hSource, func)
				elseif t.evt == "attribute_const" then
					EModifier:RegAttribute(t, hSource, func)
				elseif t.evt == "attribute_pct" then
					EModifier:RegAttributePct(t, hSource, func)
				end
			else
				local handel = _G[t.source]
				if handel and handel[key] then
					handel[key](handel, hSource, func)
				end
			end
		else
			-- 内部修改器
			EModifier:RegModifierKeyVal(key, hSource, func)
		end
	end

	--带参
	for key, params in pairs(tDeclareFunction) do
		local sPT = type(params)
		local hSource = self
		local t = E_DECLARE_FUNCTION[key]
		if 'table' == sPT then
			local func = self[key]
			if t ~= nil then
				-- 外部修改器
				if t == 1 then
					if bCreated then
						EModifier:RegOriginEvt(key, hSource, params)
					end
				elseif t.source == nil then
					if t.evt == 'custom_event' then
						if type(params[1]) == 'table' then
							for _, params2 in ipairs(params) do
								EModifier:RegCustomEvt(hSource, EModifier:unpack(params2, t.unpack))
							end
						else
							EModifier:RegCustomEvt(hSource, EModifier:unpack(params, t.unpack))
						end
					elseif t.evt == "attribute_const" then
						EModifier:RegAttribute(t, hSource, func, EModifier:unpack(params, t.unpack))
					elseif t.evt == "attribute_pct" then
						EModifier:RegAttributePct(t, hSource, func, EModifier:unpack(params, t.unpack))
					end
				else
					local handel = _G[t.source]
					if handel and handel[key] then
						handel[key](handel, hSource, func)
					end
				end
			else
				-- 内部修改器
				EModifier:RegModifierKeyVal(key, hSource, func, EModifier:unpack(params))
			end
		elseif 'number' == sPT then
			if t ~= nil and t.source == nil then
				if t.evt == "attribute_const" then
					EModifier:RegAttribute(t, hSource, params)
				elseif t.evt == "attribute_pct" then
					EModifier:RegAttributePct(t, hSource, params)
				end
			end
		end
	end
end
function public:RegCheckState(bCreated)
	local tCheckState = self:ECheckState()
	for key, bEnable in pairs(tCheckState) do
		if bEnable == true and bCreated then
			local hParent = self:GetParent()
			if hParent["_AttributeSystem_State_" .. key] == nil then
				hParent["_AttributeSystem_State_" .. key] = {}
			end
			table.insert(hParent["_AttributeSystem_State_" .. key], self)
		end
	end
end

require("modifiers/EomMdf/emdf_cfg")