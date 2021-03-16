local function ShowPos(a, b, c, d)
	a = GetGroundPosition(a, nil)
	b = GetGroundPosition(b, nil)
	c = GetGroundPosition(c, nil)
	d = GetGroundPosition(d, nil)
	DebugDrawLine(a, b, 255, 255, 255, true, 10)
	DebugDrawLine(b, c, 255, 255, 255, true, 10)
	DebugDrawLine(c, d, 255, 255, 255, true, 10)
	DebugDrawLine(d, a, 255, 255, 255, true, 10)
	DebugDrawLine(a, c, 255, 255, 255, true, 10)

	local size = 10
	local a1 = a + Vector(size, size, 0)
	local b1 = a + Vector(size, -size, 0)
	local c1 = a + Vector(-size, -size, 0)
	local d1 = a + Vector(-size, size, 0)
	DebugDrawLine(a1, b1, 255, 255, 255, true, 10)
	DebugDrawLine(b1, c1, 255, 255, 255, true, 10)
	DebugDrawLine(c1, d1, 255, 255, 255, true, 10)
	DebugDrawLine(d1, a1, 255, 255, 255, true, 10)
end


GRID_ALPHA = 30 -- Defines the transparency of the ghost squares (Panorama)
MODEL_ALPHA = 75 -- Defines the transparency of both the ghost model (Panorama) and Building Placed (Lua)
RECOLOR_GHOST_MODEL = true -- Whether to recolor the ghost model green/red or not
RECOLOR_BUILDING_PLACED = true -- Whether to recolor the queue of buildings placed (Lua)
BUILDING_SIZE = 1
BUILDING_ANGLE = 0

--建筑单位格大小
BUILDING_UNIT_SIZE = 64 * 4--128 * 1
--建筑坐标偏移
BUILDING_OFFSET_X = 48
BUILDING_OFFSET_Y = 48
--是否显示可建筑区域网格
SHOW_CAN_BUILDING_GRID = true
--取反 building_disabled
INVERSE_BUILDING_DISABLED = true

--建造区域类型
BUILDING_MAP_TYPE = {
	BASE = 1, --基础区域
	BOSS = 2, --BOSS区域
}
----------------------------------------------------------------------------------------------------
--- PlayerBuildings 玩家建筑数据
if PlayerBuildings == nil then
	---@class PlayerBuildings 玩家建筑数据
	PlayerBuildings = {}
end
function PlayerBuildings:init(bReload)
	if not bReload then
		---@field 基础建筑数据 {}
		self.tData = {}
		self.tModifyData = {}
	end
	-- 接入修改器类型
	self.tMDFType = {
		BuildingBonus = 1, -- 修改最大建筑数量
	}
end
function PlayerBuildings:UpdateNetTables()
	CustomNetTables:SetTableValue("common", "player_buildings", self:GetData())
end
--- 获取所有玩家建筑数据
function PlayerBuildings:GetData()
	self:UpdateModifyData()
	return self.tData
end
function PlayerBuildings:UpdateModifyData()
	local sType = "hero"

	for iPlayerID, t in pairs(self.tModifyData) do
		local tPlayerData = {}
		if t and t[self.tMDFType.BuildingBonus] then
			for hSource, func in pairs(t[self.tMDFType.BuildingBonus]) do
				if hSource and func then
					local iBonus = func(hSource)
					tPlayerData[hSource:GetName()] = iBonus + (tPlayerData[hSource:GetName()] or 0)
				end
			end
		end
		self.tData[iPlayerID][sType].modifier_max = tPlayerData
	end
end
--- 初始化玩家建筑信息
function PlayerBuildings:InitPlayerData(iPlayerID)
	self.tData[iPlayerID] = {
		nonhero = {
			list = {},
			max = BUILDING_MIN_COUNT,
			modifier_max = {},
		},
		hero = {
			list = {},
			max = BUILDING_MIN_COUNT,
			modifier_max = {},
		},
	}
	self.tModifyData[iPlayerID] = {}
end
--- 修改羁绊需求数量
function GetModifyFettersActiveCount(iPlayerID, sTagName, iCount)
	local fConstant = 0
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_FETTERS_ACTIVE_COUNT, iPlayerID, sTagName, iCount)) do
		local iVal = tonumber(tVals[1]) or 0
		if type(key) == 'table' then
			---@type eom_modifier
			local hBuff = key
			if hBuff:GetPlayerID() ~= iPlayerID then
				iVal = 0
			end
		end
		fConstant = iVal + fConstant
	end
	return fConstant
end
if not EModifier:HasModifier(EMDF_FETTERS_ACTIVE_COUNT) then EModifier:CreateModifier(EMDF_FETTERS_ACTIVE_COUNT) end

function PlayerBuildings:GetModifierMaxBuildingData(iPlayerID, key, sType)
	sType = sType or "hero"
	local tPlayerData = self.tData[iPlayerID]
	if tPlayerData and tPlayerData[sType] and key then
		return tPlayerData[sType].modifier_max
	end
end
--- 获取玩家最大建筑数量奖励
function PlayerBuildings:GetPlayerMaxBuildingBonus(iPlayerID, sType)
	self:UpdateModifyData()

	sType = sType or "hero"
	local iCount = 0
	local tPlayerData = self.tData[iPlayerID]
	if tPlayerData and tPlayerData[sType] then
		for k, v in pairs(tPlayerData[sType].modifier_max) do
			if v ~= nil then
				iCount = iCount + v
			end
		end
	end
	return iCount
end
--- 修改最大建筑数量
function PlayerBuildings:GetModifierMaxBuildingBonus(hSource, func)
	local iPlayerID = hSource:GetPlayerID()
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData ~= nil then
		tPlayerModifyData[self.tMDFType.BuildingBonus] = tPlayerModifyData[self.tMDFType.BuildingBonus] or {}
		local tModify = tPlayerModifyData[self.tMDFType.BuildingBonus]
		if tModify[hSource] ~= func then
			tModify[hSource] = func
		end
	end
	self:UpdateNetTables()
end
--- 设置玩家最大建筑数量
--- @param iPlayerID number 玩家id
--- @param iCount number 数量
function PlayerBuildings:SetPlayerMaxBuildingCount(iPlayerID, iCount)
	if self.tData[iPlayerID] then
		self.tData[iPlayerID].hero.max = iCount
		self.tData[iPlayerID].nonhero.max = iCount
		self:UpdateNetTables()
	end
