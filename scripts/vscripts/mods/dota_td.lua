if DotaTD == nil then
	---@class DotaTD
	DotaTD = {}
end
---@type DotaTD
local public = DotaTD

function public:init(bReload)
	if not bReload then
	end

	-- 卡牌数据
	self.tCardData = {}
	for sRarity, tCards in pairs(KeyValues.CardsKv) do
		for sCardName, sAbilityName in pairs(tCards) do
			local tData = {
				rarity = sRarity,
				ability_name = sAbilityName,
				gold_cost = DotaTD:GetCardGold(sCardName),
				abilities = {},
				tags = DotaTD:GetCardTags(sCardName),
			}
			if KeyValues.UnitsKv[sCardName] ~= nil then
				for i = 1, 32, 1 do
					local key = "Ability" .. i
					local abilityName = KeyValues.UnitsKv[sCardName][key]
					if abilityName ~= nil and string.find(abilityName, "empty_") == nil and string.find(abilityName, "hidden_") == nil then
						local abilityKv = KeyValues.AbilitiesKv[abilityName]
						if abilityKv ~= nil and string.find(abilityKv.AbilityBehavior or "", "DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES") == nil then
							if string.find(abilityKv.AbilityType or "", "DOTA_ABILITY_TYPE_ATTRIBUTES") ~= nil then
								tData.talents = tData.talents or {}
								table.insert(tData.talents, abilityName)
							else
								local tAbilityData = {
									name = abilityName,
								}
								table.insert(tData.abilities, tAbilityData)
							end
						end
					end
				end
				-- 卡牌场景路径
				tData["BGScene"] = KeyValues.UnitsKv[sCardName]["BGScene"]
				tData["ID"] = KeyValues.UnitsKv[sCardName]["ID"]
			end
			self.tCardData[sCardName] = tData
		end
	end

	GameEvent("npc_spawned", Dynamic_Wrap(public, "OnNPCSpawned"), public)

	if IsInToolsMode() then
		-- CustomUIEvent("DebugChangeCourier", Dynamic_Wrap(public, "OnDebugChangeCourier"), public)
		-- CustomUIEvent("DebugAddCourier", Dynamic_Wrap(public, "DebugAddCourier"), public)
		-- CustomUIEvent("DebugGetAll", Dynamic_Wrap(public, "DebugGetAll"), public)
		-- CustomUIEvent("DebugClear", Dynamic_Wrap(public, "DebugClear"), public)
		-- CustomUIEvent("DebugGameOver", Dynamic_Wrap(public, "DebugGameOver"), public)
		-- CustomUIEvent("DebugReload", Dynamic_Wrap(public, "DebugReload"), public)
		-- CustomUIEvent("DebugRestart", Dynamic_Wrap(public, "DebugRestart"), public)
		-- CustomUIEvent("DebugResetCourier", Dynamic_Wrap(public, "DebugResetCourier"), public)
	end

	_G.START_POINT = {
		Entities:FindByNameLike(nil, "player_0_start"),
		Entities:FindByNameLike(nil, "player_1_start"),
		Entities:FindByNameLike(nil, "player_2_start"),
		Entities:FindByNameLike(nil, "player_3_start"),
	}
end

--事件监听************************************************************************************************************************
	do

	--单位生成
	function public:OnNPCSpawned(events)
		local spawnedUnit = EntIndexToHScript(events.entindex)
		if spawnedUnit == nil then return end

		EventManager:fireEvent(ET_GAME.NPC_SPAWNED, { entindex = spawnedUnit:entindex() })

		if not spawnedUnit.bIsNotFirstSpawn then
			spawnedUnit.bIsNotFirstSpawn = true
			EventManager:fireEvent(ET_GAME.NPC_FIRST_SPAWNED, { entindex = spawnedUnit:entindex() })
		end
	end
