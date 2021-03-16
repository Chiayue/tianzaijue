if Commander == nil then
	---@class Commander
	Commander = {
		tTowers = {}, --防御塔 npc_dota_tower
		tBossTowers = {}, --（BOSS区域）防御塔 npc_dota_tower
		tCommanders = {}, --指挥官实体
		tBirhplaceCommanders = {}, --指挥官(营地)实体

		--
		-- 当前指挥官id
		tCommanderIDs = {},

		tTalentData = {},
	}
end
---@type Commander
local public = Commander

function public:init(bReload)
	if not bReload then
		self.tCommanders = {}
		self.tBirhplaceCommanders = {}
		self.tCommanderIDs = {
			1030001,
			1030002,
			1030003,
			1030004,
			1030005,
			1030006,
			1030007,
			1030008,
			1030009,
			1030010,
			1030011,
			1030012,
		}
	end

	--防御塔坐标
	self.tTowers = {}
	for iTeam, hPoint in pairs(Spawner.tTeamMapPoints) do
		local hTower = Entities:FindByNameLike(nil, 'commander_' .. iTeam)
		self.tTowers[iTeam] = hTower
	end
	self.tBossTowers = {}
	for iTeam, hPoint in pairs(Spawner.tTeamMapPoints) do
		local hTower = Entities:FindByNameLike(nil, 'commander_boss_' .. iTeam)
		self.tBossTowers[iTeam] = hTower
	end

	EventManager:register(ET_PLAYER.LEVEL_CHANGED, 'OnLevelChanged', self)
	EventManager:register(ET_PLAYER.ON_LOADED_FINISHED, 'OnLoadedFinished', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_GAME.DIFFICULTY_CHANGE, 'OnDifficultyChange', self)
	EventManager:register(ET_GAME.GAME_BEGIN, 'OnGameBegin', self)
	EventManager:register(ET_GAME.NPC_SPAWNED, 'OnNpcSpawned', self, EVENT_LEVEL_ULTRA)
	EventManager:register('EomDebug_PlayerChat', 'OnPlayerChatDebug', self)

	CustomUIEvent("UI_SetCommander", Dynamic_Wrap(self, "Set_Commander"), self)

	Request:Event("commander.talent_level_up", Dynamic_Wrap(public, "ReqTalentLevelUp"), public)
	Request:Event("commander.talent_reset", Dynamic_Wrap(public, "ReqTalentReset"), public)

	for i = PlayerData:GetPlayerMaxCount() - 1, 0, -1 do
		local iPlayerID = i
		-- 更新天赋
		NetEventData:Bind(function()
			self:SetCommanderTalent(iPlayerID)
		end, 'service', 'player_commander_talent_' .. iPlayerID, 'CommanderUpdateTalent' .. iPlayerID)
	end

	self:UpdateNetTables()
end