end
--- 获取玩家最大建筑数量
--- @param iPlayerID number 玩家id
--- @param sType string 建筑类型"hero/nonhero" 默认为 "hero"
--- @return number
function PlayerBuildings:GetPlayerMaxBuildCount(iPlayerID, sType)
	sType = sType or "hero"
	local tPlayerData = self.tData[iPlayerID]
	if tPlayerData then
		local iBonus = PlayerBuildings:GetPlayerMaxBuildingBonus(iPlayerID, sType)
		return tPlayerData[sType].max + iBonus
	end
end
--- 获取玩家当前建筑数量
--- @param iPlayerID number 玩家id
--- @param sType string 建筑类型"hero/nonhero" 默认为 "hero"
function PlayerBuildings:GetPlayerCurBuildCount(iPlayerID, sType)
	sType = sType or "hero"
	local tPlayerData = self.tData[iPlayerID]
	if tPlayerData then
		return #tPlayerData[sType].list
	end
end
--- 玩家建筑增加
--- @param iPlayerID number 玩家id
--- @param iEntIndex number 建筑entindex
--- @param sType string 建筑类型"hero/nonhero" 默认为 "hero"
function PlayerBuildings:AddPlayerBuilding(iPlayerID, iEntIndex, sType)
	sType = sType or "hero"
	local tPlayerData = self.tData[iPlayerID]
	if tPlayerData and tPlayerData[sType] then
		table.insert(tPlayerData[sType].list, iEntIndex)
		self:UpdateNetTables()
	end
end
--- 玩家建筑移除
--- @param iPlayerID number 玩家id
--- @param iEntIndex number 建筑entindex
--- @param sType string 建筑类型"hero/nonhero" 默认为 "hero"
function PlayerBuildings:RemovePlayerBuilding(iPlayerID, iEntIndex, sType)
	sType = sType or "hero"
	local tPlayerData = self.tData[iPlayerID]
	if tPlayerData and tPlayerData[sType] then
		ArrayRemove(tPlayerData[sType].list, iEntIndex)
		self:UpdateNetTables()
	end
end
--- 遍历玩家建筑 `function(hBuilding, iPlayerID, iEntIndex)` 返回`true` 停止遍历
--- @param iPlayerID number 玩家id
--- @param func function
--- @param sType string 建筑类型"hero/nonhero" 默认为 "hero"
function PlayerBuildings:EachPlayerBuilding(iPlayerID, func, sType)
	sType = sType or "hero"
	local tPlayerData = self.tData[iPlayerID]
	if tPlayerData and tPlayerData[sType] then

		for i = #tPlayerData[sType].list, 1, -1 do
			local iEntIndex = tPlayerData[sType].list[i]
			local hUnit = EntIndexToHScript(iEntIndex)
			if IsValid(hUnit) and BuildSystem:IsBuilding(hUnit) then
				local hBuilding = hUnit:GetBuilding()
				if hBuilding and func then
					if func(hBuilding, iPlayerID, iEntIndex) == true then
						return
					end
				end
			end
		end
	end
end
--- **遍历玩家建筑[通用]**
--- `function(hBuilding, iPlayerID, iEntIndex)` 返回 `true` 停止遍历
--- @param iPlayerID number | function 必须参数 玩家id | function
--- @param func function 可选参数 function
function PlayerBuildings:EachBuilding(iPlayerID, func)
	if func == nil then
		func = iPlayerID
		iPlayerID = nil
	end

	if iPlayerID and self.tData[iPlayerID] then
		PlayerBuildings:EachPlayerBuilding(iPlayerID, func)
		PlayerBuildings:EachPlayerBuilding(iPlayerID, func, "nonhero")
	else
		for iPlayerID, v in pairs(self.tData) do
			PlayerBuildings:EachPlayerBuilding(iPlayerID, func)
			PlayerBuildings:EachPlayerBuilding(iPlayerID, func, "nonhero")
		end
	end
end
--- 遍历玩家英雄建筑 `function(hBuilding, iPlayerID, iEntIndex)` 返回 `true` 停止遍历
--- @param iPlayerID number
--- @param func function
function PlayerBuildings:EachHeroBuilding(iPlayerID, func)
	if iPlayerID and self.tData[iPlayerID] then
		PlayerBuildings:EachPlayerBuilding(iPlayerID, func)
	else
		for iPlayerID, v in pairs(self.tData) do
			PlayerBuildings:EachPlayerBuilding(iPlayerID, func)
		end
	end
end
--- 遍历玩家非英雄建筑 `function(hBuilding, iPlayerID, iEntIndex)` 返回 `true` 停止遍历
--- @param iPlayerID number
--- @param func function
function PlayerBuildings:EachNonheroBuilding(iPlayerID, func)
	if iPlayerID and self.tData[iPlayerID] then
		PlayerBuildings:EachPlayerBuilding(iPlayerID, func, "nonhero")
	else
		for iPlayerID, v in pairs(self.tData) do
			PlayerBuildings:EachPlayerBuilding(iPlayerID, func, "nonhero")
		end
	end
end
--- 玩家是否有某个建筑单位
function PlayerBuildings:HasBuildingUnit(iPlayerID, sUnitName)
	local bHas = false
	PlayerBuildings:EachBuilding(iPlayerID, function(hBuilding, iPlayerID, iEntIndex)
		if sUnitName == hBuilding:GetUnitEntityName() then
			bHas = true
			return true
		end
	end)
	return bHas
end

----------------------------------------------------------------------------------------------------
--- BuildSystem 玩家建筑逻辑
if BuildSystem == nil then
	---@class BuildSystem
	BuildSystem = class({})
end

---@type BuildSystem
local public = BuildSystem

