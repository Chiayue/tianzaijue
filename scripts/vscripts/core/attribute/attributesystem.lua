if IsClient() then
	DAMAGE_TYPE_ALL = 7
	DAMAGE_TYPE_HP_REMOVAL = 8
	DAMAGE_TYPE_MAGICAL = 2
	DAMAGE_TYPE_NONE = 0
	DAMAGE_TYPE_PHYSICAL = 1
	DAMAGE_TYPE_PURE = 4
end

---自定义属性
ATTRIBUTE_KIND = {}

---原生Key
ATTRIBUTE_KEY = {
	BASE = 'base', --基础属性
}

---属性标签
ATTRIBUTE_FLAG = {
	NONE = 1,
	UNIQUE = 2, --独立（ 不被百分比修改 ）
	OVERRIDE = 4, --覆盖（ 值取最后添加的OVERRIDE的常量和百分比值，不会叠加其他flag的数值）
}
---取值默认值
ATTRIBUTE_FLAG.DEFAULT = ATTRIBUTE_FLAG.NONE + ATTRIBUTE_FLAG.UNIQUE

---需要同步属性
ATTRIBUTE_SYNC = {}

---读取配置
require('core/Attribute/AttributeCfg')
ATTRIBUTE_FLAG.ALL = (function() local i = 0 for _, v in pairs(ATTRIBUTE_FLAG) do i = i + v end return i end)()

---投射物类型
PROJECTILE_TYPE = {
	Tracking = 1,
	Linear = 2,
}
---攻击行为 优先级排布
ATTACK_PROJECTILE_LEVEL = {
	NONE = 0, --最低
	LOW = 10000,
	MEDIUM = 20000,
	HIGH = 30000,
	ULTRA = 40000, --最高
}

--操作单位属性
-- 用于插件跳转
---@type CDOTA_BaseNPC
local DOTA_BaseNPC = IsServer() and CDOTA_BaseNPC or C_DOTA_BaseNPC
function DOTA_BaseNPC:SetVal(type, ...)
	return AttributeSystem[type]:SetVal(self, ...)
end
function DOTA_BaseNPC:GetVal(type, ...)
	return AttributeSystem[type]:GetVal(self, ...)
end
function DOTA_BaseNPC:GetValConst(type, ...)
	return AttributeSystem[type]:GetValConst(self, ...)
end
function DOTA_BaseNPC:SetValPercent(type, ...)
	return AttributeSystem[type]:SetValPercent(self, ...)
end
function DOTA_BaseNPC:GetValPercent(type, ...)
	return AttributeSystem[type]:GetValPercent(self, ...)
end
function DOTA_BaseNPC:GetValByKey(type, key, ...)
	return AttributeSystem[type]:GetValByKey(self, key, ...)
end
function DOTA_BaseNPC:GetValConstByKey(type, key, ...)
	return AttributeSystem[type]:GetValConstByKey(self, key, ...)
end
function DOTA_BaseNPC:GetValPercentByKey(type, key, ...)
	return AttributeSystem[type]:GetValPercentByKey(self, key, ...)
end
function DOTA_BaseNPC:GetDataVal(type, key)
	local t = AttributeSystem[type]:GetData(self)
	if t then
		t = t[key]
		return t and t.val
	end
end
function DOTA_BaseNPC:GetPercentDataVal(type, key)
	local t = AttributeSystem[type]:GetData(self, 'Percent_' .. self.type)
	if t then
		t = t[key]
		return t and t.val
	end
end