--UI事件************************************************************************************************************************
	do
	function public:OnPlayerChatDebug(iPlayerID, tokens)
		if tokens[1] == '-addcmdtalent' then
			Service:POST('commander.add', {
				uid = GetAccountID(iPlayerID),
				sid = tokens[2],
			}, function(data) DeepPrintTable(data) end)
		end
	end
	---设置指挥官
	function public:Set_Commander(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local cmd_name = events.cmd_name
		if GSManager:getStateType() == GS_Ready then
			self:SetCommander(iPlayerID, cmd_name)
			self:SetCommanderToBirhplace(iPlayerID, cmd_name)
		end
	end
end
--事件监听************************************************************************************************************************
	do
	-- 进入游戏
	function public:OnGameBegin()
		--清除营地的指挥官
		Commander:DelCommanderToBirhplace()
	end

	---玩家加载完成
	function public:OnLoadedFinished(tEvent)
		local iPlayerID = tEvent.PlayerID
	end

	---游戏难度更换
	---@param tEvent EventData_DIFFICULTY_CHANGE
	function public:OnDifficultyChange(tEvent)
	end

	---玩家升级
	function public:OnLevelChanged(tEvent)
		local iPlayerID = tEvent.PlayerID
		local iChange = tEvent.iChange
		local hCommander = self:GetCommander(iPlayerID)
		if IsValid(hCommander) then

			---@class EventData_PlayerCommanderLevelup
			local tData = {
				PlayerID = iPlayerID,
				iLevel = hCommander:GetLevel() + 1,
				iLastLevel = hCommander:GetLevel(),
			}
			EventManager:fireEvent(ET_PLAYER.ON_COMMANDER_LEVELUP, tData)

			local hAbleLevel = {}
			for i = 0, hCommander:GetAbilityCount() - 1 do
				local hAblt = hCommander:GetAbilityByIndex(i)
				if hAblt then
					hAbleLevel[hAblt] = hAblt:GetLevel()
				end
			end
			hCommander:CreatureLevelUp(iChange)
			for hAblt, iLevel in pairs(hAbleLevel) do
				if IsValid(hAblt) then
					hAblt:SetLevel(iLevel)
				end
			end

			hCommander:AddNewModifier(hCommander, nil, 'modifier_commander', nil)

			local iParticleID = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCommander)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end

	function public:OnNpcSpawned(tData)
		local hUnit = EntIndexToHScript(tData.entindex)
		if not IsValid(hUnit) then return end

		if LOCK_CREATE_UNIT_COMMANDER then
			LOCK_CREATE_UNIT_COMMANDER(hUnit)
		end
	end
end
--后台请求************************************************************************************************************************
	do
	---指挥官天赋
	function public:ReqTalentLevelUp(events)
		local iPlayerID = events.PlayerID
		local sTalentName = events.sTalentName

		local sCmd = self:GetCommanderByTalent(sTalentName)
		if sCmd == '' then return end
		local sCmdID = self:GetCommanderID(sCmd)
		if not sCmdID then return end
		local sTalentOrderID = self:GetCommanderTalentIDByName(sTalentName)
		if not sTalentOrderID then return end

		--剩余点
		local iTalentPoint = 0
		local tCmdTalentPoints = NetEventData:GetTableValue('service', 'player_commander_talent_point_' .. iPlayerID)
		if tCmdTalentPoints and tCmdTalentPoints[sCmdID] then
			iTalentPoint = tonumber(tCmdTalentPoints[sCmdID]) or 0
		end
		-- 天赋点不足
		if 1 > iTalentPoint then
			return '#error_talent_point_not_enough'
		end

		-- 已经消耗
		local iTalentUsePoint = 0
		local tTalents = self:GetPlayerTalents(iPlayerID)[sCmdID]
		if tTalents then
			-- 判断等级已满
			local iMaxLevel = self:GetCommanderTalentMaxLevelByName(sTalentName)
			if (tTalents[sTalentOrderID] or 0) >= iMaxLevel then
				return 'error_already_max_level'
			end
			for _, iCount in pairs(tTalents) do
				iTalentUsePoint = iTalentUsePoint + (tonumber(iCount) or 0)
			end
		end

		-- 前置技能点消耗门槛
		local tAbltKV = KeyValues.CmdAbilitiesKv[sTalentName]
		local NeedUseCount = tonumber(tAbltKV.NeedUseCount) or 0
		if iTalentUsePoint < NeedUseCount then
			return '#error_need_use_point_count'
		end

		local tData = {
			uid = GetAccountID(iPlayerID),
			--指挥官 id
			sid = sCmdID,
			--天赋 unique id
			oid = self:GetCommanderTalentIDByName(sTalentName),
		}
		local data = Service:POSTSync('commander.talent_level_up', tData)
		return data
	end
	---重置指挥官天赋
	function public:ReqTalentReset(events)
		local iPlayerID = events.PlayerID
		local sCmdID = tostring(events.cmd_id)
		if not sCmdID then return end

		-- 已经消耗
		local iTalentUsePoint = 0
		local tTalents = self:GetPlayerTalents(iPlayerID)[sCmdID]
		if tTalents then
			for _, iCount in pairs(tTalents) do
				iTalentUsePoint = iTalentUsePoint + (tonumber(iCount) or 0)
			end
		end
		if iTalentUsePoint <= 0 then
			return 'error_talent_reset_not_need'
		end

		local tData = {
			uid = GetAccountID(iPlayerID),
			--指挥官 id
			sid = sCmdID,
		}
		local data = Service:POSTSync('commander.talent_reset', tData)
		return data
	end