end
--事件监听************************************************************************************************************************
--
-- 遍历玩家
function public:EachPlayer(teamNumber, func, _tPlayerID)
	local tPlayerID = _tPlayerID or {}
	if type(teamNumber) == "function" then
		func = teamNumber
		-- 全部队伍
		for i = DOTA_TEAM_FIRST, DOTA_TEAM_COUNT - 1 do
			public:EachPlayer(i, nil, tPlayerID)
		end
	else
		if PlayerResource then
			for n = 1, PlayerResource:GetPlayerCountForTeam(teamNumber), 1 do
				local iPlayerID = PlayerResource:GetNthPlayerIDOnTeam(teamNumber, n)
				if PlayerResource:IsValidPlayerID(iPlayerID) and 4 > iPlayerID then
					tPlayerID[iPlayerID] = n
				end
			end
		end
	end

	for iPlayerID, n in pairs(tPlayerID) do
		if func and func(n, iPlayerID) == true then
			return true
		end
	end
end

-- 遍历卡片，回调带参数分别为：稀有度，卡片名字，建造技能名字
function public:EachCard(func)
	for rarity, data in pairs(KeyValues.CardsKv) do
		for cardName, abilityName in pairs(data) do
			if func(rarity, cardName, abilityName) == true then
				break
			end
		end
	end
end

-- 获取塔的稀有度
function public:GetCardRarity(sCardName)
	for rarity, data in pairs(KeyValues.CardsKv) do
		for cardName, abilityName in pairs(data) do
			if cardName == sCardName then
				return rarity
			end
		end
	end
	return 'n'
end
-- 获取塔的稀有度
function public:GetCardRarityByNumber(iNumber)
	if iNumber == 1 then
		return 'n'
	elseif iNumber == 2 then
		return 'r'
	elseif iNumber == 3 then
		return 'sr'
	elseif iNumber == 4 then
		return 'ssr'
	end
end
-- 获取稀有度ID
function public:GetRarityID(sRarity)
	return ({ n = 1, r = 2, sr = 3, ssr = 4 })[string.lower(sRarity)] or 1
end

-- 获取卡牌金币
function public:GetCardGold(sCardName)
	local tData = KeyValues.UnitsKv[sCardName]
	if tData and tData.Cost then
		return tonumber(tData.Cost)
	end
	return 0
end

-- 获取卡牌tag需求
function public:GetCardTags(sCardName)
	local t = {}
	local tData = KeyValues.UnitsKv[sCardName]
	if tData then
		table.insert(t, self:GetAbilityTag(tData.Ability2))
		table.insert(t, self:GetAbilityTag(tData.Ability3))
	end
	return t
end

-- 获取卡牌技能
function public:GetCardAbility(sCardName)
	local t = {}
	local tData = KeyValues.UnitsKv[sCardName]
	if tData then
		table.insert(t, tData.Ability2)
		table.insert(t, tData.Ability3)
	end
	return t
end

-- 获取技能tag
function public:GetAbilityTag(sAbilityName)
	return KeyValues.AbilitiesKv[sAbilityName].Tag or ""
end
-- 获取技能tag需求
function public:GetAbilityTagActiveCount(sAbilityName)
	return KeyValues.AbilitiesKv[sAbilityName].TagActiveCount or -1
end
-- 通过单位ID获取单位名
function public:GetCardName(id)
	for k, v in pairs(self.tCardData) do
		if tostring(v.ID) == tostring(id) then
			return k
		end
	end
end
-- 通过单位名获取单位ID
function public:GetCardID(sCardName)
	local t = self.tCardData[sCardName]
	return t and t.ID or sCardName
end

-- 获取法术卡购买金币
function public:GetSpellCardGold(sCardName)
	local tData = KeyValues.SpellKv[sCardName]
	if tData and tData.GoldCost then
		return tonumber(tData.GoldCost)
	end
	return 0
end
-- 获取法术卡购买魂晶
function public:GetSpellCardCrystal(sCardName)
	local tData = KeyValues.SpellKv[sCardName]
	if tData and tData.CrystalCost then
		return tonumber(tData.CrystalCost)
	end
	return 0
end

return public