if nil == AttributeSystem then
	---@class AttributeSystem
	AttributeSystem = {
		type = nil,

		iAttackRecordLast = 0,
		iAttackRecordOrder = 1,
		---@type AttackInfo[] (攻击record,params)
		tAttackInfos = {},

		---需要更新client的属性任务队列
		tUpdateTaskList = {}
	}
	AttributeSystem = class({}, AttributeSystem)

	---@class DamageData
	DamageData = {
		victim = nil,
		attacker = nil,
		ability = nil,
		damage = nil,
		damage_base = nil,
		damage_type = nil,
		damage_flags = nil,
	}
	---@class AttackInfo
	AttackInfo = {
		---@type DamageData[]
		tDamageInfo				= nil,
		tDamageRecords			= nil,
		typeProjectile			= nil,
		tProjectileInfo			= nil,
		---当前record处于第几周期
		record_order			= nil,
		record_base				= nil,

		attacker				= nil,
		record					= nil,
		process_procs			= nil,
		stout_tested			= nil,
		damage_category			= nil,
		heart_regen_applied		= nil,
		ranged_attack			= nil,
		do_not_consume			= nil,
		damage_type				= nil,
		damage_flags			= nil,
		original_damage			= nil,
		basher_tested			= nil,
		new_pos					= nil,
		order_type				= nil,
		octarine_tested			= nil,
		issuer_player_index		= nil,
		fail_type				= nil,
		reincarnate				= nil,
		ability_special_level	= nil,
		damage					= nil,
		ignore_invis			= nil,
		locket_amp_applied		= nil,
		diffusal_applied		= nil,
		target					= nil,
		no_attack_cooldown		= nil,
		gain					= nil,
		cost					= nil,
		distance				= nil,
		mkb_tested				= nil,
		sange_amp_applied		= nil,
		activity				= nil,
	}
end
for k, v in pairs(ATTRIBUTE_KIND) do
	if nil == AttributeSystem[v] then
		AttributeSystem[v] = class({}, nil, AttributeSystem)
		AttributeSystem[v].type = v
	end
end

---@type AttributeSystem
local public = AttributeSystem

function public:init(bReload)
end

function public:GetData(hUnit, sType)
	local sDataKey = '_AttributeSystem_' .. (sType or self.type)
	local t = hUnit[sDataKey]
	if t == nil then t = {} hUnit[sDataKey] = t end
	return t
end
function public:GetVal(hUnit, ...)
	-- 绝对优先去覆盖flag的值
	local iVal = self:GetValConst(hUnit, ATTRIBUTE_FLAG.OVERRIDE, ...)
	if iVal then
		local fValPer = self:GetValPercent(hUnit, ATTRIBUTE_FLAG.OVERRIDE, ...)
		return iVal * fValPer
	end

	local iVal = self:GetValConst(hUnit, ATTRIBUTE_FLAG.NONE, ...)
	local fValPer = self:GetValPercent(hUnit, ATTRIBUTE_FLAG.NONE, ...)
	local iStatic = self:GetValConst(hUnit, ATTRIBUTE_FLAG.UNIQUE, ...)
	local fStaticPer = self:GetValPercent(hUnit, ATTRIBUTE_FLAG.UNIQUE, ...)
	return iVal * fValPer + iStatic * fStaticPer
end
function public:UpdatVal(hUnit) end

function public:SetVal(hUnit, fValue, key, flags, ...)
	self:_checkVal(fValue, key, ...)
	local t = self:GetData(hUnit)
	if not key then
		key = DoUniqueString(self.type)
	end

	if self:_UseFixedness() then
		local tLast = t[key]
		if tLast then
			if 'number' == type(tLast.val) and tLast.flags ~= ATTRIBUTE_FLAG.OVERRIDE then
				-- 是固定值移除上次数值
				self:_fixednessVal(hUnit, -tLast.val, tLast.flags)
			end
		end
	end

	if fValue == nil then
		t[key] = nil
	else
		local tV = {
			val = fValue,
			flags = flags or ATTRIBUTE_FLAG.NONE,
		}
		if tV.flags == ATTRIBUTE_FLAG.OVERRIDE then
			tV.set_time = GameRules:GetGameTime()
		else
			if self:_UseFixedness() and 'number' == type(fValue) then
				-- 是固定值提前计算
				self:_fixednessVal(hUnit, fValue, tV.flags)
			end
		end
		t[key] = tV
	end
	self:UpdatVal(hUnit)
	return key