end
--后台请求************************************************************************************************************************
--
---更新网表
function public:UpdateNetTables()
end

---获取玩家指挥官天赋数据
function public:GetPlayerTalents(iPlayerID)
	local tTalents = NetEventData:GetTableValue('service', 'player_commander_talent_' .. iPlayerID) or {}
	return tTalents
end
---初始化玩家指挥官信息
function public:InitPlayerInfo(iPlayerID)
end

---初始化玩家指挥官单位
function public:InitPlayerCommander(iPlayerID)
	local sCommander

	local tData = NetEventData:GetTableValue('service', 'player_using_' .. iPlayerID)
	if tData and tData.commander then
		sCommander = self:GetCommanderNameByID(tostring(tData.commander))
	end

	if not sCommander or sCommander == '' then
		sCommander = 'cmd_beginner'
	end

	self:SetCommander(iPlayerID, sCommander)
	self:SetCommanderToBirhplace(iPlayerID, sCommander)
end
--- 获取玩家信息：拥有的全部指挥官等(待修改.sname已不存在)
function public:GetPlayerInfos(call, iPlayerID)
end

---获取防御塔
function public:GetTower(iPlayerID)
	local iTeamID = PlayerData:GetPlayerTeamID(iPlayerID)
	if self.tTowers[iTeamID] then
		return self.tTowers[iTeamID]
	end
end
---获取指挥官
function public:GetCommander(iPlayerID)
	if self.tCommanders[iPlayerID] then
		return self.tCommanders[iPlayerID][1]
	end
end
---获取选择的指挥官ID
function public:GetChloseCommanderID(iPlayerID)
	local hCmd = self:GetCommander(iPlayerID)
	if IsValid(hCmd) then
		return self:GetCommanderID(hCmd:GetUnitName())
	end
end

--- 更换指挥官
function public:SetCommander(iPlayerID, sCommander)
	local hTower = self:GetTower(iPlayerID)
	if not IsValid(hTower) then return end

	local hHero = PlayerData:GetHero(iPlayerID)
	if not IsValid(hHero) then return end

	--移除旧指挥官
	self:DelCommander(iPlayerID)

	LOCK_CREATE_UNIT_COMMANDER = function(hUnit)
		hUnit:SetOwner(hHero)
		hUnit:SetForwardVector(hTower:GetForwardVector())
		hUnit:SetUnitCanRespawn(true)

		--设置等级
		local iLevel = PlayerData:GetPlayerLevel(iPlayerID)
		if 1 < iLevel then
			hUnit:CreatureLevelUp(iLevel - 1)
		end

		-- 注册属性
		Attributes:Register(hUnit)
		hUnit:AddNewModifier(hUnit, nil, 'modifier_commander', nil)

		if not self.tCommanders[iPlayerID] then self.tCommanders[iPlayerID] = {} end
		table.insert(self.tCommanders[iPlayerID], hUnit)
	end

	--生成新指挥官
	local hCommander = CreateUnitByName(sCommander, hTower:GetAbsOrigin(), false, hHero, hHero, hHero:GetTeamNumber())
	LOCK_CREATE_UNIT_COMMANDER = nil
	---@class EventData_ON_COMMANDER_SPAWNED
	local tEvent = {
		PlayerID = iPlayerID,
		hCommander = hCommander,
	}
	EventManager:fireEvent(ET_PLAYER.ON_COMMANDER_SPAWNED, tEvent)

	-- 给指挥官注册天赋属性
	self:SetCommanderTalent(iPlayerID)
