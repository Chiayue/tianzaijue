-- 分割字符串
function string.split(str, delimiter)
	if str == nil or str == '' or delimiter == nil then
		return nil
	end

	local result = {}
	string.gsub(str, "[^" .. delimiter .. "]+",
	function(w)
		table.insert(result, w)
	end)
	return result
end

-- 分割字符串，可以用正则表达式
function string.rsplit(str, sp)
	local result = {}
	local i = 0
	local j = 0
	local num = 1
	local pos = 0
	while true do
		i , j = string.find(str,sp,i+1)
		if i == nil then 
			result[num] = string.sub(str,pos,string.len(str))
			break
		end
		result[num] = string.sub(str,pos,i-1)
		pos = i+(j-(i-1))
		num = num +1
	end
	return result
end

-- 分割字符串的字母
function string.gsplit(str)
	local str_tb = {}
	if string.len(str) ~= 0 then
		for i = 1, string.len(str) do
			local new_str = string.sub(str, i, i)
			if (string.byte(new_str) >= 48 and string.byte(new_str) <= 57) or (string.byte(new_str) >= 65 and string.byte(new_str) <= 90) or (string.byte(new_str) >= 97 and string.byte(new_str) <= 122) then
				table.insert(str_tb, string.sub(str, i, i))
			else
				return nil
			end
		end
		return str_tb
	else
		return nil
	end
end

-- 将数组用字符串连接
function string.join(table, delimiter)
	DoScriptAssert(type(table) == "table", "first parameter must be a table!")
	DoScriptAssert(type(delimiter) == "string", "second parameter must be a string!")
	local str = ""
	for i, v in ipairs(table) do
		if str ~= "" then
			str = str .. delimiter
		end
		str = str .. tostring(v)
	end
	return str
end

-- 比较字符串
function string.equal(s1, s2)
	return tostring(s1) == tostring(s2)
end

function IsLeapYear(iYear)
	return (iYear % 4 == 0 and iYear % 100 ~= 0) or (iYear % 400 == 0)
end

function toUnixTime(iYear, iMonth, iDay, iHour, iMin, iSec)
	local iTotalSec = iSec + iMin * 60 + iHour * 60 * 60 + (iDay - 1) * 86400

	-- 此年经过的秒
	local iTotalDay = 0
	local iTotalMonth = iMonth - 1
	for i = 1, iTotalMonth, 1 do
		if i == 1 or i == 3 or i == 5 or i == 7 or i == 8 or i == 10 or i == 12 then
			iTotalDay = iTotalDay + 31
		elseif i == 4 or i == 6 or i == 9 or i == 11 then
			iTotalDay = iTotalDay + 30
		else
			if IsLeapYear(iYear) then
				iTotalDay = iTotalDay + 29
			else
				iTotalDay = iTotalDay + 28
			end
		end
	end

	-- 之前的年经过的秒
	for i = 1970, iYear - 1, 1 do
		if IsLeapYear(i) then
			iTotalDay = iTotalDay + 366
		else
			iTotalDay = iTotalDay + 365
		end
	end

	iTotalSec = iTotalSec + iTotalDay * 86400

	return iTotalSec
end
--- 返回表的值数量 `condition(v,k)`
function TableCount(t, condition)
	local n = 0
	if condition == nil then
		for k in pairs(t) do
			n = n + 1
		end
	elseif condition and type(condition) == "function" then
		for k in pairs(t) do
			if condition(t[k], k) then
				n = n + 1
			end
		end
	end
	return n
end

-- 获取表里随机一个值
function RandomValue(t)
	if TableCount(t) == 0 then
		return nil
	end
	local iRandom = RandomInt(1, TableCount(t))
	local n = 0
	for k, v in pairs(t) do
		n = n + 1
		if n == iRandom then
			return v
		end
	end
end

