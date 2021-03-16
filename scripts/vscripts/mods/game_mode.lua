if GameMode == nil then
	---@class GameMode
	GameMode = {
	}
end
local public = GameMode

function public:init(bReload)
	if not bReload then
		--- 模式选择信息
		self.tGameModeInfo = {
			time = GAME_MODE_SELECTION_TIME,
			difficulty = DIFFICULTY_DEFAULT,
			endless_layer = 0,
		}

		--- 玩家激活码激活信息
		self.tPlayerActiveInfo = {}
	end

	CustomUIEvent('game_mode_active', self.OnPlayerActive, self)

	EventManager:register(ET_GAME.MODS_LOADOVER, 'OnModsLoadover', self)
end
--模块加成完成
function public:OnModsLoadover()
	self:SetDifficulty(self:GetDifficulty())
end
--- 初始化
function public:InitActiveInfo()
	DotaTD:EachPlayer(function(_, iPlayerID)
		local iPlayerID = tonumber(iPlayerID)
		self.tPlayerActiveInfo[iPlayerID] = (ENV == "RELEASE") or IsInToolsMode() or (not NEED_ACTIVE_CKD)
	end)
	self:UpdateNetTables()
end
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("common", "game_mode_info", self.tGameModeInfo)
	CustomNetTables:SetTableValue("common", "game_mode_active_info", self.tPlayerActiveInfo)
end
---设置游戏难度
function public:SetDifficulty(typeDifficulty)
	local sDifficultyPath = 'mods/difficulty/' .. typeDifficulty
	if LoadedMods and LoadedMods[sDifficultyPath] then
		LoadedMods['core/Settings']()
		LoadedMods[sDifficultyPath]()
	else
		package.loaded['core/Settings'] = nil
		require('core/Settings')
		package.loaded[sDifficultyPath] = nil
		require(sDifficultyPath)
	end
	Settings:init(true)

	---@class EventData_DIFFICULTY_CHANGE
	local tEventData = {
		typeDifficultyNew = typeDifficulty,
		typeDifficultyOld = self.tGameModeInfo.difficulty,
	}

	self.tGameModeInfo.difficulty = typeDifficulty

	if typeDifficulty == DIFFICULTY.Endless then
		local iLayer = nil
		DotaTD:EachPlayer(function(_, iPlayerID)
			local iLayerPlayer = tonumber(NetEventData:GetTableValue('service', 'player_endless_layers_' .. iPlayerID))
			if not iLayerPlayer then return end
			if nil == iLayer or iLayer > iLayerPlayer then
				iLayer = iLayerPlayer
			end
		end)
		self.tGameModeInfo.endless_layer = iLayer or 0
	end

	self:UpdateNetTables()

	EventManager:fireEvent(ET_GAME.DIFFICULTY_CHANGE, tEventData)
end
---获取游戏难度
function public:GetDifficulty()
	return self.tGameModeInfo.difficulty
end
---获取游戏的轮回层数
function public:GetEndlessLayer()
	return self.tGameModeInfo.endless_layer
end
---获取当前模式能否使用自组卡
function public:IsCanUseCardGroup()
	return DIFFICULTY_INFO[self:GetDifficulty()] and not DIFFICULTY_INFO[self:GetDifficulty()].all_random
end

----------------------------------------------------------------------------------------------------
-- PUBLIC
--- 获取玩家游戏中使用的卡组
function public:GetPlayerCardGroup(iPlayerID)
	-- 自组卡
	if self:IsCanUseCardGroup() then
		local tPlayerCardGroups = NetEventData:GetTableValue('service', 'player_cardgroups_' .. iPlayerID)
		local tUseData = NetEventData:GetTableValue('service', 'player_using_' .. iPlayerID)
		if tUseData['cardgroup'] then
			local sUseGroupID = tostring(tUseData['cardgroup'])
			if tPlayerCardGroups[sUseGroupID] then
				local tCards = {}
				local tCardGroup = json.decode(tPlayerCardGroups[sUseGroupID]['group']) or {}
				local iCount = 0
				for sCardID, iCount2 in pairs(tCardGroup) do
					if 0 < iCount2 then
						local sCardName = DotaTD:GetCardName(sCardID)
						if sCardName then
							tCards[sCardName] = iCount2
							iCount = iCount + iCount2
						end
					end
				end
				if tCards and GROUP_CARD_CARD_COUNT_MIN <= iCount and iCount <= GROUP_CARD_CARD_COUNT then
					return tCards
				end
			end
		end
	end

	-- KeyValues.BaseCardPoolKv
	-- 全卡组
	local tBase = {}
	for k, v in pairs(KeyValues.CardsKv) do
		for sCardName, v2 in pairs(v) do
			tBase[sCardName] = 1
		end
	end
	return tBase
end
----------------------------------------------------------------------------------------------------
-- UI EVENT
function public:OnPlayerActive(eventSourceIndex, events)
	local iPlayerID = tonumber(events.PlayerID)
	if nil ~= iPlayerID then
		if events.code == ACTIVE_CKD then
			self.tPlayerActiveInfo[iPlayerID] = true
			self:UpdateNetTables()
		elseif events.code == 'eomdebug' then
			self.tPlayerActiveInfo[iPlayerID] = true
			self:UpdateNetTables()
			NetEventData:SetTableValue('debug', 'onf', 'on')
			IsInToolsMode = function() return true end
			-- GameRules.IsCheatMode = function() return true end
			EomDebug:init(false)
		end
	end
end

return public