end

--- 重置指挥官
function public:ResetUnitOnBattleEnd(iPlayerID)
	if self.tCommanders[iPlayerID] then
		for _, hCommander in pairs(self.tCommanders[iPlayerID]) do
			if hCommander:IsAlive() then
				hCommander:SetHealth(hCommander:GetMaxHealth())
				hCommander:SetMana(hCommander:GetMaxMana())
				for i = 0, hCommander:GetAbilityCount() - 1 do
					local hAblt = hCommander:GetAbilityByIndex(i)
					if hAblt then
						hAblt:EndCooldown()
					end
				end
			else
				-- 重新创建指挥官
				self:SetCommander(iPlayerID, hCommander:GetUnitName())
				return
				-- 复活指挥官
				-- hCommander:RespawnUnit()
			end
			local hTower = self:GetTower(iPlayerID)
			if IsValid(hTower) then
				hCommander:SetAbsOrigin(hTower:GetAbsOrigin())
				hCommander:SetForwardVector(hTower:GetForwardVector())
			end
		end
	end
end
function public:ResetUnitOnPreparation()
	for iPlayerID, t in pairs(self.tCommanders) do
		local hCommander = self:GetCommander(iPlayerID)
		if IsValid(hCommander) then
			if hCommander:IsAlive() then
				hCommander:SetHealth(hCommander:GetMaxHealth())
				hCommander:SetMana(hCommander:GetMaxMana())
				for i = 0, hCommander:GetAbilityCount() - 1 do
					local hAblt = hCommander:GetAbilityByIndex(i)
					if hAblt then
						hAblt:EndCooldown()
					end
				end

				local hTower = self:GetTower(iPlayerID)
				if IsValid(hTower) then
					hCommander:SetAbsOrigin(hTower:GetAbsOrigin())
					hCommander:SetForwardVector(hTower:GetForwardVector())
				end
			else
				-- 重新创建指挥官
				self:SetCommander(iPlayerID, hCommander:GetUnitName())
			end
		end
	end
end

-- 移除指挥官
function public:DelCommander(iPlayerID)
	local hCommander = self:GetCommander(iPlayerID)
	if hCommander then
		hCommander:RemoveSelf()
		self.tCommanders[iPlayerID] = {}
	end
end

--是否指挥官或者防御塔
function IsCommanderTower(hUnit)
	return hUnit:HasModifier('modifier_commander') or hUnit:HasModifier('modifier_tower')
end

-- 给指挥官注册天赋属性
function public:SetCommanderTalent(iPlayerID)
	local tTalents = self:GetPlayerTalents(iPlayerID)
	if not tTalents then return end

	local hCommander = self:GetCommander(iPlayerID)
	if not IsValid(hCommander) then return end

	local sCmdName = hCommander:GetUnitName()
	local sCmdID = self:GetCommanderID(sCmdName)

	tTalents = tTalents[sCmdID] or {}

	-- 移除不存在的天赋技能
	for i = hCommander:GetAbilityCount() - 1, 0, -1 do
		local hAblt = hCommander:GetAbilityByIndex(i)
		if hAblt then
			local sTalentID = self:GetCommanderTalentIDByName(hAblt:GetAbilityName())
			if sTalentID and sTalentID ~= "" then
				if not tTalents[sTalentID] or 0 >= tTalents[sTalentID] then
					hCommander:RemoveAbilityByHandle(hAblt)
				end
			end
		end
	end

	-- 保存天赋数据
	self.tTalentData[iPlayerID] = {}

	-- 添加或升级新技能
	for sTalentID, iLevel in pairs(tTalents) do
		if iLevel ~= 0 then
			local i = string.sub(sTalentID, -1)
			local pAbilityName = tostring(sCmdName) .. '_' .. tostring(i)
			local hAblt = hCommander:FindAbilityByName(pAbilityName)
			table.insert(self.tTalentData[iPlayerID], {
				name = pAbilityName,
				level = iLevel
			})
			if hAblt then
				hAblt:SetLevel(iLevel)
			else
				local hhAblt = hCommander:AddAbility(pAbilityName)
				hhAblt:SetLevel(iLevel)
			end
		end
	end