function public:init(bReload)
	PlayerBuildings:init(bReload)

	if not bReload then
		self.hBlockers = {}
		self.hAllowable = {}

		self.cardBuildingInfo = {}

		DotaTD:EachCard(function(rarity, cardName, abilityName)
			self.cardBuildingInfo[cardName] = {
				rarity = rarity,
				ability_name = abilityName,
				size = BUILDING_SIZE,
				grid_alpha = GRID_ALPHA,
				model_alpha = MODEL_ALPHA,
				recolor_ghost = RECOLOR_GHOST_MODEL,
				attack_range = KeyValues.UnitsKv[cardName] ~= nil and (KeyValues.UnitsKv[cardName].AttackRange or 0) or 0,
			}
		end)
		CustomNetTables:SetTableValue("common", "card_building_info", self.cardBuildingInfo)

		-- 禁止建造区域
		local building_disabled = Entities:FindAllByNameLike("building_disabled")
		for k, v in pairs(building_disabled) do
			local origin = v:GetAbsOrigin()
			local angles = v:GetAngles()
			local bounds = v:GetBounds()
			local vMin = RotatePosition(Vector(0, 0, 0), angles, bounds.Mins) + origin
			local vMax = RotatePosition(Vector(0, 0, 0), angles, bounds.Maxs) + origin

			local polygon = {
				Vector(vMin.x, vMin.y, 0),
				Vector(vMax.x, vMin.y, 0),
				Vector(vMax.x, vMax.y, 0),
				Vector(vMin.x, vMax.y, 0),
			}
			if INVERSE_BUILDING_DISABLED then
				self:CreateAllowable(polygon, v)
			else
				self:CreateBlocker(polygon, v)
			end
		end

		-- self.tPlayerBuildings = {}
		self.tMapPoints = {}
	end
	self.typeBuildingMap = BUILDING_MAP_TYPE.BASE

	CustomUIEvent("UpgradeBuilding", Dynamic_Wrap(public, "OnUpgradeBuilding"), public)
	CustomUIEvent("PlayerMoveBuilding", Dynamic_Wrap(public, "OnPlayerMoveBuilding"), public)
	CustomUIEvent("PlayerMoveBuilding_Update", Dynamic_Wrap(public, "OnPlayerMoveBuilding_Update"), public)
	CustomUIEvent("PlayerMoveBuilding_PutDown", Dynamic_Wrap(public, "OnPlayerMoveBuilding_PutDown"), public)
	CustomUIEvent("PlayerMoveBuilding_Close", Dynamic_Wrap(public, "OnPlayerMoveBuilding_Close"), public)
	CustomUIEvent("PlayerMoveBuilding_PutDown_Withdraw", Dynamic_Wrap(public, "OnPlayerMoveBuilding_PutDown_Withdraw"), public)
	CustomUIEvent("PlayerMoveBuilding_PutDown_Sell", Dynamic_Wrap(public, "OnPlayerMoveBuilding_PutDown_Sell"), public)

	-- 各队伍地图坐标点
	self.tMapPoints[BUILDING_MAP_TYPE.BASE] = {}
	for k, v in pairs(TEAM_MAP_POINT_ENTITY) do
		self.tMapPoints[BUILDING_MAP_TYPE.BASE][k] = Entities:FindByNameLike(nil, v)
	end
	-- 各队伍Boss地图坐标点
	self.tMapPoints[BUILDING_MAP_TYPE.BOSS] = {}
	for k, v in pairs(TEAM_BOSS_MAP_POINT_ENTITY) do
		self.tMapPoints[BUILDING_MAP_TYPE.BOSS][k] = Entities:FindByNameLike(nil, v)
	end

	self:UpdateNetTables()

	EventManager:register(ET_GAME.DAMAGE_FILTER, 'OnDamageFilter', self)
end