-- 获取数组里随机一个值
function GetRandomElement(table)
	return table[RandomInt(1, #table)]
end

-- 从表里寻找值的键
function TableFindKey(t, v)
	if t == nil then
		return nil
	end

	for _k, _v in pairs(t) do
		if v == _v then
			return _k
		end
	end
	return nil
end
-- 从表里
function TableFindValue(t, v)
	if t == nil then
		return nil
	end

	for _k, _v in pairs(t) do
		if v == _k then
			return _v
		end
	end
	return nil
end

-- 从表里移除值
function ArrayRemove(t, v)
	if t == nil then return end
	for i = #t, 1, -1 do
		if t[i] == v then
			table.remove(t, i)
		end
	end
end

-- 深拷贝
function deepcopy(orig)
	local copy
	if type(orig) == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

-- 浅拷贝
function shallowcopy(orig)
	local copy
	if type(orig) == 'table' then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

-- 乱序
function ShuffledList(orig_list)
	local list = shallowcopy(orig_list)
	local result = {}
	local count = #list
	for i = 1, count do
		local pick = RandomInt(1, #list)
		result[#result + 1] = list[pick]
		table.remove(list, pick)
	end
	return result
end

-- table覆盖
function TableOverride(mainTable, table)
	if mainTable == nil then
		return table
	end
	if table == nil or type(table) ~= "table" then
		return mainTable
	end

	for k, v in pairs(table) do
		if type(v) == "table" then
			mainTable[k] = TableOverride(mainTable[k], v)
		else
			mainTable[k] = v
		end
	end
	return mainTable
end

-- table替换
function TableReplace(mainTable, table)
	if mainTable == nil then
		return table
	end
	if table == nil or type(table) ~= "table" then
		return mainTable
	end

	for k, v in pairs(table) do
		if type(v) == "table" then
			mainTable[k] = TableReplace(mainTable[k], v)
		else
			if TableFindKey(mainTable, k) ~= nil then
				mainTable[k] = v
			end
		end
	end
	return mainTable
end

--- 四舍五入，s为精度
---@param s number 精度 2=保留2位小数
function Round(n, s)
	local sign = 1
	if n < 0 then
		n = math.abs(n)
		sign = -1
	end
	s = s and 10 ^ -s or 1
	if n ~= nil then
		local d = n / s
		local w = math.floor(d)
		if d - w >= 0.5 then
			return (w + 1) * s * sign
		else
			return w * s * sign
		end
	end
	return 0
end
--- 四舍五入，s为精度
---@param s number 精度 2=保留2位小数
function math.round(n, s) return Round(n, s) end

-- 判断两条线是否相交
function IsLineCross(pt1_1, pt1_2, pt2_1, pt2_2)
	return math.min(pt1_1.x, pt1_2.x) <= math.max(pt2_1.x, pt2_2.x) and math.min(pt2_1.x, pt2_2.x) <= math.max(pt1_1.x, pt1_2.x) and math.min(pt1_1.y, pt1_2.y) <= math.max(pt2_1.y, pt2_2.y) and math.min(pt2_1.y, pt2_2.y) <= math.max(pt1_1.y, pt1_2.y)
end

-- 跨立实验
function IsCross(p1, p2, p3)
	local x1 = p2.x - p1.x
	local y1 = p2.y - p1.y
	local x2 = p3.x - p1.x
	local y2 = p3.y - p1.y
	return x1 * y2 - x2 * y1
end

-- 判断两条线段是否相交
function IsIntersect(p1, p2, p3, p4)
	if IsLineCross(p1, p2, p3, p4) then
		if IsCross(p1, p2, p3) * IsCross(p1, p2, p4) <= 0 and IsCross(p3, p4, p1) * IsCross(p3, p4, p2) <= 0 then
			return true
		end
	end
	return false
end

-- 计算两条线段的交点
function GetCrossPoint(p1, p2, q1, q2)
	if IsIntersect(p1, p2, q1, q2) then
		local x = 0
		local y = 0
		local left = (q2.x - q1.x) * (p1.y - p2.y) - (p2.x - p1.x) * (q1.y - q2.y)
		local right = (p1.y - q1.y) * (p2.x - p1.x) * (q2.x - q1.x) + q1.x * (q2.y - q1.y) * (p2.x - p1.x) - p1.x * (p2.y - p1.y) * (q2.x - q1.x)

		if left == 0 then
			return vec3_invalid
		end
		x = right / left

		left = (p1.x - p2.x) * (q2.y - q1.y) - (p2.y - p1.y) * (q1.x - q2.x)
		right = p2.y * (p1.x - p2.x) * (q2.y - q1.y) + (q2.x - p2.x) * (q2.y - q1.y) * (p1.y - p2.y) - q2.y * (q1.x - q2.x) * (p2.y - p1.y)
		if left == 0 then
			return vec3_invalid
		end
		y = right / left

		return Vector(x, y, 0)
	end

	return vec3_invalid
end


-- 贝塞尔曲线
function Bessel(t, ...)
	local tPoints = { ... }
	if #tPoints == 1 then
		return tPoints[1]
	elseif #tPoints > 1 then
		while #tPoints > 2 do
			local tNewPoints = {}
			for i = 1, #tPoints - 1, 1 do
				local vPoint = VectorLerp(t, tPoints[i], tPoints[i + 1])
				table.insert(tNewPoints, vPoint)
			end
			tPoints = tNewPoints
		end
		return VectorLerp(t, tPoints[1], tPoints[2])
	end
end


-- 将c++里传出来的str形式的vector转换为vector
function StringToVector(str)
	if str == nil then return end
	local table = string.split(str, " ")
	return Vector(tonumber(table[1]), tonumber(table[2]), tonumber(table[3])) or nil
end

-- 以逆时针方向旋转
function Rotation2D(vVector, radian)
	local fLength2D = vVector:Length2D()
	local vUnitVector2D = vVector / fLength2D
	local fCos = math.cos(radian)
	local fSin = math.sin(radian)
	return Vector(vUnitVector2D.x * fCos - vUnitVector2D.y * fSin, vUnitVector2D.x * fSin + vUnitVector2D.y * fCos, vUnitVector2D.z) * fLength2D
end

-- 获取随机位置
function GetRandomPosition(vCenter, flRange, flMaxRange)
	if flMaxRange == nil then
		flMaxRange = flRange
		flRange = 0
	end
	return vCenter + RandomVector(RandomInt(flRange, flMaxRange))
end


-- 获取矩形区域内随机位置
---@param v1 左上
---@param v2 右上
---@param v3 右下
---@param v4 左下
function GetRandomPositionInRectangle(v1, v2, v3, v4)
	local x = RandomInt(v1.x, v2.x)
	local y = RandomInt(v4.y, v1.y)
	return Vector(x, y, v1.z)
end

-- 判断点是否在不规则图形里（不规则图形里是点集，点集每个都是固定住的）
function IsPointInPolygon(point, polygonPoints)
	local j = #polygonPoints
	local bool = 0
	for i = 1, #polygonPoints, 1 do
		local polygonPoint1 = polygonPoints[j]
		local polygonPoint2 = polygonPoints[i]
		if ((polygonPoint2.y < point.y and polygonPoint1.y >= point.y) or (polygonPoint1.y < point.y and polygonPoint2.y >= point.y)) and (polygonPoint2.x <= point.x or polygonPoint1.x <= point.x) then
			bool = bit.bxor(bool, ((polygonPoint2.x + (point.y - polygonPoint2.y) / (polygonPoint1.y - polygonPoint2.y) * (polygonPoint1.x - polygonPoint2.x)) < point.x and 1 or 0))
		end
		j = i
	end
	return bool == 1
end

-- 控制台打印单位所有的modifier
function PrintAllModifiers(hUnit)
	local modifiers = hUnit:FindAllModifiers()
	for n, modifier in pairs(modifiers) do
		local str = ""
		str = str .. "modifier name: " .. modifier:GetName()
		if modifier:GetCaster() ~= nil then
			str = str .. "\tcaster: " .. modifier:GetCaster():GetName()
			str = str .. "\t(" .. tostring(modifier:GetCaster()) .. ")"
		end
		if modifier:GetAbility() ~= nil then
			str = str .. "\tability: " .. modifier:GetAbility():GetName()
			str = str .. "\t(" .. tostring(modifier:GetAbility()) .. ")"
		end
		print(str)
	end
end

function VectorToString(v)
	if v == nil then return end
	return tostring(v.x) .. " " .. tostring(v.y) .. " " .. tostring(v.z)
end

-- 显示错误信息
function ErrorMessage(playerID, message, sound)
	if message == nil then
		sound = message
		message = playerID
		playerID = nil
	else
		assert(type(playerID) == "number", "playerID is not a number")
	end
	if playerID == nil then
		CustomGameEventManager:Send_ServerToAllClients("error_message", { message = message, sound = sound })
	else
		local player = PlayerResource:GetPlayer(playerID)
		CustomGameEventManager:Send_ServerToPlayer(player, "error_message", { message = message, sound = sound })
	end
end

function DropItemAroundUnit(unit, item)
	local position = unit:GetAbsOrigin() + Vector(RandomFloat(-50, 50), RandomFloat(-50, 50), 0)
	unit:DropItemAtPositionImmediate(item, position)
end

-- 判断一个handle是否为无效值
function IsValid(h)
	return h ~= nil and h.IsNull and not h:IsNull()
end

if IsClient() then
	-- 用于插件跳转
	if C_BaseEntity == nil then C_BaseEntity = class() end
	if C_DOTA_BaseNPC == nil then C_DOTA_BaseNPC = class() end

	-- 计时器
	function C_BaseEntity:Timer(sContextName, fInterval, funcThink)
		if funcThink == nil then
			funcThink = fInterval
			fInterval = sContextName
			sContextName = DoUniqueString("Timer")
		end
		self:SetContextThink(sContextName, function()
			local result = funcThink()
			if type(result) == "number" then
				result = math.max(FrameTime(), result)
			end
			return result
		end, fInterval)
		return sContextName
	end
	-- 游戏计时器
	function C_BaseEntity:GameTimer(sContextName, fInterval, funcThink)
		if funcThink == nil then
			funcThink = fInterval
			fInterval = sContextName
			sContextName = DoUniqueString("GameTimer")
		end
		local fTime = GameRules:GetGameTime() + math.max(FrameTime(), fInterval)
		return self:Timer(sContextName, fInterval, function()
			if GameRules:GetGameTime() >= fTime then
				local result = funcThink()
				if type(result) == "number" then
					fTime = fTime + math.max(FrameTime(), result)
				end
				return result
			end
			return 0
		end)
	end
	-- 暂停计时器
	function C_BaseEntity:StopTimer(sContextName)
		self:SetContextThink(sContextName, nil, -1)
	end

	--- 获取玩家ID
	function GetPlayerID(hUnit)
		local iPlayerID = -1
		if not IsValid(hUnit) then
			return iPlayerID
		end
		if hUnit.GetPlayerOwnerID then
			iPlayerID = hUnit:GetPlayerOwnerID()
		end
		if iPlayerID == -1 and hUnit.GetOwner and IsValid(hUnit:GetOwner()) then
			return GetPlayerID(hUnit:GetOwner())
		end
		return iPlayerID
	end
end

if IsServer() then
	-- 用于插件跳转
	if CBaseEntity == nil then CBaseEntity = class() end
	if CDOTA_BaseNPC == nil then CDOTA_BaseNPC = class() end
	--[[		计时器
		sContextName，计时器索引，可缺省
		fInterval，第一次运行延迟
		funcThink，回调函数，函数返回number将会再次延迟运行
		例：
		hUnit:GameTimer(0.5, function()
			hUnit:SetModelScale(1.5)
		end)
		GameRules:GetGameModeEntity():GameTimer(0.5, function()
			print(math.random())
			return 0.5
		end)
	]]
	--
	function CBaseEntity:Timer(sContextName, fInterval, funcThink)
		if funcThink == nil then
			funcThink = fInterval
			fInterval = sContextName
			sContextName = DoUniqueString("Timer")
		end
		self:SetContextThink(sContextName, function()
			local result = funcThink()
			if type(result) == "number" then
				result = math.max(FrameTime(), result)
			end
			return result
		end, fInterval)
		return sContextName
	end
	--[[		游戏计时器，游戏暂停会停下
	]]
	--
	function CBaseEntity:GameTimer(sContextName, fInterval, funcThink)
		if funcThink == nil then
			funcThink = fInterval
			fInterval = sContextName
			sContextName = DoUniqueString("GameTimer")
		end
		local fTime = GameRules:GetGameTime() + math.max(FrameTime(), fInterval)
		return self:Timer(sContextName, fInterval, function()
			if GameRules:GetGameTime() >= fTime then
				local result = funcThink()
				if type(result) == "number" then
					fTime = fTime + math.max(FrameTime(), result)
				end
				return result
			end
			return 0
		end)
	end
	--[[		暂停计时器，包括游戏计时器
	]]
	--
	function CBaseEntity:StopTimer(sContextName)
		self:SetContextThink(sContextName, nil, -1)
	end
	--- 游戏计时器，游戏暂停会停下 GameRules:GetGameModeEntity():GameTimer()
	function GameTimer(sContextName, fInterval, funcThink)
		return GameRules:GetGameModeEntity():GameTimer(sContextName, fInterval, funcThink)
	end
	function StopGameTimer(sContextName)
		return GameRules:GetGameModeEntity():StopTimer(sContextName)
	end
	--- 游戏计时器，游戏暂停bu会停下 GameRules:GetGameModeEntity():GameTimer()
	function Timer(sContextName, fInterval, funcThink)
		return GameRules:GetGameModeEntity():Timer(sContextName, fInterval, funcThink)
	end
	function StopTimer(sContextName)
		return GameRules:GetGameModeEntity():StopTimer(sContextName)
	end

	function CDOTA_BaseNPC:ModifyMaxHealth(fChanged)
		local fHealthPercent = self:GetHealth() / self:GetMaxHealth()
		self.fBaseHealth = (self.fBaseHealth or self:GetMaxHealth()) + fChanged
		local fBonusHealth = self:GetValPercent(ATTRIBUTE_KIND.StatusHealth) * 0.01 * self.fBaseHealth
		local fHealth = self.fBaseHealth + fBonusHealth
		self:SetBaseMaxHealth(fHealth)
		self:SetMaxHealth(fHealth)
		self:ModifyHealth(fHealthPercent * fHealth, nil, false, 0)
	end

	function CDOTA_BaseNPC:ModifyMaxMana(fChanged)
		local fManaPercent = self:GetMana() / self:GetMaxMana()
		self:SetMaxMana(self:GetMaxMana() + fChanged)
		self:SetMana(fManaPercent * self:GetMaxMana())
	end

	function EmitSoundForPlayer(sSoundName, iPlayerID)
		local hPlayer = PlayerResource:GetPlayer(iPlayerID)
		if hPlayer ~= nil then
			CustomGameEventManager:Send_ServerToPlayer(hPlayer, "emit_sound_for_player", { soundname = sSoundName })
		end
	end

	--- 设置镜头位置 看个目标
	---@param fTime number 固定镜头多长时间。nil=切视角不锁定镜头,0=永远
	---@param tMotion table 添加 modifier_motion 的参数使镜头运动
	function LetMeSeeSee(iPlayerID, target, fTime, tMotion)
		if not fTime then fTime = 0.1 end

		if type(target) == "table" then
			PlayerResource:SetCameraTarget(iPlayerID, target)
		elseif type(target) == "userdata" then
			if tMotion then
				if IsValid(_G.LetMeSeeSeeTarget[iPlayerID]) then
					_G.LetMeSeeSeeTarget[iPlayerID]:SetAbsOrigin(target)
					target = _G.LetMeSeeSeeTarget[iPlayerID]
				else
					target = CreateUnitByName("npc_dota_dummy", target, false, nil, nil, DOTA_TEAM_NOTEAM)
					_G.LetMeSeeSeeTarget[iPlayerID] = target
				end
				target:AddNewModifier(target, nil, "modifier_motion", TableOverride({ duration = fTime }, tMotion))
				target:AddNewModifier(target, nil, "modifier_dummy", { duration = fTime + 0.2 })
			else
				target = CreateModifierThinker(nil, nil, "modifier_dummy", { duration = fTime + 0.2 }, target, DOTA_TEAM_NOTEAM, false)
			end
			PlayerResource:SetCameraTarget(iPlayerID, target)
		else
			PlayerResource:SetCameraTarget(iPlayerID, nil)
		end

		if 0 < fTime then
			GameRules:GetGameModeEntity():GameTimer('LetMeSeeSee' .. iPlayerID, fTime + 0.1, function()
				PlayerResource:SetCameraTarget(iPlayerID, nil)
				if IsValid(_G.LetMeSeeSeeTarget[iPlayerID]) then
					_G.LetMeSeeSeeTarget[iPlayerID]:RemoveSelf()
				end
			end)
		end
		return target
	end
	if not _G.LetMeSeeSeeTarget then _G.LetMeSeeSeeTarget = {} end

	function CEntities:FindByNameLike(lastEnt, searchString)
		if lastEnt then
			lastEnt = self:Next(lastEnt)
		else
			lastEnt = self:First()
		end
		while lastEnt do
			if string.find(lastEnt:GetName(), searchString) then
				return lastEnt
			end
			lastEnt = self:Next(lastEnt)
		end
	end
	function CEntities:FindAllByNameLike(searchString)
		local t = {}
		local hEnt = self:FindByNameLike(nil, searchString)
		while hEnt do
			table.insert(t, hEnt)
			hEnt = self:FindByNameLike(hEnt, searchString)
		end
		return t
	end

	--- 获取玩家ID
	function GetPlayerID(hUnit)
		local iPlayerID = -1
		if not IsValid(hUnit) then
			return iPlayerID
		end
		if hUnit.GetPlayerOwnerID then
			iPlayerID = hUnit:GetPlayerOwnerID()
		elseif hUnit.GetPlayerID then
			iPlayerID = hUnit:GetPlayerID()
		end
		if iPlayerID == -1 and hUnit.GetOwner and IsValid(hUnit:GetOwner()) then
			return GetPlayerID(hUnit:GetOwner())
		end
		return iPlayerID
	end

	--- 队伍切换
	function ChangePlayerTeam(iPlayerID, iNewTeamNumber, funcCallback)
		local self = PlayerResource
		if not self then return end

		local iOldTeamNumber = self:GetTeam(iPlayerID)
		if iOldTeamNumber == iNewTeamNumber then return end


		if PlayerResource:GetConnectionState(iPlayerID) == DOTA_CONNECTION_STATE_CONNECTED then
			local iOldTeamPlayerCount = self:GetPlayerCountForTeam(iOldTeamNumber)
			local iNewTeamPlayerCount = self:GetPlayerCountForTeam(iNewTeamNumber)

			local iGold = self:GetUnreliableGold(iPlayerID)
			local iGoldReliable = self:GetReliableGold(iPlayerID)
			self:SetGold(iPlayerID, 0, false)
			self:SetGold(iPlayerID, 0, true)

			GameRules:SetCustomGameTeamMaxPlayers(iNewTeamNumber, iNewTeamPlayerCount + 1)
			self:UpdateTeamSlot(iPlayerID, iNewTeamNumber, iNewTeamPlayerCount)
			-- self:SetCustomTeamAssignment(iPlayerID, iNewTeamNumber)
			GameRules:SetCustomGameTeamMaxPlayers(iOldTeamNumber, iOldTeamPlayerCount - 1)

			self:SetGold(iPlayerID, iGold, false)
			self:SetGold(iPlayerID, iGoldReliable, true)

			local hPlayer = self:GetPlayer(iPlayerID)
			if IsValid(hPlayer) then
				hPlayer:SetTeam(iNewTeamNumber)
			end
		end

		if type(funcCallback) == "function" then
			funcCallback(iPlayerID, iOldTeamNumber, iNewTeamNumber)
		end

		local hHero = self:GetSelectedHeroEntity(iPlayerID)
		if IsValid(hHero) then
			hHero:SetTeam(iNewTeamNumber)
		end

		local tUnits = Entities:FindAllByClassname("npc_dota_creature")
		for _, hUnit in pairs(tUnits) do
			if IsValid(hUnit) then
				if GetPlayerID(hUnit) == iPlayerID then
					if hUnit.GetTeamNumber and iOldTeamNumber == hUnit:GetTeamNumber() then
						hUnit:SetTeam(iNewTeamNumber)
					end
				end
			end
		end
	end
end

Hashtables = Hashtables or {}
function CreateHashtable(tNewTabel)
	local new_hastable = tNewTabel or {}
	local index = 1
	while Hashtables[index] ~= nil do
		index = index + 1
	end
	Hashtables[index] = new_hastable
	return new_hastable, index
end
function RemoveHashtable(hastable)
	local index
	if type(hastable) == "number" then
		index = hastable
	else
		index = GetHashtableIndex(hastable) or 0
	end
	Hashtables[index] = nil
end
function GetHashtableIndex(hastable)
	for index, h in pairs(Hashtables) do
		if h == hastable then
			return index
		end
	end
	return nil
end
function GetHashtableByIndex(index)
	return Hashtables[index]
end
function HashtableCount()
	local n = 0
	for index, h in pairs(Hashtables) do
		n = n + 1
	end
	return n
end

--数值单位化
function NumberUnitization(iVal)
	local tUnit = { 9, 8, 7, 5 }
	for i, v in ipairs(tUnit) do
		if 1 <= iVal / (10 ^ (v - 1)) then
			return iVal / (10 ^ (v - 1)), 'Unitization_' .. v
		end
	end
	return iVal
end


--
----
--
--获取表中子元素个数
function getSize(table)
	if type(table) ~= "table" then
		return 0
	end

	local nSize = 0
	for _, _ in pairs(table) do
		nSize = nSize + 1
	end
	return nSize
end
-- 是否存在v
function exist(o, v)
	local isFunc = type(v) == "function"
	if o and v then
		for ki, vi in pairs(o) do
			if isFunc then
				if v(vi, ki) then
					return true
				end
			else
				if vi == v then
					return true
				end
			end
		end
		if o.__index then
			for ki, vi in pairs(o.__index) do
				if isFunc then
					if v(ki, vi) then
						return true
					end
				else
					if ki == v then
						return true
					end
				end
			end
		end
	end
	return false
end
-- 移除一个符合条件的 condition(v,k)
function remove(o, condition)
	local k
	if type(condition) == "function" then
		k = FIND(o, condition).key
	else
		k = KEY(o, condition)
	end
	if k then
		local v = o[k]
		if type(k) == "number" then
			table.remove(o, k)
		else
			o[k] = nil
		end
		return v
	end
	return nil
end
-- 移除所有符合条件的 condition(v,k)
function removeAll(o, condition)
	local l = TableCount(o)
	if #o == l then
		-- 数组
		for i = l, 1, -1 do
			if condition(o[i], i) then
				table.remove(o, i)
			end
		end
	else
		for k, v in pairs(o) do
			if condition(v, k) then
				o[k] = nil
			end
		end
	end
end
-- 移除重复元素
function removeRepeat(o)
	for k, v in pairs(o) do
		local tKVs = FindAll(o, function(v2) return v2 == v end)
		if 1 < #tKVs then
			local tNbKs = {}
			for i = #tKVs, 2, -1 do
				if 'number' == type(tKVs[i].key) then
					table.insert(tNbKs, tKVs[i].key)
				else
					o[tKVs[i].key] = nil
				end
			end
			if 0 < #tNbKs then
				table.sort(tNbKs, function(a, b)
					return a > b
				end)
				for _, v2 in ipairs(tNbKs) do
					table.remove(o, v2)
				end
			end
			return removeRepeat(o)
		end
	end
	return o
end
--- 查找一个符合条件的 condition(v,k)
---@return {value:any,key:any}
function FIND(o, condition)
	if o and condition and type(condition) == "function" then
		for ki, vi in pairs(o) do
			if condition(vi, ki) then
				return { key = ki, value = vi }
			end
		end
		if o.__index then
			for ki, vi in pairs(o.__index) do
				if condition(vi, ki) then
					return { key = ki, value = vi }
				end
			end
		end
	end
	return { key = nil, value = nil }
end
--- 查找所有符合条件的 condition(v,k)
function FindAll(o, condition)
	---@type {key:any, value:any}[]
	local result = {}
	local isFunc = type(condition) == "function"
	if o and condition then
		for ki, vi in pairs(o) do
			if isFunc then
				if condition(vi, ki) then
					table.insert(result, { key = ki, value = vi })
				end
			else
				if vi == condition then
					table.insert(result, { key = ki, value = vi })
				end
			end
		end
		if o.__index then
			for ki, vi in pairs(o.__index) do
				if isFunc then
					if condition(vi, ki) then
						table.insert(result, { key = ki, value = vi })
					end
				else
					if vi == condition then
						table.insert(result, { key = ki, value = vi })
					end
				end
			end
		end
	end
	return result
end
--- 通过value获取key
function KEY(o, v)
	local kf = nil
	if o and v then
		for ki, vi in pairs(o) do
			if vi == v then
				kf = ki
				break
			end
		end
		if not kf and o.__index then
			for ki, vi in pairs(o.__index) do
				if vi == v then
					kf = ki
					break
				end
			end
		end
	end
	return kf
end
--- 通过key获取value
function VALUE(o, k)
	local vf = nil
	if o and k then
		for ki, vi in pairs(o) do
			if ki == k then
				vf = vi
				break
			end
		end
		if not vf and o.__index then
			for ki, vi in pairs(o.__index) do
				if ki == k then
					vf = vi
					break
				end
			end
		end
	end
	return vf
end

local HOOKs = _G._HOOKs or {}
_G._HOOKs = HOOKs
function HOOK(ctx, from, to)
	local ret = nil
	local err = nil
	if ctx and to and type(ctx) == "table" and type(to) == "function" then
		local isString = false
		if type(from) == "function" then
			from = KEY(ctx, from)
		elseif type(from) == "string" then
			isString = true
		else
			from = nil
			err = "Hook failed caused by invalid arg 'from'."
		end
		if from then
			if not HOOKs[ctx] then HOOKs[ctx] = {} end
			if not HOOKs[ctx][from] then
				ret = VALUE(ctx, from)
				if ret and type(ret) == "function" then
					ctx[from] = to
					HOOKs[ctx][from] = ret
				elseif isString then
					ret = to
					ctx[from] = to
				else
					err = "Hook failed caused by nil or invalid target."
				end
			else
				err = "Hook failed caused by multiple hook."
			end
		end
	else
		err = "Hook failed caused by invalid args."
	end
	if err then
		print(err)
	end
	return ret, err
end

function UNHOOK(ctx, from)
	local ret = nil
	local err = nil
	if ctx and type(ctx) == "table" then
		local isString = false
		if type(from) == "function" then
			from = KEY(ctx, from)
		elseif type(from) == "string" then
			isString = true
		else
			from = nil
			err = "Unhook failed caused by invalid arg 'from'."
		end
		if from then
			if HOOKs[ctx] then
				ret = HOOKs[ctx][from]
				if ret and type(ret) == "function" then
					ctx[from] = ret
				elseif isString then
					ctx[from] = nil
				else
					err = "Unhook failed caused by nil or invalid target."
				end
				HOOKs[ctx][from] = nil
			else
				err = "Unhook failed caused by nil hook map."
			end
		end
	else
		err = "Unhook failed caused by invalid args."
	end
	if err then
		print(err)
	end
	return ret
end

--克隆
function clone(obj)
	local InTable = {};
	local function Func(obj)
		if type(obj) ~= "table" then   --判断表中是否有表
			return obj;
		end
		local NewTable = {};  --定义一个新表
		InTable[obj] = NewTable;  --若表中有表，则先把表给InTable，再用NewTable去接收内嵌的表
		for k, v in pairs(obj) do  --把旧表的key和Value赋给新表
			NewTable[Func(k)] = Func(v);
		end
		return setmetatable(NewTable, getmetatable(obj))--赋值元表
	end
	return Func(obj) --若表中有表，则把内嵌的表也复制了
end
--拷贝
function copy(ori)
	if type(ori) == "table" then
		local tb = {}
		for k, v in pairs(ori) do
			tb[k] = v
		end
		return tb
	else
		return ori
	end

end
--参数绑定
function bind(fun, ...)
	local param = { ... }
	local strParam = ""
	for i = 1, #param do
		strParam = strParam .. (1 < i and ',' or '') .. "param[" .. i .. "]"
	end
	return (load(string.format([[
		local arg = { ... }
		local param = arg[1]
		return function(...)
			return arg[2](%s, ...)
		end
	]], strParam)))(param, fun)
end
--表合并（index部分合并，其他部分相覆盖）
function concat(...)
	local arg = { ... }
	local tab = {}
	for _, v in pairs(arg) do
		if "table" ~= type(v) then
			table.insert(tab, v)
		else
			local i = 1
			for k, v2 in ipairs(v) do
				i = k
				table.insert(tab, v2)
			end
			for k, v2 in pairs(v) do
				if "number" ~= type(k) or (1 > k or i < k) then
					tab[k] = v2
				end
			end
		end
	end
	return tab
end
--表随机
function randomTab(o)
	local oTmp = copy(o)
	local o2 = {}
	for i = #oTmp, 1, -1 do
		local index = RandomInt(1, #oTmp)
		table.insert(o2, oTmp[index])
		table.remove(oTmp, index)
	end
	return o2
end
--表首元素
function table.begin(t)
	for k, v in pairs(t) do
		return v, k
	end
end
--表末元素
function table.rbegin(t)
	local v, k
	for _, _2 in pairs(t) do
		v = _2
		k = _
	end
	return v, k
end
--表随机元素	return v,k
function table.random(t)
	local i = 0
	local t2 = {}
	for k, v in pairs(t) do
		i = i + 1
		table.insert(t2, { k, v })
	end
	if 0 < i then
		local tKV = t2[RandomInt(1, i)]
		return tKV[2], tKV[1]
	end
end
-- 打印表
function PrintTable(keys)
	print("----------------------------------")
	for k, v in pairs(keys) do
		print(k, v)
	end
	print("----------------------------------")
end
--矢量夹角
function AngleBetween(v1, v2)
	local sin = v1.x * v2.y - v2.x * v1.y;
	local cos = v1.x * v2.x + v1.y * v2.y;
	local a = math.atan2(sin, cos) * (180 / math.pi)
	local sign = v1:Cross(v2):Normalized():Dot(v1:Normalized():Cross(v2:Normalized()))
	return a * sign
end
---计算距离
function CalculateDistance(ent1, ent2, b3D)
	if ent1 == nil or ent2 == nil then return 0 end
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local vector = (pos1 - pos2)
	if b3D then
		return vector:Length()
	else
		return vector:Length2D()
	end
end
---计算方向
function CalculateDirection(ent1, ent2)
	if ent1 == nil or ent2 == nil then return vec3_invalid end
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local direction = pos1 - pos2
	direction.z = 0
	return direction:Normalized()
end
--- 计算垂直向量
function CalculateVerticalVector(v)
	local v1 = v:Normalized()
	v1.z = 0
	if v1.x == 0 then
		v1 = Vector(1, 0, 0)
	end
	v1 = Vector(-v1.y / v1.x, 1, 0)
	return v1:Normalized()
end

local co_pool = {}
function co_create(f)
	local co = table.remove(co_pool)
	if co == nil then
		co = coroutine.create(
		function(...)
			local rt = f(...)
			while true do
				f = nil
				co_pool[#co_pool + 1] = co
				f = coroutine.yield(rt)
				rt = f(coroutine.yield())
			end
		end)
	else
		coroutine.resume(co, f)
	end
	return co
end

--处理报错信息替换成文件路径
function ReplaceLoaderError(s, sPath)
	local iPos = string.find(s, '\n')
	local sHead = '--[[LOAD TO ' .. sPath .. ']]'
	local sChange = sHead .. string.sub(s, 0, iPos - 1)
	sHead = string.gsub(sHead, '-', '%%-')
	local sFind = '[string "' .. sHead .. '.-..."]'
	sFind = string.gsub(sFind, '%[', '%%[')
	sFind = string.gsub(sFind, ']', '%%]')
	if not _G.tErrorGsub then _G.tErrorGsub = {} end
	_G.tErrorGsub[sFind] = sPath
	return sChange .. string.sub(s, iPos)
end

function is_function(o)
	return type(o) == "function"
end

function is_number(o)
	return type(o) == 'number'
end

function is_string(o)
	return type(o) == 'string'
end


---创建世界场景UIPanel
function CreateClientUIPanel(sXML, vPos, iWidth, iHeight, sClassName)
	local data = {
		origin = vPos,
		dialog_layout_name = sXML,
		width = tostring(iWidth),
		height = tostring(iHeight),
		panel_dpi = "1",
		interact_distance = "0",
		horizontal_align = "1",
		vertical_align = "1",
		orientation = "0",
		angles = "0 0 0"
	}
	local panel = SpawnEntityFromTableSynchronous("point_clientui_world_panel", data)
	panel:AddCSSClasses(sClassName)
end