end

-- 通过id获取指挥官名字
function public:GetCommanderNameByID(sCmdID)
	for sName, tData in pairs(KeyValues.CommanderKv) do
		if tostring(tData.ID) == sCmdID then
			return sName
		end
	end
	return ''
end
-- 通过名字获取指挥官id
function public:GetCommanderID(sCmdName)
	local tData = KeyValues.CommanderKv[sCmdName]
	if tData then
		return tostring(tData.ID)
	end
end
-- 通过名字获取指挥官天赋id
function public:GetCommanderTalentIDByName(sTalentName)
	for sName, tData in pairs(KeyValues.CmdAbilitiesKv) do
		if sName == sTalentName then
			return tostring(tData.OrderID)
		end
	end
	return ''
end
-- 通过天赋名获取对应指挥官
function public:GetCommanderByTalent(sTalentName)
	for sName, _ in pairs(KeyValues.CommanderKv) do
		if string.find(sTalentName, sName) then
			return sName
		end
	end
	return ''
end
-- 获取指挥官天赋最大等级
function public:GetCommanderTalentMaxLevelByName(sTalentName)
	for sName, tData in pairs(KeyValues.CmdAbilitiesKv) do
		if sName == sTalentName then
			return tData.MaxLevel
		end
	end
	return 0
end

-- 判断是否可以升级
function public:TestIfCouldBeUpgrade(iPlayerID, sCmdID, sTalentName)
	local sTalentUniqueID = self:GetCommanderTalentIDByName(sTalentName)
	if not sTalentUniqueID then return end

	local tTalents = self:GetPlayerTalents(iPlayerID)[sCmdID] or {}

	-- 判断等级已满
	local iMaxLevel = self:GetCommanderTalentMaxLevelByName(sTalentName)
	if (tTalents[sTalentUniqueID] or 0) >= iMaxLevel then
		return false, 'dota_hud_error_talent_reach_max_level'
	end

	-- 判断前置技能
	for sName, tData in pairs(KeyValues.CmdAbilitiesKv) do
		if sName == sTalentName then
			local sTalentsID = tData.PreTalentID
			if sTalentsID ~= 0 then
				local tPreTalentsIDs = string.split(sTalentsID, '|')
				for i = #tPreTalentsIDs, 1, -1 do
					if tPreTalentsIDs[i] ~= 0 then
						if not tTalents[tPreTalentsIDs[i]] or 0 >= tTalents[tPreTalentsIDs[i]] then
							ErrorMessage(iPlayerID, '')
							return false, 'dota_hud_error_talent_pretalents_limit'
						end
					end
				end
			end
		end
	end

	return true
end