end
function public:GetValConst(hUnit, flags, ...)
	local t = self:GetData(hUnit)
	if nil == flags then
		flags = ATTRIBUTE_FLAG.DEFAULT
	end

	local fValue = 0

	if ATTRIBUTE_FLAG.OVERRIDE == flags then
		local fValue2
		local fTimeMax
		for key, tV in pairs(t) do
			if tV.flags == flags then
				local val = self:_val(key, tV.val, ...)
				if val then
					if not fTimeMax or tV.set_time < fTimeMax then
						fTimeMax = tV.set_time
						fValue2 = self:_count(fValue, val, key)
					end
				end
			end
		end
		return fValue2
	end

	if 0 < bit.band(ATTRIBUTE_FLAG.NONE, flags) then
		fValue = self:_UseFixedness() and self:_fixednessVal(hUnit, nil, ATTRIBUTE_FLAG.NONE) or self:_base(hUnit)
	end
	if self:_UseFixedness() and 0 < bit.band(ATTRIBUTE_FLAG.UNIQUE, flags) then
		local f = self:_fixednessVal(hUnit, nil, ATTRIBUTE_FLAG.UNIQUE)
		if f then
			fValue = self:_count(fValue, f)
		end
	end
	for key, tV in pairs(t) do
		if (not self:_UseFixedness() or 'number' ~= type(tV.val)) and 0 < bit.band(tV.flags, flags) then
			local val = self:_val(key, tV.val, ...)
			if val then
				fValue = self:_count(fValue, val, key)
			end
		end
	end

	return fValue
end
function public:SetValPercent(hUnit, fValue, key, flags, ...)
	self:_checkVal(fValue, key, ...)
	local t = self:GetData(hUnit, 'Percent_' .. self.type)
	if not key then
		key = DoUniqueString('Percent_' .. self.type)
	end

	if self:_UseFixedness() then
		local tLast = t[key]
		if tLast then
			if 'number' == type(tLast.val) and tLast.flags ~= ATTRIBUTE_FLAG.OVERRIDE then
				-- 是固定值移除上次数值
				self:_fixednessPctVal(hUnit, -tLast.val, tLast.flags)
			end
		end
	end

	if fValue == nil then
		t[key] = nil
	else
		local tV = {
			val = fValue,
			flags = flags or ATTRIBUTE_FLAG.NONE,
		}
		if tV.flags == ATTRIBUTE_FLAG.OVERRIDE then
			tV.set_time = GameRules:GetGameTime()
		else
			if self:_UseFixedness() and 'number' == type(fValue) then
				-- 是固定值提前计算
				self:_fixednessPctVal(hUnit, fValue, tV.flags)
			end
		end
		t[key] = tV
	end
	self:UpdatVal(hUnit)
	return key
end
function public:GetValPercent(hUnit, flags, ...)
	local t = self:GetData(hUnit, 'Percent_' .. self.type)

	if nil == flags or 0 >= flags then
		flags = ATTRIBUTE_FLAG.DEFAULT
	end

	local fValue = 1

	if 0 < bit.band(ATTRIBUTE_FLAG.OVERRIDE, flags) then
		local fValue2 = fValue
		local fTimeMax
		for key, tV in pairs(t) do
			if 0 < bit.band(tV.flags, flags) then
				local val = self:_val(key, tV.val, ...)
				if val then
					if not fTimeMax or tV.set_time < fTimeMax then
						fTimeMax = tV.set_time
						fValue2 = self:_countPercent(fValue, val)
					end
				end
			end
		end
		return fValue2
	end

	if self:_UseFixedness() then
		if 0 < bit.band(ATTRIBUTE_FLAG.NONE, flags) then
			fValue = self:_fixednessPctVal(hUnit, nil, ATTRIBUTE_FLAG.NONE) or 1
		end
		if 0 < bit.band(ATTRIBUTE_FLAG.UNIQUE, flags) then
			local f = self:_fixednessPctVal(hUnit, nil, ATTRIBUTE_FLAG.UNIQUE)
			if f then
				fValue = self:_countPercent(fValue, f)
			end
		end
	end

	for key, tV in pairs(t) do
		if (not self:_UseFixedness() or 'number' ~= type(tV.val)) and 0 < bit.band(tV.flags, flags) then
			local val = self:_val(key, tV.val, ...)
			if val then
				fValue = self:_countPercent(fValue, val)
			end
		end
	end

	return fValue
