if Tags == nil then
	---@class Tags 羁绊数据
	Tags = class({
		---玩家游戏中羁绊信息
		tTagInfo = {}
	}, Tags)
end

---@type Tags
local public = Tags

function public:init(bReload)
	if not bReload then
		---玩家游戏中羁绊信息
		self.tTagInfo = {}
	end

	EventManager:register(ET_PLAYER.ON_LOADED_FINISHED, 'OnEvent_LoadedFinished', self)
	EventManager:register(ET_PLAYER.ON_TOWER_ABILITY_UPDATE, 'OnEvent_TowerAbilityUpdate', self)
	EventManager:register(ET_PLAYER.ON_CHANGE_HERO_CARD, 'OnEvent_AddHeroCard', self)
end

function public:UpdateNetTables()
	for iPlayerID, info in pairs(self.tTagInfo) do
		NetEventData:SetTableValue("common", "player_tags_" .. iPlayerID, info)
	end
end

function public:OnEvent_LoadedFinished(tEvent)
	local iPlayerID = tEvent.PlayerID
	self.tTagInfo[iPlayerID] = {}
	self:UpdateNetTables()
end

function public:OnEvent_TowerAbilityUpdate(tEvent)
	local iPlayerID = tEvent.PlayerID
	self:Update(iPlayerID)
end

function public:OnEvent_AddHeroCard(tEvent)
	local iPlayerID = tEvent.PlayerID
	self:Update(iPlayerID)
end

--- 更新羁绊信息
function public:Update(iPlayerID)
	self.tTagInfo[iPlayerID] = {}
	local tTagInfo = self.tTagInfo[iPlayerID]
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		local hUnit = hBuilding:GetUnitEntity()
		for iIndex = 0, 7 do
			local hAbility = hUnit:GetAbilityByIndex(iIndex)
			if IsValid(hAbility) then
				local sAbilityName = hAbility:GetAbilityName()
				local sTag = DotaTD:GetAbilityTag(sAbilityName)	--技能标签
				local iModifyActiveCount = GetModifyFettersActiveCount(iPlayerID, sTag) or 0
				local iActiveCount = DotaTD:GetAbilityTagActiveCount(sAbilityName) + iModifyActiveCount	-- 技能激活所需羁绊数量
				local iRealActiveCount = iActiveCount + iModifyActiveCount	-- 技能激活所需羁绊数量
				if sTag ~= "" and iActiveCount > 0 then
					if tTagInfo[sTag] == nil then
						tTagInfo[sTag] = {
							tag_name = sTag,
							active_count = iActiveCount,
							min_active_count = iActiveCount,
							modify_active_count = iModifyActiveCount,
							building_count = 0,
							handcard_count = 0,
							building_abilities = {},
							handcard_abilities = {},
						}
					else
						tTagInfo[sTag].min_active_count = math.min(tTagInfo[sTag].min_active_count, iActiveCount)
					end

					tTagInfo[sTag].building_abilities[sAbilityName] = {
						ability_name = sAbilityName,
						unit_name = hUnit:GetUnitName(),
						active_count = iActiveCount,
					}
				end
			end
		end
	end)

	HeroCardData:EachCard(iPlayerID, function(hCard)
		-- hCard
		-- {
		--	iGold						   	= 300 (number)
		--	iLevel						  	= 1 (number)
		--	iPlayerID					   	= 0 (number)
		--	iTax							= 30 (number)
		--	iOrder						  	= 1 (number)
		--	iXP							 	= 0 (number)
		--	iCardID						 	= "_270d_iCardID" (string)
		--	iBackGold					   	= 150 (number)
		--	tItems						  	= table: 0x00dc0700 (table)
		--	{
		--	}
		--	sCardName					   	= "spectre" (string)
		--	iSlot						   	= 4 (number)
		-- }
		local sUnitName = hCard.sCardName
		local tAbilities = DotaTD:GetCardAbility(sUnitName)

		for k, sAbilityName in pairs(tAbilities) do
			local sTag = DotaTD:GetAbilityTag(sAbilityName)	--技能标签
			local iModifyActiveCount = GetModifyFettersActiveCount(iPlayerID, sTag) or 0
			local iActiveCount = DotaTD:GetAbilityTagActiveCount(sAbilityName) + iModifyActiveCount	-- 技能激活所需羁绊数量
			local iRealActiveCount = iActiveCount + iModifyActiveCount	-- 技能激活所需羁绊数量
			if sTag ~= "" and iActiveCount > 0 then
				if tTagInfo[sTag] == nil then
					tTagInfo[sTag] = {
						tag_name = sTag,
						active_count = iActiveCount,
						min_active_count = iActiveCount,
						modify_active_count = iModifyActiveCount,
						handcard_count = 0,
						handcard_abilities = {},
					}
				else
					tTagInfo[sTag].min_active_count = math.min(tTagInfo[sTag].min_active_count, iActiveCount)
				end
				tTagInfo[sTag].handcard_abilities[sAbilityName] = {
					ability_name = sAbilityName,
					unit_name = sUnitName,
					active_count = iActiveCount,
				}
			end
		end
	end)

	for sTag, tTagInfo in pairs(tTagInfo) do
		tTagInfo.handcard_abilities = tTagInfo.handcard_abilities or {}
		tTagInfo.handcard_count = TableCount(tTagInfo.handcard_abilities)
		tTagInfo.building_abilities = tTagInfo.building_abilities or {}
		tTagInfo.building_count = TableCount(tTagInfo.building_abilities)
	end

	self:UpdateNetTables()
end

return public