--将指挥官传送到对应关卡区域地图
function public:MoveToMap(iPlayerID, typeBuildingMap)
	DotaTD:EachPlayer(function(_, _iPlayerID)
		if nil ~= iPlayerID and _iPlayerID ~= iPlayerID then return end
		if PlayerData:IsPlayerDeath(_iPlayerID) then return end

		local iTeam = PlayerData:GetPlayerTeamID(_iPlayerID)
		local hMapPoint_To = nil
		if typeBuildingMap == BUILDING_MAP_TYPE.BASE then
			hMapPoint_To = self.tTowers[iTeam]
		else
			hMapPoint_To = self.tBossTowers[iTeam]
		end
		if not IsValid(hMapPoint_To) then
			return
		end

		local hCmd = self:GetCommander(_iPlayerID)
		if IsValid(hCmd) then
			hCmd:SetAbsOrigin(hMapPoint_To:GetAbsOrigin())
			if typeBuildingMap == BUILDING_MAP_TYPE.BASE then
				hCmd:RemoveModifierByName('modifier_invincible')
			else
				hCmd:FaceTowards(Spawner.hBossMapPoint:GetAbsOrigin())
				hCmd:AddNewModifier(hCmd, nil, 'modifier_invincible', {})
			end
		end
	end)

	BuildSystem:UpdateNetTables()
end

--营地内的指挥官************************************************************************************************************************
	do

	---获取指挥官
	function public:GetCommanderToBirhplace(iPlayerID)
		if self.tBirhplaceCommanders[iPlayerID] then
			return self.tBirhplaceCommanders[iPlayerID][1]
		end
	end

	--- 更换营地内的指挥官
	function public:SetCommanderToBirhplace(iPlayerID, sCommander)
		local hHero = PlayerData:GetHero(iPlayerID)
		if not IsValid(hHero) then return end
		local hPointEnt = Birthplace.tCommanderPointEnts[iPlayerID]
		local hPlayerPointEnt = Birthplace.tPlayerPointEnts[iPlayerID]
		if not IsValid(hPointEnt) then return end

		-- 当前已经是这个指挥官
		local hUnitCur = self:GetCommanderToBirhplace(iPlayerID)
		if IsValid(hUnitCur) then
			if hUnitCur:GetUnitName() == sCommander then
				return
			end
		end

		--移除旧指挥官
		self:DelCommanderToBirhplace(iPlayerID)

		LOCK_CREATE_UNIT_COMMANDER = function(hUnit)
			hUnit:SetOwner(hHero)
			hUnit:SetForwardVector(hPointEnt:GetForwardVector())
			--设置等级
			local iLevel = PlayerData:GetPlayerLevel(iPlayerID)
			if 1 < iLevel then
				hUnit:CreatureLevelUp(iLevel - 1)
			end

			-- 注册属性
			Attributes:Register(hUnit)
			hUnit:AddNewModifier(hUnit, nil, 'modifier_commander_birthplace', nil)

			if not self.tBirhplaceCommanders[iPlayerID] then self.tBirhplaceCommanders[iPlayerID] = {} end
			table.insert(self.tBirhplaceCommanders[iPlayerID], hUnit)
		end

		--生成新指挥官
		local hCommander = CreateUnitByName(sCommander, hPointEnt:GetAbsOrigin(), false, hHero, hHero, hHero:GetTeamNumber())
		LOCK_CREATE_UNIT_COMMANDER = nil

		---@class EventData_ON_BIRTHPLACE_COMMANDER_SPAWNED
		local tEvent = {
			PlayerID = iPlayerID,
			hCommander = hCommander,
		}
		EventManager:fireEvent(ET_PLAYER.ON_BIRTHPLACE_COMMANDER_SPAWNED, tEvent)
	end

	-- 移除营地内指挥官
	function public:DelCommanderToBirhplace(iPlayerID)
		if nil == iPlayerID then
			-- 全部移除
			for _iPlayerID, _ in pairs(self.tBirhplaceCommanders) do
				local hCommander = self:GetCommanderToBirhplace(_iPlayerID)
				if IsValid(hCommander) then
					hCommander:RemoveSelf()
				end
			end
			self.tBirhplaceCommanders = {}
		else
			local hCommander = self:GetCommanderToBirhplace(iPlayerID)
			if IsValid(hCommander) then
				hCommander:RemoveSelf()
			end
			self.tBirhplaceCommanders[iPlayerID] = {}
		end
	end
end
--营地内的指挥官************************************************************************************************************************
return public