--UI事件************************************************************************************************************************
	do
	-- 升级建筑
	function public:OnUpgradeBuilding(eventSourceIndex, events)
		local playerID = events.PlayerID
		local building = EntIndexToHScript(events.buildingEntIndex)
		if building then
			self:UpgradeBuilding(building)
		end
	end
	-- 玩家移动建筑
	function public:OnPlayerMoveBuilding(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local vPos = Vector(tonumber(events.pos['0']), tonumber(events.pos['1']), tonumber(events.pos['2']))
		local hUnit = EntIndexToHScript(events.entid)
		if hUnit and self:IsBuilding(hUnit) then
			---@type Building
			local hBuilding = hUnit:GetBuilding()
			if hBuilding:IsBattling() then
				return
			end
			hUnit:RemoveModifierByName('modifier_pudding')
			hUnit:AddNewModifier(hUnit, nil, 'modifier_building_move', {
				pos_x = vPos.x,
				pos_y = vPos.y,
				pos_z = vPos.z,
			})
		end
	end
	-- 玩家移动建筑时更新位置
	function public:OnPlayerMoveBuilding_Update(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local vPos = Vector(tonumber(events.pos['0']), tonumber(events.pos['1']), tonumber(events.pos['2']))
		local hUnit = EntIndexToHScript(events.entid)
		if hUnit and self:IsBuilding(hUnit) then
			local hBuff = hUnit:FindModifierByName('modifier_building_move')
			if hBuff then
				hBuff.vPos = Vector(vPos.x, vPos.y, vPos.z)
			end
		end
	end
	-- 玩家放下移动建筑
	function public:OnPlayerMoveBuilding_PutDown(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iTeamID = PlayerData:GetPlayerTeamID(iPlayerID)

		local vPos = Vector(tonumber(events.pos['0']), tonumber(events.pos['1']), tonumber(events.pos['2']))
		local hUnit = EntIndexToHScript(events.entid)

		if hUnit and self:IsBuilding(hUnit) then
			if hUnit:HasModifier('modifier_building_move') then
				---@type Building
				local hBuilding = hUnit:GetBuilding()

				SnapToGrid(BUILDING_SIZE, vPos)
				if not BuildSystem:ValidPosition(BUILDING_SIZE, vPos, iTeamID, self.typeBuildingMap) then
					local hBuildingPos = BuildSystem:GetBuildingByPos(vPos)
					if hBuildingPos and hBuildingPos ~= hBuilding then
						--有其他单位,换位置
						hBuildingPos:Move(hBuilding.vLocation)
					else
						ErrorMessage(iPlayerID, 'dota_hud_error_cant_build_at_location')
						vPos = hBuilding.vLocation
					end
				end

				hUnit:RemoveModifierByName('modifier_building_move')
				hBuilding:Move(vPos)
			end
		end
	end
	-- 玩家取消移动建筑
	function public:OnPlayerMoveBuilding_Close(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local hUnit = EntIndexToHScript(events.entid)
		if hUnit and self:IsBuilding(hUnit) then
			if hUnit:HasModifier('modifier_building_move') then
				local hBuilding = hUnit:GetBuilding()
				hUnit:RemoveModifierByName('modifier_building_move')
				hBuilding:Move(hBuilding.vLocation)
			end
		end
	end
	-- 玩家移动建筑到手牌
	function public:OnPlayerMoveBuilding_PutDown_Withdraw(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local iSlot = tonumber(events.card_slot)
		local hUnit = EntIndexToHScript(events.entid)

		if hUnit and self:IsBuilding(hUnit) then
			local hBuilding = hUnit:GetBuilding()

			if PlayerData:IsBattling(iPlayerID) then
				ErrorMessage(iPlayerID, 'dota_hud_error_withdraw_in_battleing')
			else
				local tCardData = HeroCardData:AddCardByUnit(iPlayerID, hUnit)
				if tCardData then
					HeroCardData:SetCardSlot(tCardData, iSlot)
					EventManager:fireEvent(ET_PLAYER.ON_TOWER_TO_CARD, {
						hBuilding = hBuilding,
						tCardData = tCardData,
					})
					self:RemoveBuilding(hUnit)
					return
				end
			end

			hUnit:RemoveModifierByName('modifier_building_move')
			hBuilding:Move(hBuilding.vLocation)
		end
	end
	-- 玩家移动建筑到出售区域
	function public:OnPlayerMoveBuilding_PutDown_Sell(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local hUnit = EntIndexToHScript(events.entid)
		if hUnit and self:IsBuilding(hUnit) then
			local hBuilding = hUnit:GetBuilding()

			if PlayerData:IsBattling(iPlayerID) then
				ErrorMessage(iPlayerID, 'dota_hud_error_sell_in_battleing')

				hUnit:RemoveModifierByName('modifier_building_move')
				hBuilding:Move(hBuilding.vLocation)
				return
			end

			self:SellBuilding(hUnit)
		end
	end
end

--事件监听************************************************************************************************************************
	do
	--- 棋子生成
	---@param events EventData_ON_TOWER_SPAWNED
	function public:OnTowerSpawned(events)
		if PlayerData:IsBattling(events.PlayerID) then
			events.hBuilding:JoinBattle()
		end
	end

	--- 进入战斗，棋子添加AI
	function public:OnInBattle()
		---@param hBuilding Building
		self:EachBuilding(function(hBuilding)
			local hUnit = hBuilding:GetUnitEntity()
			hUnit:RemoveModifierByName('modifier_building_move')
			hBuilding:Move(hBuilding.vLocation)
			hBuilding:JoinBattle()
		end)
	end

	--- 战斗准备 重置棋子
	function public:ResetUnitOnPreparation()
		---@param hBuilding Building
		self:EachBuilding(function(hBuilding)
			hBuilding:reset()
		end)
	end

	--- 战斗结束 重置棋子
	function public:ResetUnitOnBattleEnd(iPlayerID)
		if iPlayerID then
			---@param hBuilding Building
			self:EachBuilding(iPlayerID, function(hBuilding)
				local hUnit = hBuilding:GetUnitEntity()
				if IsValid(hUnit) then
					hUnit:GameTimer(RandomFloat(0, 1), function()
						hBuilding:ResetUnit()
					end)
				end
			end)
		else
			self:EachBuilding(function(hBuilding)
				local hUnit = hBuilding:GetUnitEntity()
				if IsValid(hUnit) then
					hUnit:GameTimer(RandomFloat(0, 1), function()
						hBuilding:ResetUnit()
					end)
				end
			end)
		end
	end

	-- 棋子生成：Boss回合给本地玩家建筑添加颜色光环
	function public:OnTowerSpawned_AddColorAura(events)
		if Spawner:IsBossRound() then
			local hUnit = events.hBuilding:GetUnitEntity()
			if IsValid(hUnit) then
				hUnit:AddNewModifier(hUnit, nil, 'modifier_color_aura', { RGB = 3997500 })
			end
		end
	end
	-- 回合开始：Boss回合给本地玩家建筑添加颜色光环
	function public:OnPreparation_AddColorAura()
		local doonce
		if Spawner:IsBossRound() then
			doonce = function(hUnit)
				hUnit:AddNewModifier(hUnit, nil, 'modifier_color_aura', { RGB = 3997500 })
			end
		else
			doonce = function(hUnit)
				hUnit:RemoveModifierByName('modifier_color_aura')
			end
		end

		---@param hBuilding Building
		EachUnits(function(hUnit)
			doonce(hUnit)
		end, UnitType.Building)
	end

	---监听伤害，统计
	---@param tEvent EventData_DAMAGE_FILTER
	function public:OnDamageFilter(tEvent)
		local hAttacker = tEvent.hAttacker
		local hVictim = tEvent.hVictim
		local iDamageType = tEvent.typeDamage
		local fDamage = tEvent.fDamage

		if IsValid(hAttacker) and hAttacker ~= hVictim then
			hAttacker = hAttacker.GetSource and hAttacker:GetSource()
			if self:IsBuilding(hAttacker) then
				local hBuilding = hAttacker:GetBuilding()
				local sHeroName = hBuilding:GetUnitEntityName()
				hBuilding:ModifyTotalDamage(fDamage, iDamageType)
			end
		end
	end
end
--事件监听************************************************************************************************************************
--
function public:UpdateNetTables()
	-- CustomNetTables:SetTableValue("common", "player_buildings", self.tPlayerBuildings)
	CustomNetTables:SetTableValue("common", "player_buildings", PlayerBuildings:GetData())

	local tSetting = CustomNetTables:GetTableValue('common', 'settings')
	tSetting['BUILDING_UNIT_SIZE'] = BUILDING_UNIT_SIZE
	tSetting['BUILDING_OFFSET_X'] = BUILDING_OFFSET_X
	tSetting['BUILDING_OFFSET_Y'] = BUILDING_OFFSET_Y
	tSetting['SHOW_CAN_BUILDING_GRID'] = SHOW_CAN_BUILDING_GRID and 1 or 0
	tSetting['BuildingMapType'] = self.typeBuildingMap
	CustomNetTables:SetTableValue("common", "settings", tSetting)
end

function public:IsBuilding(unit)
	return IsValid(unit) and unit.GetBuilding ~= nil
end

--- 建塔
function public:PlaceBuilding(hero, name, location, angle)
	if not hero:IsAlive() then
		return false
	end

	local playerID = hero:GetPlayerOwnerID()

	--相同塔建造限制
	if not BUILD_SAME_TOWER then
		local bHasSame = false
		self:EachBuilding(playerID, function(hBuilding)
			if hBuilding:GetUnitEntityName() == name then
				bHasSame = true
				return true
			end
		end)
		if bHasSame then
			ErrorMessage(hero:GetPlayerOwnerID(), "dota_hud_error_has_same_tower")
			return false
		end
	end

	--建造数量上限
	if KeyValues.UnitsKv[name] ~= nil and KeyValues.UnitsKv[name].UnitLabel == "HERO" then
		if PlayerBuildings:GetPlayerCurBuildCount(playerID) >= PlayerBuildings:GetPlayerMaxBuildCount(playerID) then
			if PlayerBuildings:GetPlayerCurBuildCount(playerID) >= HERO_BUILDING_MAX_COUNT then
				ErrorMessage(hero:GetPlayerOwnerID(), "dota_hud_error_building_max")
			else
				ErrorMessage(hero:GetPlayerOwnerID(), "dota_hud_error_building_limit_reached")
			end
			return false
		end
	else
		if PlayerBuildings:GetPlayerCurBuildCount(playerID, "nonhero") >= PlayerBuildings:GetPlayerMaxBuildCount(playerID, "nonhero") then
			ErrorMessage(hero:GetPlayerOwnerID(), "dota_hud_error_building_limit_reached")
			return false
		end
	end

	angle = angle or BUILDING_ANGLE
	local building = NewBuilding(name, location, angle, hero)
	if building:IsHero() then
		PlayerBuildings:AddPlayerBuilding(playerID, building:GetUnitEntityIndex())
	else
		PlayerBuildings:AddPlayerBuilding(playerID, building:GetUnitEntityIndex(), "nonhero")
	end
	-- 落星特效
	local hUnit = building:GetUnitEntity()
	local iParticleID = ParticleManager:CreateParticle("particles/gameplay/hero_summon.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hUnit:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hUnit:EmitSound("Ability.Starfall")
	hUnit:AddNoDraw()
	hUnit:GameTimer(0.25, function()
		hUnit:RemoveNoDraw()
		ScreenShake(hUnit:GetCenter(), 20, 12, 0.5, 6000, 0, true)
	end)

	self:UpdateNetTables()

	return building
end

function public:MoveBuilding(building, location)
	if not self:IsBuilding(building) then
		return
	else
		building = building:GetBuilding()
	end

	return building:Move(location)
end

function public:SellBuilding(building, fGoldReturn)
	if not self:IsBuilding(building) then
		return
	else
		building = building:GetBuilding()
	end

	---@class EventData_ON_TOWER_SELL
	local tEventData = {
		---@type Building
		hBuilding = building,
	}
	EventManager:fireEvent(ET_PLAYER.ON_TOWER_SELL, tEventData)

	-- fGoldReturn = fGoldReturn or (SELL_CARD_GOLD_PERCENT[building:GetStar()] or 100) * 0.01
	-- local iGoldCost = building:GetGoldCost()
	-- local iGoldReturn = math.floor(iGoldCost * fGoldReturn)
	local hOwner = building:GetOwner()
	local hBuilding = building:GetUnitEntity()
	local iPlayerID = hOwner:GetPlayerOwnerID()

	local tCardData = HeroCardData:UnitCardData(hBuilding)
	local iGoldReturn = HeroCardData:GetSellCardGold(iPlayerID, tCardData)

	PlayerData:ModifyGold(iPlayerID, iGoldReturn, false)

	local particleID = ParticleManager:CreateParticle("particles/items_fx/item_sheepstick.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particleID, 0, hBuilding:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particleID)

	EmitSoundOnLocationWithCaster(hBuilding:GetAbsOrigin(), "DOTA_Item.Sheepstick.Activate", hOwner)

	self:RemoveBuilding(building:GetUnitEntity())

	return iGoldReturn
end

function public:RemoveBuilding(building)
	if building.GetBuilding then
		building = building:GetBuilding()
	end

	local playerID = building:GetPlayerOwnerID()

	if building:IsHero() then
		PlayerBuildings:RemovePlayerBuilding(playerID, building:GetUnitEntityIndex(), "hero")
		-- ArrayRemove(self.tPlayerBuildings[playerID].hero.list, building:GetUnitEntityIndex())
	else
		PlayerBuildings:RemovePlayerBuilding(playerID, building:GetUnitEntityIndex(), "nonhero")
		-- ArrayRemove(self.tPlayerBuildings[playerID].nonhero.list, building:GetUnitEntityIndex())
	end

	EventManager:fireEvent(ET_PLAYER.ON_TOWER_DESTROY, {
		PlayerID = playerID,
		hBuilding = building,
	})

	building:RemoveSelf()

	self:UpdateNetTables()

	EventManager:fireEvent(ET_PLAYER.ON_TOWER_DESTROYED, {
		PlayerID = playerID,
		hBuilding = building,
	})

	building = nil
	collectgarbage()
end

function public:ReplaceBuilding(hUnit, sName)
	local building
	if not self:IsBuilding(hUnit) then
		return
	else
		building = hUnit:GetBuilding()
	end

	local playerID = building:GetPlayerOwnerID()
	local hUnit = building:GetUnitEntity()

	---替换物品
	local tItems = {}
	for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
		local hItem = hUnit:GetItemInSlot(i)
		if hItem and hItem.tItemData then
			table.insert(tItems, {
				iItemID = hItem.tItemData.iItemID,
				iSlot = i
			})
			Items:ItemTake(playerID, hItem.tItemData.iItemID)
		end
	end

	if building:IsHero() then
		PlayerBuildings:RemovePlayerBuilding(playerID, building:GetUnitEntityIndex(), "hero")
		-- ArrayRemove(self.tPlayerBuildings[playerID].hero.list, building:GetUnitEntityIndex())
	else
		PlayerBuildings:RemovePlayerBuilding(playerID, building:GetUnitEntityIndex(), "nonhero")
		-- ArrayRemove(self.tPlayerBuildings[playerID].nonhero.list, building:GetUnitEntityIndex())
	end

	hUnit = building:Replace(sName, true)

	if building:IsHero() then
		PlayerBuildings:AddPlayerBuilding(playerID, building:GetUnitEntityIndex())
		-- table.insert(self.tPlayerBuildings[playerID].hero.list, building:GetUnitEntityIndex())
	else
		PlayerBuildings:AddPlayerBuilding(playerID, building:GetUnitEntityIndex(), "nonhero")
		-- table.insert(self.tPlayerBuildings[playerID].nonhero.list, building:GetUnitEntityIndex())
	end

	for _, t in ipairs(tItems) do
		Items:ItemGive(playerID, t.iItemID, hUnit, t.iSlot)
	end

	self:UpdateNetTables()

	BuildSystem:UpdataBuildingAbilityTag(playerID)

	return hUnit
end

function public:UpgradeBuilding(building, upgradeAgent, iXP)
	if not self:IsBuilding(building) then
		return
	else
		building = building:GetBuilding()
	end

	if not building:CanUpgrade() then
		return false
	end
	local xp = iXP or 1
	if self:IsBuilding(upgradeAgent) then
		building:GetUnitEntity():EmitSound("Hero_DoomBringer.DevourCast")
		upgradeAgent:EmitSound("Hero_DoomBringer.Devour")

		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_CUSTOMORIGIN, building:GetUnitEntity())
		ParticleManager:SetParticleControlEnt(particleID, 0, upgradeAgent, PATTACH_POINT_FOLLOW, "attach_hitloc", upgradeAgent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particleID, 1, building:GetUnitEntity(), PATTACH_POINT_FOLLOW, "attach_hitloc", building:GetUnitEntity():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particleID)

		upgradeAgent = upgradeAgent:GetBuilding()

		xp = upgradeAgent:GetCurrentXP() + xp
		self:RemoveBuilding(upgradeAgent:GetUnitEntity())
	elseif upgradeAgent.IsItem ~= nil and upgradeAgent:IsItem() then
		building:GetUnitEntity():EmitSound("Item.TomeOfKnowledge")
		upgradeAgent:RemoveSelf()
	end
	building:AddXP(xp)

	self:UpdateNetTables()
end

---@param building Building
function public:AddExperience(building, upgradeAgent, iXP)
	if not self:IsBuilding(building) then
		return
	else
		building = building:GetBuilding()
	end

	building:AddXP(iXP or 1)
end

function public:ValidPosition(size, location, iTeamID, typeBuildingMap)
	local halfSide = (size / 2) * BUILDING_UNIT_SIZE - 1
	local leftBorderX = location.x - halfSide
	local rightBorderX = location.x + halfSide
	local topBorderY = location.y + halfSide
	local bottomBorderY = location.y - halfSide

	local function check(tBlockers, iTeamID, typeBuildingMap)
		for blockerEntIndex, blocker in pairs(tBlockers) do

			--验证队伍
			if iTeamID then
				local iTeamID2 = blocker:Attribute_GetIntValue('TeamID', -1)
				if - 1 ~= iTeamID2 and iTeamID ~= iTeamID2 then
					goto continue
				end
			end

			--验证建造区域
			if typeBuildingMap then
				local typeBuildingMap2 = blocker:Attribute_GetIntValue('BuildingMapType', BUILDING_MAP_TYPE.BASE)
				if typeBuildingMap ~= typeBuildingMap2 then
					goto continue
				end
			end

			--验证范围
			if IsPointInPolygon(location, blocker.polygon)
			-- and IsPointInPolygon(Vector(leftBorderX, bottomBorderY, 0), blocker.polygon)
				-- and IsPointInPolygon(Vector(rightBorderX, bottomBorderY, 0), blocker.polygon)
				-- and IsPointInPolygon(Vector(rightBorderX, topBorderY, 0), blocker.polygon)
				-- and IsPointInPolygon(Vector(leftBorderX, topBorderY, 0), blocker.polygon)
				then
				-- ShowPos(blocker.polygon[1], blocker.polygon[2], blocker.polygon[3], blocker.polygon[4])
				return true
			end

			:: continue ::
		end
		return false
	end

	if 0 < TableCount(self.hAllowable) then
		--建筑区域限制，不在许可范围内
		if not check(self.hAllowable, iTeamID, typeBuildingMap) then
			return false
		end
	end

	-- 已建造区域检测
	if check(self.hBlockers) then
		--禁止建造
		return false
	end

	return true
end

---获取某地块位置的建筑单位
---@return Building
function public:GetBuildingByPos(vPos)
	for blockerEntIndex, blocker in pairs(self.hBlockers) do
		local hBlocker = EntIndexToHScript(blockerEntIndex)
		if IsValid(hBlocker) and hBlocker.hBuilding then
			--验证范围
			if IsPointInPolygon(vPos, blocker.polygon) then
				return hBlocker.hBuilding
			end
		end
	end
end
---按entid获取建筑单位
---@return Building
function BuildSystem:GetBuildingByEntID(iEntID)
	local h = EntIndexToHScript(iEntID)
	if h and h.GetBuilding then
		return h:GetBuilding()
	end
end

function public:GridNavSquare(size, location)
	SnapToGrid(size, location)

	local halfSide = (size / 2) * BUILDING_UNIT_SIZE

	return {
		Vector(location.x - halfSide, location.y - halfSide, 0),
		Vector(location.x + halfSide, location.y - halfSide, 0),
		Vector(location.x + halfSide, location.y + halfSide, 0),
		Vector(location.x - halfSide, location.y + halfSide, 0),
	}
end

function public:CreateAllowable(polygon, allowable)
	allowable = allowable or SpawnEntityFromTableSynchronous("info_target", { origin = Vector(0, 0, 0) })

	allowable.polygon = polygon
	CustomNetTables:SetTableValue("build_allowable", tostring(allowable:entindex()), {
		polygon = Polygon2D(polygon),
		team_id = allowable:Attribute_GetIntValue('TeamID', -1),
		building_map_type = allowable:Attribute_GetIntValue('BuildingMapType', BUILDING_MAP_TYPE.BASE),
	})
	self.hAllowable[allowable:entindex()] = allowable

	return allowable
end

function public:CreateBlocker(polygon, blocker)
	blocker = blocker or SpawnEntityFromTableSynchronous("info_target", { origin = Vector(0, 0, 0) })

	blocker.polygon = polygon
	CustomNetTables:SetTableValue("build_blocker", tostring(blocker:entindex()), {
		polygon = Polygon2D(polygon),
		team_id = blocker:Attribute_GetIntValue('TeamID', -1),
		building_map_type = blocker:Attribute_GetIntValue('BuildingMapType', BUILDING_MAP_TYPE.BASE),
	})
	self.hBlockers[blocker:entindex()] = blocker

	return blocker
end

function public:RemoveBlocker(blocker)
	CustomNetTables:SetTableValue("build_blocker", tostring(blocker:entindex()), nil)
	self.hBlockers[blocker:entindex()] = nil

	blocker:RemoveSelf()
end

function public:GetBlockerPolygon(blocker)
	return blocker.polygon
end

function public:SetBlockerPolygon(blocker, polygon)
	blocker.polygon = polygon
	CustomNetTables:SetTableValue("build_blocker", tostring(blocker:entindex()), {
		polygon = Polygon2D(polygon),
		team_id = blocker:Attribute_GetIntValue('TeamID', -1),
		building_map_type = blocker:Attribute_GetIntValue('BuildingMapType', BUILDING_MAP_TYPE.BASE),
	})
end
--- **遍历玩家建筑[通用]**
--- @param iPlayerID number | function 必须参数 玩家id | function
--- @param func function f `function(hBuilding, iPlayerID, iEntIndex)` 返回 `true` 停止遍历
function public:EachBuilding(iPlayerID, func)
	PlayerBuildings:EachBuilding(iPlayerID, func)
end
--- 遍历玩家英雄建筑 `function(hBuilding, iPlayerID, iEntIndex)` 返回 `true` 停止遍历
--- @param iPlayerID number
--- @param func function
function public:EachHeroBuilding(iPlayerID, func)
	PlayerBuildings:EachHeroBuilding(iPlayerID, func)
end
function public:EachNonheroBuilding(iPlayerID, func)
	PlayerBuildings:EachNonheroBuilding(iPlayerID, func)
end

--将玩家传送到对应关卡区域地图
function public:MoveBuildingToMap(iPlayerID, typeBuildingMap)
	local tMapPoints_To = self.tMapPoints[typeBuildingMap]

	DotaTD:EachPlayer(function(_, _iPlayerID)
		if not iPlayerID or _iPlayerID == iPlayerID then
			local iTeam = PlayerData:GetPlayerTeamID(_iPlayerID)
			local hMapPoint_To = tMapPoints_To[iTeam]

			--移动主角
			local hHero = PlayerResource:GetSelectedHeroEntity(_iPlayerID)
			if IsValid(hHero) and hHero.typeBuildingMap ~= typeBuildingMap then
				hHero.typeBuildingMap = typeBuildingMap
				hHero:SetAbsOrigin(hMapPoint_To:GetAbsOrigin())
				hHero:GameTimer(3, function()
					hHero:SetAbsOrigin(hMapPoint_To:GetAbsOrigin() + Vector(-750, -850, 96))
					return
				end)
			end

			--移动建筑单位
			local tRandomBuilding = {}
			---@param hBuilding Building
			self:EachBuilding(_iPlayerID, function(hBuilding)
				if hBuilding.typeBuildingMap ~= typeBuildingMap then
					local hUnit = hBuilding:GetUnitEntity()
					if not IsValid(hUnit) then return end

					hUnit:SetForwardVector(hMapPoint_To:GetForwardVector())

					if not hBuilding.MapPosRecord then hBuilding.MapPosRecord = {} end

					local vPos

					if typeBuildingMap == BUILDING_MAP_TYPE.BOSS and hBuilding.typeBuildingMap == BUILDING_MAP_TYPE.BASE then
						--记录去Boss棋盘前的Base棋盘位置
						hBuilding.MapPosRecord[hBuilding.typeBuildingMap] = hBuilding.vLocation
					elseif typeBuildingMap == BUILDING_MAP_TYPE.BASE and hBuilding.typeBuildingMap == BUILDING_MAP_TYPE.BOSS then
						--从Boss棋盘回到Base棋盘位置
						vPos = hBuilding.MapPosRecord[typeBuildingMap]
						if not vPos then
							--无记录的棋子在最后随机一个位置
							table.insert(tRandomBuilding, hBuilding)
							return
						end
					end

					if not vPos then
						local tMapPoints_Cur = self.tMapPoints[hBuilding.typeBuildingMap]
						local hMapPoint_Cur = tMapPoints_Cur[iTeam]

						local vDir = hBuilding.vLocation - hMapPoint_Cur:GetAbsOrigin()
						local fAge = hMapPoint_Cur:GetAnglesAsVector().y
						local fAge2 = hMapPoint_To:GetAnglesAsVector().y

						local fRotationAge = (fAge2 - fAge + 360) % 360
						vDir = Rotation2D(vDir, math.rad(fRotationAge))

						vPos = hMapPoint_To:GetAbsOrigin() + vDir
						vPos = GetGroundPosition(vPos, hUnit)
					end

					hBuilding:Move(vPos, typeBuildingMap)
				end
			end)
			--移动需要随机位置的单位
			for _, hBuilding in pairs(tRandomBuilding) do
				local vPos = self:GetRandomBuildingPos(iTeam, typeBuildingMap) or hMapPoint_To:GetAbsOrigin()
				hBuilding:Move(vPos, typeBuildingMap)
			end


			-- 切换队伍
			if typeBuildingMap == BUILDING_MAP_TYPE.BASE then
				ChangePlayerTeam(_iPlayerID, DOTA_TEAM_CUSTOM_1 + _iPlayerID)
			elseif typeBuildingMap == BUILDING_MAP_TYPE.BOSS then
				ChangePlayerTeam(_iPlayerID, DOTA_TEAM_GOODGUYS)
			end
		end
	end)

	BuildSystem:UpdateNetTables()
end

--获取随机可建造位置
function public:GetAllBuildingPos(iTeamID, typeBuildingMap)
	local tPos = {}

	for blockerEntIndex, blocker in pairs(self.hAllowable) do
		--验证队伍
		if iTeamID then
			local iTeamID2 = blocker:Attribute_GetIntValue('TeamID', -1)
			if - 1 ~= iTeamID2 and iTeamID ~= iTeamID2 then
				goto continue
			end
		end
		--验证建造区域
		if typeBuildingMap then
			local typeBuildingMap2 = blocker:Attribute_GetIntValue('BuildingMapType', BUILDING_MAP_TYPE.BASE)
			if typeBuildingMap ~= typeBuildingMap2 then
				goto continue
			end
		end

		-- ShowPos(blocker.polygon[1], blocker.polygon[2], blocker.polygon[3], blocker.polygon[4])
		local tX = {}
		local tY = {}
		for _, vPos in pairs(blocker.polygon) do
			table.insert(tX, vPos.x)
			table.insert(tY, vPos.y)
		end
		removeRepeat(tX)
		table.sort(tX, function(a, b) return a > b end)
		removeRepeat(tY)
		table.sort(tY, function(a, b) return a > b end)

		local vMax = Vector(tX[1], tY[1])
		local vMin = Vector(tX[2], tY[2])
		local vLength = vMax - vMin
		--记录全部点
		for y = 0, vLength.y / BUILDING_UNIT_SIZE do
			for x = 0, vLength.x / BUILDING_UNIT_SIZE do
				local vPos = Vector(vMin.x, vMin.y, 0) + Vector(x * BUILDING_UNIT_SIZE, y * BUILDING_UNIT_SIZE, 0)
				SnapToGrid(BUILDING_SIZE, vPos)
				if BuildSystem:ValidPosition(BUILDING_SIZE, vPos, iTeamID, typeBuildingMap) then
					vPos = GetGroundPosition(vPos, nil)
					table.insert(tPos, vPos)
				end
			end
		end

		:: continue ::
	end

	removeRepeat(tPos)
	table.sort(tPos, function(a, b)
		if a.y < b.y then
			return true
		elseif a.y == b.y then
			return a.x < b.x
		end
	end)

	-- for k, vPos in pairs(tPos) do
	-- 	local kk = tonumber(k)
	-- 	local a = vPos + Vector(25, 25, 0)
	-- 	local b = vPos + Vector(25, -25, 0)
	-- 	local c = vPos + Vector(-25, -25, 0)
	-- 	local d = vPos + Vector(-25, 25, 0)
	-- 	GameTimer(0.25 * k, function()
	-- 		DebugDrawLine(a, b, 255, 255, 255, true, 10)
	-- 		DebugDrawLine(b, c, 255, 255, 255, true, 10)
	-- 		DebugDrawLine(c, d, 255, 255, 255, true, 10)
	-- 		DebugDrawLine(d, a, 255, 255, 255, true, 10)
	-- 	end)
	-- end
	return tPos
end
--获取随机可建造位置
function public:GetRandomBuildingPos(iTeamID, typeBuildingMap)
	local tPos = self:GetAllBuildingPos(iTeamID, typeBuildingMap)
	return tPos[1]
end

-- 更新所有单位的技能
function public:UpdataBuildingAbilityTag(iPlayerID)
	local tTagInfo = {}
	public:EachBuilding(iPlayerID, function(hBuilding)
		local hUnit = hBuilding:GetUnitEntity()
		for iIndex = 0, 7 do
			local hAbility = hUnit:GetAbilityByIndex(iIndex)
			if IsValid(hAbility) then
				local sAbilityName = hAbility:GetAbilityName()
				local sTag = DotaTD:GetAbilityTag(sAbilityName)	--技能标签
				local iModifyActiveCount = GetModifyFettersActiveCount(iPlayerID, sTag) or 0
				local iActiveCount = DotaTD:GetAbilityTagActiveCount(sAbilityName) + iModifyActiveCount	-- 技能激活所需羁绊数量
				if sTag ~= "" and iActiveCount ~= -1 then
					if tTagInfo[sTag] == nil then
						tTagInfo[sTag] = {
							tAbility = {},
							iMinLevel = 100
						}
					end
					table.insert(tTagInfo[sTag].tAbility, hAbility)	--记录技能
					tTagInfo[sTag].iMinLevel = math.min(tTagInfo[sTag].iMinLevel, hUnit:GetLevel())	-- 记录最低的单位等级
				end
			end
		end
	end)
	-- 设置所有tag技能等级
	for sTag, tInfo in pairs(tTagInfo) do
		for _, hAbility in ipairs(tInfo.tAbility) do
			local sAbilityName = hAbility:GetAbilityName()

			local bUnlock = false

			local iLockState = GetTagAbltLockState(iPlayerID, sTag, sAbilityName)

			if 2 == iLockState then
				-- 强制不解锁
			elseif 1 == iLockState then
				-- 强制解锁
				bUnlock = true
			else
				local iModifyActiveCount = GetModifyFettersActiveCount(iPlayerID, sTag) or 0
				if #tInfo.tAbility >= DotaTD:GetAbilityTagActiveCount(sAbilityName) + iModifyActiveCount then
					--满足羁绊数量
					bUnlock = true
				end
			end


			if bUnlock then
				-- 解锁
				local iLevel = hAbility:GetCaster():GetLevel()
				if hAbility:GetLevel() < iLevel then
					local tPtclName = {
						'particles/prime/hero_spawn_hero_level_1_delay.vpcf',
						'particles/prime/hero_spawn_hero_level_2_delay.vpcf',
						'particles/prime/hero_spawn_hero_level_3_delay.vpcf',
						'particles/prime/hero_spawn_hero_level_4_delay.vpcf',
						'particles/prime/hero_spawn_hero_level_5_delay.vpcf',
					}
					local iParticleID = ParticleManager:CreateParticle(tPtclName[iLevel], PATTACH_ABSORIGIN_FOLLOW, hAbility:GetCaster())
					ParticleManager:ReleaseParticleIndex(iParticleID)
				end
				hAbility:SetLevel(iLevel)
				hAbility.bTagActive = true
			else
				if hAbility:GetLevel() > 0 then
					local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_drop.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAbility:GetCaster())
					ParticleManager:ReleaseParticleIndex(iParticleID)
				end
				hAbility:SetLevel(0)
				hAbility.bTagActive = false
			end
		end
	end

	---@class EventData_TowerAbilityUpdate
	local tEventData = {
		PlayerID = iPlayerID,
	}
	EventManager:fireEvent(ET_PLAYER.ON_TOWER_ABILITY_UPDATE, tEventData)
end

-- 将建筑返回手牌
function public:BuildingToCard(iPlayerID, hUnit, bSell)
	if hUnit and self:IsBuilding(hUnit) then
		local hBuilding = hUnit:GetBuilding()
		local tCardData = HeroCardData:AddCardByUnit(iPlayerID, hUnit)
		if tCardData then
			EventManager:fireEvent(ET_PLAYER.ON_TOWER_TO_CARD, {
				hBuilding = hBuilding,
				tCardData = tCardData,
			})
			self:RemoveBuilding(hUnit)
			return
		end
		if bSell then
			self:SellBuilding(hUnit)
		else
			hUnit:RemoveModifierByName('modifier_building_move')
			hBuilding:Move(hBuilding.vLocation)
		end
	end
end

function Vector2D(vector)
	return { x = vector.x, y = vector.y }
end

function Polygon2D(polygon)
	local new = {}
	for k, v in pairs(polygon) do
		new[k] = Vector2D(v)
	end
	return new
end

function SnapToGrid(size, location)
	location.x = location.x - BUILDING_OFFSET_X
	location.y = location.y - BUILDING_OFFSET_Y

	-- if size % 2 ~= 0 then
	-- 	location.x = SnapToGrid32(location.x)
	-- 	location.y = SnapToGrid32(location.y)
	-- else
	-- 	location.x = SnapToGrid64(location.x)
	-- 	location.y = SnapToGrid64(location.y)
	-- end
	location.x = SnapToGridCustom(location.x)
	location.y = SnapToGridCustom(location.y)

	location.x = location.x + BUILDING_OFFSET_X
	location.y = location.y + BUILDING_OFFSET_Y

end

function SnapToGridCustom(coord)
	return BUILDING_UNIT_SIZE * math.floor(0.5 + coord / BUILDING_UNIT_SIZE)
end

function SnapToGrid64(coord)
	return 64 * math.floor(0.5 + coord / 64)
end

function SnapToGrid32(coord)
	return 32 + 64 * math.floor(coord / 64)
end



----------------------------------------------------------------------------------------------------
-- 注册修改器
---获取玩家羁绊技能的锁定状态
---@return number 锁定状态 0:按羁绊数量正常解锁，1:强制解锁，2:强制不解锁
function GetTagAbltLockState(iPlayerID, sTagName, sAbltName)
	local iState = 0
	local iLevel
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_TAG_ABLT_LOCK_STATE, iPlayerID, sTagName, sAbltName)) do
		local iStateCur = tVals[1] or 0
		local iLevelCur = tVals[2] or 0
		if nil == iLevel or iLevel < iLevelCur then
			iState = iStateCur
			iLevel = iLevelCur
		end
	end
	return iState
end
if not EModifier:HasModifier(EMDF_TAG_ABLT_LOCK_STATE) then EModifier:CreateModifier(EMDF_TAG_ABLT_LOCK_STATE) end
-- EModifier:RegModifierKeyVal(EMDF_TAG_ABLT_LOCK_STATE, 'aaa', function(iPlayerID, sTagName, sAbltName)
-- 	if iPlayerID == then
-- 			if 'gunner' == sTagName then
-- 					return 1
-- 			end
-- 	end
-- end)
return public