end
function public:_UseFixedness() return true end
function public:_fixednessVal(hUnit, fVal, flag)
	local sKey = '_AttributeSystem_fixedness' .. self.type
	local t = hUnit[sKey]
	if not t then
		t = {}
		hUnit[sKey] = t
	end
	if fVal then
		t[flag] = self:_count((t[flag] or self:_base(hUnit)), fVal)
	end
	return t[flag]
end
function public:_fixednessPctVal(hUnit, fVal, flag)
	local sKey = '_AttributeSystem_fixednessPct' .. self.type
	local t = hUnit[sKey]
	if not t then
		t = {}
		hUnit[sKey] = t
	end
	if fVal then
		t[flag] = self:_countPercent((t[flag] or 1), fVal)
	end
	return t[flag]
end
function public:_val(key, val, ...)
	if 'table' == type(key) and 'function' == type(val) then
		local bSuccess, r1, r2, r3, r4, r5 = xpcall(function(...)
			return val(key, ...)
		end, debug.traceback, ...)
		if bSuccess then
			return r1, r2, r3, r4, r5
		end
	end
	return val
end
function public:_base(hUnit) return 0 end
function public:_count(val1, val2, key)
	if type(val2) == 'number' then
		return val1 + val2
	end
	return val1
end
function public:_countPercent(val1, val2)
	if type(val2) == 'number' then
		-- return val1 * (1 + val2 * 0.01)		--累乘
		return val1 + val2 * 0.01			--累加
	end
	return val1
end
function public:_checkVal(val, key, ...) end

function public:GetValByKey(hUnit, key, ...)
	local fConst = self:GetValConstByKey(hUnit, key, ...)
	local fPer = self:GetValPercentByKey(hUnit, key, ...)
	if 1 ~= fPer then
		---计算百分比加成的val
		local flags = self:GetData(hUnit, 'Percent_' .. self.type)[key].flags
		return fConst + self:GetValConst(hUnit, flags, ...) * (fPer - 1)
	end
	return fConst
end
function public:GetValConstByKey(hUnit, key, ...)
	local fValue = 0
	local t = self:GetData(hUnit)
	if t then
		local tV = t[key]
		if tV then
			local val = self:_val(key, tV.val, ...)
			if val then
				return self:_count(fValue, val, key)
			end
		end
	end
	return fValue
end
function public:GetValPercentByKey(hUnit, key, ...)
	local fValue = 1
	local t = self:GetData(hUnit, 'Percent_' .. self.type)
	if t then
		local tV = t[key]
		if tV then
			local val = self:_val(key, tV.val, ...)
			if val then
				return self:_countPercent(fValue, val, key)
			end
		end
	end
	return fValue
end

--同步更新client某属性
if IsServer() then
	function public:UpdateClient(hUnit, key)
		local iEntID = hUnit:GetEntityIndex()
		local tTask = AttributeSystem.tUpdateTaskList[iEntID]
		if nil == tTask then
			tTask = {
				{ self.type, key }
			}
			AttributeSystem.tUpdateTaskList[iEntID] = tTask
			hUnit:Timer('AttributeUpdateClient', RandomFloat(0.1, 0.5), function()
				local tUpdate = {}
				for _, t in ipairs(tTask) do
					local tVal = AttributeSystem[t[1]]:GetData(hUnit)[t[2]]
					local tValPer = AttributeSystem[t[1]]:GetData(hUnit, 'Percent_' .. t[1])[t[2]]
					tUpdate[t[1]] = {
						val = tVal and tVal.val or nil,
						val_per = tValPer and tValPer.val or nil,
						flags = tVal and tVal.flags or nil,
						flags_per = tValPer and tValPer.flags or nil,
						key = tostring(t[2]),
					}
				end
				FireGameEvent("attribute_update_client", {
					entid = hUnit:GetEntityIndex(),
					json = json.encode(tUpdate),
				})
				AttributeSystem.tUpdateTaskList[iEntID] = nil
			end)
		else
			table.insert(tTask, { self.type, key })
		end
	end
else
	function public:UpdateClient(tEvent)
		local iEntID = tonumber(tEvent.entid)
		local hUnit = EntIndexToHScript(iEntID)
		if hUnit then
			local tUpdate = json.decode(tEvent.json)
			for sType, t in pairs(tUpdate) do
				hUnit:SetVal(sType, t.val, t.key, t.flags)
				hUnit:SetValPercent(sType, t.val_per, t.key, t.flags_per)
			end
		end
	end
	ListenToGameEvent("attribute_update_client", Dynamic_Wrap(public, "UpdateClient"), public)
end

--各数值算法接口
function interface(...)
	local t = { ... }
	return function(_, k)
		for _, v in ipairs(t) do
			for k2, v2 in pairs(v) do
				if k == k2 then
					return v2
				end
			end
		end
		return public[k]
	end
end

--百分比数值-累乘（默认值=100）
local Percentage_Multiply = setmetatable({}, { __index = public })
function Percentage_Multiply:_base() return 100 end
function Percentage_Multiply:_count(val1, val2)
	if type(val2) == 'number' then
		return val1 * math.max(100 + val2, 0) * 0.01
	end
	return val1
end
function Percentage_Multiply:_UseFixedness() return false end

--百分比数值-取反累乘（默认值=100）
local Percentage_InverseMultiply = setmetatable({}, { __index = public })
function Percentage_InverseMultiply:_base() return 100 end
function Percentage_InverseMultiply:_count(val1, val2)
	if type(val2) == 'number' then
		return 100 - (100 - val1) * math.max(100 - val2, 0) * 0.01
	end
	return val1
end
function Percentage_InverseMultiply:_UseFixedness() return false end

--百分比数值-取反累乘（默认值=0）
local Percentage_InverseMultiply_Base0 = setmetatable({}, { __index = Percentage_InverseMultiply })
function Percentage_InverseMultiply_Base0:_base() return 0 end

--非线性概率数值-取触发的最大值
local Random_Max = setmetatable({}, { __index = public })
function Random_Max:SetVal(hUnit, fValue, key, fChance, flags, ...)
	self:_checkVal(fValue, key, fChance, ...)
	local t = self:GetData(hUnit)
	key = key or DoUniqueString(self.type)
	if fValue == nil then
		t[key] = nil
	else
		t[key] = {
			chance = fChance,
			value = fValue,
		}
	end
	return key
end
function Random_Max:GetVal(hUnit, ...)
	local t = self:GetData(hUnit)
	local ret = self:_base()
	for key, data in pairs(t) do
		local value
		local chance = public._val(self, key, data.chance, ...)	--数值
		if nil == chance then
			value, chance = self:_val(key, data.value, ...)
		end
		if chance and PRD(hUnit, chance, tostring(key) .. '_' .. self.type) then
			if nil == value then
				value = self:_val(key, data.value, ...)
			end
			if value then
				ret = self:_count(ret, value, key)
			end
		end
	end
	return ret
end
function Random_Max:_count(val1, val2)
	return math.max(val1, val2)
end
function Random_Max:_UseFixedness() return false end

--String值
local StringValue = setmetatable({}, { __index = public })
function StringValue:_base() return '' end
function StringValue:_count(val1, val2) return val2 end

--优先级-取最大优先
local Level_Max = setmetatable({}, { __index = public })
function Level_Max:SetVal(hUnit, value, key, iLevel, flags, ...)
	self:_checkVal(value, key, iLevel, ...)
	local t = self:GetData(hUnit)
	key = key or DoUniqueString(self.type)
	if value == nil then
		t[key] = nil
	else
		t[key] = {
			level = iLevel,
			value = value,
		}
	end
	return key
end
function Level_Max:GetVal(hUnit, ...)
	local t = self:GetData(hUnit)
	local iLevelMax
	local value = self:_base()
	for key, data in pairs(t) do
		local iLevel = public._val(self, key, data.level, ...) or 0	--数值
		if nil == iLevelMax or iLevelMax < iLevel then
			local value2 = self:_val(key, data.value, ...)
			if value2 then
				iLevelMax = iLevel
				value = self:_count(value, value2, key)
			end
		end
	end
	return value
end
function Level_Max:_UseFixedness() return false end

--优先级-取优先级最高的一个，仅调用优先级最高的
local Level_First = setmetatable({}, { __index = public })
function Level_First:SetVal(hUnit, value, key, iLevel, flags, ...)
	self:_checkVal(value, key, iLevel, ...)
	local t = self:GetData(hUnit)
	key = key or DoUniqueString(self.type)
	if value == nil then
		t[key] = nil
	else
		t[key] = {
			level = iLevel,
			value = value,
		}
	end
	return key
end
function Level_First:GetVal(hUnit, ...)
	local t = self:GetData(hUnit)
	local value = self:_base()
	local tList = {}
	for key, data in pairs(t) do
		local iLevel = public._val(self, key, data.level, ...) or 0	--数值
		table.insert(tList, {
			key = key,
			level = iLevel,
		})
	end
	table.sort(tList, function(a, b)
		return a.level > b.level
	end)
	for i = 1, #tList, 1 do
		local key = tList[i].key
		local _value = self:_val(key, t[key].value, ...)
		if _value then
			return _value
		end
	end
	return value
end
function Level_First:_UseFixedness() return false end

--Function值
local FunctionValue = setmetatable({}, { __index = public })
function FunctionValue:GetVal(hUnit, ...)
	return self:GetValConst(hUnit, ...)
end
function FunctionValue:_checkVal(func, key, ...)
	if func and 'function' ~= type(func) and not ('string' == type(func) and 'table' == type(key)) then
		error('param 2: value type error')
	end
end
function FunctionValue:_val(key, val)
	return val
end
function FunctionValue:_base()
	return {}
end
function FunctionValue:_count(tFunc, val, key)
	if 'table' == type(key) then
		tFunc[key] = val
	else
		table.insert(tFunc, val)
	end
	return tFunc
end
function FunctionValue:Fire(hUnit, ...)
	for key, func in pairs(self:GetVal(hUnit)) do
		self:_fire(key, func, ...)
	end
end
function FunctionValue:_fire(key, func, ...)
	if 'table' == type(key) then
		return func(key, ...)
	else
		return func(...)
	end
end
function FunctionValue:_UseFixedness() return false end

--优先级Function值
local LevelFunction = setmetatable({}, { __index = interface(FunctionValue, Level_Max) })
function LevelFunction:GetVal(hUnit, ...)
	local tFunc = self:GetData(hUnit, ...)
	local tFuncList = {}
	for key, tVal in pairs(tFunc) do
		table.insert(tFuncList, { key, tVal.value, tVal.level })
	end
	table.sort(tFuncList, function(a, b)
		local iLevel_a = public._val(self, a[1], a[3]) or 0
		local iLevel_b = public._val(self, b[1], b[3]) or 0
		return iLevel_a > iLevel_b
	end)
	return tFuncList
end
function LevelFunction:Fire(hUnit, ...)
	for i, v in ipairs(self:GetVal(hUnit, ...)) do
		self:_fire(v[1], v[2], ...)
	end
end
--优先级Function值-取最大优先单值
local LevelFunction_Max = setmetatable({}, { __index = interface(Level_Max, FunctionValue) })
function LevelFunction_Max:GetVal(hUnit)
	local tFunc = Level_Max.GetVal(self, hUnit)
	if tFunc then
		for hBind, func in pairs(tFunc) do
			return func, hBind
		end
	end
end
function LevelFunction_Max:_count(tFunc, val, key)
	return FunctionValue._count(self, {}, val, key)
end


AttributeInterface = {
	Percentage_Multiply = Percentage_Multiply,
	Percentage_InverseMultiply = Percentage_InverseMultiply,
	Percentage_InverseMultiply_Base0 = Percentage_InverseMultiply_Base0,
	Random_Max = Random_Max,
	StringValue = StringValue,
	Level_Max = Level_Max,
	Level_First = Level_First,
	FunctionValue = FunctionValue,
	LevelFunction = LevelFunction,
	LevelFunction_Max = LevelFunction_Max,
}
require('core/Attribute/AttributeAPI')

return public