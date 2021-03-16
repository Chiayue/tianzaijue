-- LinkLuaModifier("lm_take_no_damage", "modifiers/lm_take_no_damage", LUA_MODIFIER_MOTION_NONE)
if EomDebug == nil then
	---@class EomDebug
	EomDebug = {
		m_co = nil,
		PlayerChat = 'EomDebug_PlayerChat',
		tConfig = {},
	}
	EomDebug = class({}, EomDebug)
end
---@type EomDebug
local public = EomDebug

function public:init(bReload)
	if not IsInToolsMode() then
		return
	end

	if not bReload then
		SendToServerConsole("sv_cheats 1")
		SendToServerConsole("dota_hero_god_mode 0")
		SendToServerConsole("dota_ability_debug 0")
		SendToServerConsole("dota_creeps_no_spawning 0")
		SendToServerConsole("dota_easybuy 1")

		self.m_tEnemiesList = {}
		self.bInvincible = false

		ListenToGameEvent("player_chat", Dynamic_Wrap(public, "OnPlayerChat"), public)
	end

	local GameMode = GameRules:GetGameModeEntity()

	CustomUIEvent("ClearEnemyButtonPressed", Dynamic_Wrap(public, "OnClearEnemyButtonPressed"), public)
	CustomUIEvent("ReloadScriptButtonPressed", Dynamic_Wrap(public, "OnReloadScriptButtonPressed"), public)
	CustomUIEvent("UploadScriptButtonPressed", Dynamic_Wrap(public, "OnUploadScriptButtonPressed"), public)
	CustomUIEvent("SetWinnerPressed", Dynamic_Wrap(public, "OnSetWinnerPressed"), public)
	CustomUIEvent("RestartButtonPressed", Dynamic_Wrap(public, "OnRestartPressed"), public)
	CustomUIEvent("NoWaitButtonPressed", Dynamic_Wrap(public, "OnNoWaitButtonPressed"), public)
	CustomUIEvent("RoundButtonPressed", Dynamic_Wrap(public, "OnRoundButtonPressed"), public)
	CustomUIEvent("ItemButtonPressed", Dynamic_Wrap(public, "OnItemButtonPressed"), public)
	CustomUIEvent("RespawnHeroButtonPressed", Dynamic_Wrap(public, "OnRespawnHeroButtonPressed"), public)
	CustomUIEvent("DummyTargetButtonPressed", Dynamic_Wrap(public, "OnDummyTargetButtonPressed"), public)
	CustomUIEvent("ClearDummyButtonPressed", Dynamic_Wrap(public, "OnClearDummyButtonPressed"), public)
	CustomUIEvent("CtrlUnitButtonPressed", Dynamic_Wrap(public, "OnCtrlUnitButtonPressed"), public)
	CustomUIEvent("AddPlayerButtonPressed", Dynamic_Wrap(public, "OnAddPlayerButtonPressed"), public)
	CustomUIEvent("AddArtifactButtonPressed", Dynamic_Wrap(public, "OnAddArtifactButtonPressed"), public)
	CustomUIEvent("RemoveArtifactButtonPressed", Dynamic_Wrap(public, "OnRemoveArtifactButtonPressed"), public)
	CustomUIEvent("AddSpecialAbilitiyButtonPressed", Dynamic_Wrap(public, "OnAddSpecialAbilitiyButtonPressed"), public)
	CustomUIEvent("LevelMaxPressed", Dynamic_Wrap(public, "OnLevelMaxPressed"), public)
	CustomUIEvent("AbltUnlockPressed", Dynamic_Wrap(public, "AbltUnlockPressed"), public)
	CustomUIEvent("InvinciblePressed", Dynamic_Wrap(public, "OnInvinciblePressed"), public)
	CustomUIEvent("HeroGroupPressed", Dynamic_Wrap(public, "OnHeroGroupPressed"), public)
	CustomUIEvent("DebugLearnAbility", Dynamic_Wrap(public, "OnDebugLearnAbility"), public)
	CustomUIEvent("ChangeTimeScale", Dynamic_Wrap(public, "ChangeTimeScale"), public)
	CustomUIEvent("UIDebug_Select", Dynamic_Wrap(public, "UIDebug_Select"), public)
	CustomUIEvent("TeamChangePressed", Dynamic_Wrap(public, "TeamChangePressed"), public)
	CustomUIEvent("ToggleCloneMode", Dynamic_Wrap(public, "ToggleCloneMode"), public)
	CustomUIEvent("ToggleBoxNoGold", Dynamic_Wrap(public, "ToggleBoxNoGold"), public)
	CustomUIEvent("ToggleBanShowGold", Dynamic_Wrap(public, "ToggleBanShowGold"), public)
	CustomUIEvent("ToggleBanShowDrop", Dynamic_Wrap(public, "ToggleBanShowDrop"), public)
	CustomUIEvent("ToggleBanShowDamage", Dynamic_Wrap(public, "ToggleBanShowDamage"), public)
	CustomUIEvent("ToggleBanShowDamagePtcl", Dynamic_Wrap(public, "ToggleBanShowDamagePtcl"), public)
	CustomUIEvent("ToggleBanArtifact", Dynamic_Wrap(public, "ToggleBanArtifact"), public)
	CustomUIEvent("ToggleBanDotaFind", Dynamic_Wrap(public, "ToggleBanDotaFind"), public)
	CustomUIEvent("ToggleLowAI", Dynamic_Wrap(public, "ToggleLowAI"), public)

	-- debug.debug()
	-- coroutine.wrap(self.ListenRuning)()
	-- debug.sethook(function ()
	-- 	if public.m_co then
	-- 		coroutine.resume(public.m_co)
	-- 	end
	-- end, "l")
	-- public:Listen(public, public.OnClearEnemyButtonPressed)
	--
	-- local tLog = {}
	-- debug.sethook(function(event, line)
	-- 	local s = debug.getinfo(2).short_src .. ":" .. line
	-- 	tLog[s] = (tLog[s] or 0) + 1
	-- end, "l")
	-- GameTimerEvent(1, function()
	-- 	local tLogTmp = shallowcopy(tLog)
	-- 	local iMax = 0
	-- 	local sMax
	-- 	for s, i in pairs(tLog) do
	-- 		if iMax < i then
	-- 			iMax = i
	-- 			sMax = s
	-- 		end
	-- 	end
	-- 	print('max count=', iMax, 'max line=', sMax)
	-- 	return 1
	-- end
	Request:Event("addgoods", Dynamic_Wrap(public, "AddGoods"), public)
end

function public:AddGoods(params)
	local iPlayerID = params.PlayerID
	local sGoodsID = params.goods_id
	local tData = {
		uid = GetAccountID(iPlayerID),
		sid = sGoodsID,
		count = params.goods_count,
	}
	local data = Service:POSTSync('player.add_item', tData)
	if data then
		PrintTable(tData)
		PrintTable(data)
	end
	return data
end

function public:UpdateNetTable()
	-- local tClass = {}
	-- for k, v in pairs(_G) do
	-- 	if 'table' == type(v) then
	-- 		tClass[k] = v
	-- 	end
	-- end
	CustomNetTables:SetTableValue("common", "debug_config", self.tConfig)
end

function public:Listen(hCalss, func)
	HOOK(hCalss, func, function(...)
		coroutine.resume(public.m_co, func, { ... })
	end)
end

function public.ListenRuning()
	public.m_co = coroutine.running()

	while true do
		local func, tArg = coroutine.yield()
		print('hit')

		-- debug.sethook(function ()
		-- 	coroutine.resume(public.m_co)
		-- end, "l")
		func(unpack(tArg))
		debug.sethook()
	end

	-- 	local func, tArg = coroutine.yield()
	--
	-- debug.sethook(coroutine.wrap(self.ListenRuning), "l")
	--获取当前的调试信息
	-- local info = debug.getinfo(2, "nlS")
	-- if not info then
	-- 	return
	-- end
end

--清怪
function public:OnClearEnemyButtonPressed(eventSourceIndex, data)
	local iPlayerID = data.PlayerID
	local hHero = PlayerData:GetHero(iPlayerID)

	for i = #Spawner.PublicMissing, 1, -1 do
		local hUnit = Spawner.PublicMissing[i]
		table.remove(Spawner.PublicMissing, i)
		if IsValid(hUnit) then
			hUnit:Kill(nil, hHero)
		end
	end

	for _iPlayerID, v in pairs(Spawner.PlayerMissing) do
		for i = #v, 1, -1 do
			local hUnit = v[i]
			table.remove(v, i)
			if IsValid(hUnit) then
				hUnit:Kill(nil, hHero)
			end
		end
	end

	PlayerData:AddHealth(iPlayerID, 999999999)
end

--重载脚本
function public:OnReloadScriptButtonPressed(eventSourceIndex)
	SendToConsole("cl_script_reload")
	SendToConsole("script_reload")
	-- io.popen('cd "' .. ContentDir .. AddonName .. '\\panorama"' .. ' & tsc', 'r')
end

--上传脚本
function public:OnUploadScriptButtonPressed(eventSourceIndex)
	Service:NetTableToTs()
	Service:UpLoadAll()
end

--游戏结束
function public:OnSetWinnerPressed(eventSourceIndex, data)
	local iTeam = PlayerResource:GetTeam(data.PlayerID)
	GameRules:SetGameWinner(iTeam)
end

--重开游戏
function public:OnRestartPressed(eventSourceIndex, data)
	SendToConsole("restart")
end

--结束等待
function public:OnNoWaitButtonPressed(eventSourceIndex, data)
	if GSManager:getStateObj().iDuration then
		GSManager:getStateObj().iDuration = 0
	end
end

--跳关
function public:OnRoundButtonPressed(eventSourceIndex, data)
	local iRound = tonumber(data.iRound)
	if not iRound or 0 >= iRound then return end

	Spawner:SetRound(iRound - 1)

	if GS_Preparation == GSManager:getStateType() then
		GSManager:getStateObj():over()
		GSManager:getStateObj():start()
	else
		GSManager:switch(GS_Preparation)
	end
end

--添加物品
function public:OnItemButtonPressed(eventSourceIndex, data)
	Items:AddItem(data.PlayerID, data.sItemName)
end

--下一步
function public:OnNextButtonPressed(eventSourceIndex, data)
	if self.m_co then
		print('next runing')
		coroutine.resume(co)
	end
end

--复活英雄
function public:OnRespawnHeroButtonPressed(eventSourceIndex, data)
	BuildSystem:EachBuilding(data.PlayerID, function(hBuilding)
		hBuilding:RespawnBuildingUnit()
	end)
end

-- 傀儡
function public:OnDummyTargetButtonPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	local nEnemiesTeam = DOTA_TEAM_BADGUYS

	local hDummy = CreateUnitByName("npc_dota_hero_target_dummy", hPlayerHero:GetAbsOrigin(), true, nil, nil, nEnemiesTeam)
	table.insert(self.m_tEnemiesList, hDummy)

	hDummy:SetAbilityPoints(0)
	hDummy:SetControllableByPlayer(data.PlayerID, false)
	hDummy:Hold()
	hDummy:SetIdleAcquire(false)
	hDummy:SetAcquisitionRange(0)
end
function public:OnClearDummyButtonPressed(eventSourceIndex, data)
	for k, v in pairs(self.m_tEnemiesList) do
		if IsValid(v) then
			self.m_tEnemiesList[k]:MakeIllusion()
			self.m_tEnemiesList[k]:ForceKill(false)
			self.m_tEnemiesList[k]:Destroy()
			self.m_tEnemiesList[k] = nil
		end
	end
end
function public:OnCtrlUnitButtonPressed(eventSourceIndex, data)
	-- if data.ent_index then
	-- 	print(data.ent_index)
	-- 	local hUnit = EntIndexToHScript(data.ent_index)
	-- 	if IsValid(hUnit) then
	-- 		hUnit:SetControllableByPlayer(data.PlayerID, true)
	-- 	end
	-- end
	local sUnitName = data.unitname


	if _G.CLONEMODE then
		public:HeroGroupSpawn(data.PlayerID, {
			[sUnitName] = {
				level =	3,
				count = 9,
				abilities = {
					[1] = 5,
					[2] = 5,
					[3] = 5,
				},
			-- items = {
			-- 	item_ballista_1 = {
			-- 		level = 1
			-- 	},
			-- 	item_encouraging_gem_1 = {
			-- 		level = 1
			-- 	},
			-- }
			}
		})
		return
	end

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)

	local iPlayerID = data.PlayerID
	local vLocation = hPlayerHero:GetAbsOrigin()
	local hUnit = CreateUnitByName(sUnitName, vLocation, true, hPlayerHero, hPlayerHero, hPlayerHero:GetTeamNumber())
	print(sUnitName)
	if not IsValid(hUnit) then
		return
	end

	hUnit:SetControllableByPlayer(iPlayerID, true)
	hUnit:SetHasInventory(true)
	table.insert(self.m_tEnemiesList, hUnit)

	-- 注册属性
	Attributes:Register(hUnit)
	local iLevel = tonumber(data.level) or 1
	if iLevel > 1 then
		hUnit:LevelUp(false, iLevel - 1)
	end
	-- return hUnit
	hUnit:AddNewModifier(hUnit, nil, 'modifier_eom_debug_unit', nil)

	print('ability is: ')
	for i = 0, 2 do
		local h = hUnit:GetAbilityByIndex(i)
		print(h:GetAbilityName())
		print(h:GetLevel())
	end
end
if modifier_eom_debug_unit == nil then
	modifier_eom_debug_unit = class({}, nil, nil)
end
function modifier_eom_debug_unit:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end
function modifier_eom_debug_unit:GetModifierConstantManaRegen(params)
	local hParent = self:GetParent()
	return GET_BUILDING_MANA_REGEN_EXTRA(100 - hParent:GetHealthPercent())
end

--添加玩家
function public:OnAddPlayerButtonPressed(eventSourceIndex)
	--假player
	if not self._dota_create_fake_clients then
		SendToServerConsole('dota_create_fake_clients')
	end
	GameTimer(0, function()
		for i = 0, 9 do
			if PlayerResource:IsFakeClient(i) then
				if not PlayerResource:HasSelectedHero(i) then
					local ply = PlayerResource:GetPlayer(i)
					if ply then
						PlayerResource:SetCustomTeamAssignment(i, DOTA_TEAM_GOODGUYS)
						ply.hHero = CreateHeroForPlayer(FORCE_PICKED_HERO, ply)
						ply.GetAssignedHero = function() return ply.hHero end
						EventManager:fireEvent(ET_PLAYER.ON_LOADED_FINISHED, { PlayerID = i })
					end
				end
			end
		end
	end)
end
function public:OnAddArtifactButtonPressed(eventSourceIndex, data)
	local iPlayerID = data.PlayerID
	local sName = data.name

	if Artifact:Add(iPlayerID, sName) then
		print("Add artifact succeed. ", sName)
	else
		print("Add artifact failed. ", sName)
	end
end
function public:OnRemoveArtifactButtonPressed(eventSourceIndex, data)
	local iPlayerID = data.PlayerID
	local sName = data.name

	if Artifact:Remove(iPlayerID, sName) then
		print("Remove artifact succeed. ", sName)
	else
		print("Remove artifact failed. ", sName)
	end
end
function public:OnAddSpecialAbilitiyButtonPressed(eventSourceIndex, data)
	local iPlayerID = data.PlayerID
	local sName = data.name
	local unitindex = data.unitindex
	local hUnit = EntIndexToHScript(unitindex)
	print("add special ability, name is ", sName, "; unit is ", unitindex)
	if IsValid(hUnit) then
		local hAbility = hUnit:AddAbility(sName)
		if IsValid(hAbility) then
			hAbility:SetLevel(1)
			print("add special ability succeed! name is ", sName)
		end
	end
end
function public:OnLevelMaxPressed(eventSourceIndex, data)
	local iPlayerID = data.PlayerID
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		if hBuilding then
			for i = 1, 5 - hBuilding:GetLevel() do
				hBuilding:AddXP(HERO_XP_PER_LEVEL_TABLE[5] - hBuilding:GetCurrentXP())
				-- hBuilding:LevelUp()
			end
		end
	end)
	-- 装备升星
	for iItemID, tData in pairs(Items.tPlayerItems[iPlayerID]) do
		Items:SetItemLevel(iPlayerID, iItemID, 3)
	end
	Items:UpdateNetTables()
end
function public:AbltUnlockPressed(eventSourceIndex, data)
	local iPlayerID = data.PlayerID
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		if hBuilding then
			local hUnit = hBuilding:GetUnitEntity()
			for iIndex = 0, 7 do
				local hAbility = hUnit:GetAbilityByIndex(iIndex)
				if IsValid(hAbility) then
					local sAbilityName = hAbility:GetAbilityName()
					local sTag = DotaTD:GetAbilityTag(sAbilityName)	--技能标签
					if sTag ~= "" then
						hAbility:SetLevel(hBuilding:GetLevel())
					end
				end
			end
		end
	end)
end
function public:OnInvinciblePressed(eventSourceIndex, data)
	local iPlayerID = data.PlayerID

	-- BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
	-- 	if hBuilding then
	-- 		local hUnit = hBuilding:GetUnitEntity()
	-- 		if self.bInvincible then
	-- 			hUnit:RemoveModifierByName("modifier_no_damage")
	-- 		else
	-- 			hUnit:AddNewModifier(hUnit, nil, "modifier_no_damage", nil)
	-- 		end
	-- 	end
	-- end)
	-- if self.bInvincible then
	-- 	Commander:GetCommander(iPlayerID):RemoveModifierByName("modifier_no_damage")
	-- else
	-- 	Commander:GetCommander(iPlayerID):AddNewModifier(Commander:GetCommander(iPlayerID), nil, "modifier_no_damage", nil)
	-- end
	self.bInvincible = not self.bInvincible
end
function public:OnDebugLearnAbility(eventSourceIndex, data)
	local iPlayerID = data.PlayerID
	print(data.sAbilityIndex)
	local hAbility = EntIndexToHScript(tonumber(data.sAbilityIndex))
	print(hAbility)
	if hAbility:GetLevel() < hAbility:GetMaxLevel() then
		hAbility:UpgradeAbility(false)
	end
end
function public:ChangeTimeScale(eventSourceIndex, data)
	if data.scale and tonumber(data.scale) then
		print("host_timescale" .. data.scale)
		SendToConsole("host_timescale " .. data.scale)
	end
end
function public:OnHeroGroupPressed(eventSourceIndex, data)
	local iPlayerID = data.PlayerID
	-- self:HeroGroupSpawn(iPlayerID, data.sGroupName)
	DotaTD:EachPlayer(function(_, iPlayerID)
		self:HeroGroupSpawn(iPlayerID, data.sGroupName)
	end)
end
function public:HeroGroupSpawn(iPlayerID, sType)
	local tHeros
	if type(sType) == 'table' then
		tHeros = sType
	else
		local tGroups = LoadKeyValues("scripts/npc/kv/hero_group.kv")
		if not tGroups then return end
		tHeros = tGroups[sType]
	end
	if tHeros then
		if TableCount(tHeros) > PlayerData:GetPlayerLevel(iPlayerID) then
			PlayerData:AddPlayerLevel(iPlayerID, TableCount(tHeros) - PlayerData:GetPlayerLevel(iPlayerID))
		end

		---@param hBuilding Building
		BuildSystem:EachBuilding(iPlayerID, function(hBuilding, iPlayerID, iEntIndex)
			BuildSystem:RemoveBuilding(hBuilding:GetUnitEntity())
		end)
		-- 清空装备
		Items:RemoveAllItem(iPlayerID)

		local tPos = BuildSystem:GetAllBuildingPos(PlayerData:GetPlayerTeamID(iPlayerID), BuildSystem.typeBuildingMap)
		local tUnits = {}

		for sCardName, v in pairs(tHeros) do
			if type(v) == "table" then
				local hCard = HeroCardData:DefaultCardData(sCardName, iPlayerID)
				if v.level then
					hCard.iLevel = tonumber(v.level)
					hCard.iXP = HERO_XP_PER_LEVEL_TABLE[hCard.iLevel]
				end
				v.count = v.count and tonumber(v.count) or 1
				if v.count > PlayerData:GetPlayerLevel(iPlayerID) then
					PlayerData:AddPlayerLevel(iPlayerID, v.count - PlayerData:GetPlayerLevel(iPlayerID))
				end
				for i = v.count, 1, -1 do
					local hCard2 = deepcopy(hCard)

					HeroCardData:_AddPlayerHeroCard(iPlayerID, hCard2)
					HeroCardData:UpdateCard(hCard, iPlayerID)
					HeroCardData:UpdateNetTables()

					if v.items then
						local iTargetSolt = 0
						for sItemName, v2 in pairs(v.items) do
							local tItemData = Items:AddItem(iPlayerID, sItemName)
							if tItemData then
								Items:ItemGiveCard(iPlayerID, tItemData.iItemID, hCard2.iCardID, iTargetSolt)
								iTargetSolt = iTargetSolt + 1

								if v2.level then
									Items:SetItemLevel(iPlayerID, tItemData.iItemID, tonumber(v2.level))
								end
								Items:UpdateNetTables()
							end
						end
					end

					if not v.card then
						local vPos
						if v.position then
							vPos = tPos[v.position]
						end
						if not vPos then
							vPos = BuildSystem:GetRandomBuildingPos(PlayerData:GetPlayerTeamID(iPlayerID), BuildSystem.typeBuildingMap)
						end
						if vPos then
							---@type Building
							local hBuilding = HandHeroCards:UsedCard(iPlayerID, hCard2.iCardID, vPos)

							if hBuilding then
								local hUnit = hBuilding:GetUnitEntity()
								hUnit.abilities = v.abilities
								if 1 == tHeros.wudi then
									hUnit:AddNewModifier(hUnit, nil, "modifier_no_damage", nil)
								end
								table.insert(tUnits, hUnit)
							end
						end
					end

				end
			end
		end

		for _, hUnit in pairs(tUnits) do
			if IsValid(hUnit) then
				if hUnit.abilities then
					for i, iLevel in pairs(hUnit.abilities) do
						local hAblt = hUnit:GetAbilityByIndex(i - 1)
						if hAblt then
							hAblt:SetLevel(iLevel)
						end
					end
				end
			end
		end
	end
end
function public:ArtifactGroupSpawn(iPlayerID, sType)
	local tArts
	local tGroups = LoadKeyValues("scripts/npc/kv/art_group.kv")
	if tGroups then
		tArts = deepcopy(tGroups[sType])
	end
	if tArts then
		local tCutArts = Artifact:GetPlayerArtifacts(iPlayerID)

		for _, sName in pairs(tCutArts) do
			if nil == tArts[sName] or 0 == tArts[sName] then
				-- 移除不需要的
				Artifact:Remove(iPlayerID, sName)
			else
				tArts[sName] = 0
			end
		end
		for sName, v in pairs(tArts) do
			if 0 < v then
				Artifact:Add(iPlayerID, sName)
			end
		end
	else
		-- 清除全部神器
		Artifact:EechArtifacts(iPlayerID, function(sName, iEntID)
			Artifact:Remove(iPlayerID, sName)
		end)
	end
end
if PlayerResource and not PlayerResource._GetSelectedHeroEntity then
	PlayerResource._GetSelectedHeroEntity = PlayerResource.GetSelectedHeroEntity
	PlayerResource.GetSelectedHeroEntity = function(self, iPlayerID, ...)
		if PlayerResource:IsFakeClient(iPlayerID) then
			local hPlayer = PlayerResource:GetPlayer(iPlayerID)
			if hPlayer then return hPlayer:GetAssignedHero() end
		end
		return PlayerResource._GetSelectedHeroEntity(self, iPlayerID, ...)
	end
end

function public:ToggleCloneMode(eventSourceIndex, data)
	_G.CLONEMODE = 1 == tonumber(data.enable)
	self.tConfig['CLONEMODE'] = _G.CLONEMODE
	self:UpdateNetTable()
end
function public:ToggleBoxNoGold(eventSourceIndex, data)
	_G.NOHASDROP = 1 == tonumber(data.enable)
	self.tConfig['NOHASDROP'] = _G.NOHASDROP
	self:UpdateNetTable()
end
function public:ToggleBanShowGold(eventSourceIndex, data)
	_G.NOSHOWGOLD = 1 == tonumber(data.enable)
	self.tConfig['NOSHOWGOLD'] = _G.NOSHOWGOLD
	self:UpdateNetTable()
end
function public:ToggleBanShowDrop(eventSourceIndex, data)
	_G.NOSHOWDROP = 1 == tonumber(data.enable)
	self.tConfig['NOSHOWDROP'] = _G.NOSHOWDROP
	self:UpdateNetTable()
end
function public:ToggleBanShowDamage(eventSourceIndex, data)
	_G.NOSHOWDAMAGE = 1 == tonumber(data.enable)
	self.tConfig['NOSHOWDAMAGE'] = _G.NOSHOWDAMAGE
	self:UpdateNetTable()
end
function public:ToggleBanShowDamagePtcl(eventSourceIndex, data)
	_G.NOSHOWDAMAGEPTCL = 1 == tonumber(data.enable)
	self.tConfig['NOSHOWDAMAGEPTCL'] = _G.NOSHOWDAMAGEPTCL
	self:UpdateNetTable()
end
function public:ToggleBanArtifact(eventSourceIndex, data)
	self.tConfig['BANARTIFACT'] = 1 == tonumber(data.enable)
	self:UpdateNetTable()
	Artifact:Disable(1 == tonumber(data.enable))
end
function public:ToggleBanDotaFind(eventSourceIndex, data)
	_G.BANDOTAFIND = 1 == tonumber(data.enable)
	self.tConfig['BANDOTAFIND'] = _G.BANDOTAFIND
	self:UpdateNetTable()
end
function public:ToggleLowAI(eventSourceIndex, data)
	local fMin, fMax = 0.1, 1
	self.tConfig['LOWAI'] = Clamp(AI_TIMER_TICK_TIME + 0.1, fMin, fMax)
	-- self.tConfig['LOWAI'] = Clamp(AI_TIMER_TICK_TIME * 2, fMin, fMax)
	if fMax <= self.tConfig['LOWAI'] then self.tConfig['LOWAI'] = fMin end
	AI_TIMER_TICK_TIME = self.tConfig['LOWAI']
	self:UpdateNetTable()
end

--对话框命令
function public:OnPlayerChat(keys)
	local iPlayerID = keys.playerid
	local tokens = string.split(string.lower(keys.text), " ")
	if "-gold1" == tokens[1] or '-crystal' == tokens[1] then
		PlayerData:ModifyCrystal(iPlayerID, tonumber(tokens[2]))
	elseif "-gold" == tokens[1] then
		PlayerData:ModifyGold(iPlayerID, tonumber(tokens[2]))
	elseif "-hg" == tokens[1] then
		self:HeroGroupSpawn(iPlayerID, tokens[2])
	elseif "-artg" == tokens[1] then
		self:ArtifactGroupSpawn(iPlayerID, tokens[2])
	elseif "-error" == tokens[1] then
		if IsInToolsMode() then
			DebugError('333', '123')
		end
	elseif "-run" == tokens[1] then
		load(string.sub(keys.text, 1 + string.len(tokens[1])))()
	elseif "-debug_pk" == tokens[1] or "-pk" == tokens[1] then
		self:DebugPK(iPlayerID, tokens[2])
	elseif "-nton" == tokens[1] then
		self:SwitchNetTabelOnOff(true)
	elseif "-ntoff" == tokens[1] then
		self:SwitchNetTabelOnOff(false)
	elseif "-vprof" == tokens[1] and tokens[2] then
		if not self.vprof then
			SendToConsole("vprof_vtrace")
		end
		SendToConsole("vprof_reset")
		SendToConsole("vprof_on")
		self.vprof = GameTimer('vprof2', tonumber(tokens[2]), function()
			SendToConsole("vprof_generate_report")
			SendToConsole("vprof_off")
			SendToConsole("vprof_vtrace")
			self.vprof = nil
		end)
	elseif "-allcards" == tokens[1] then
		local tCards = Draw.tPlayerCards[iPlayerID]
		for _, t in pairs(tCards) do
			for k, v in pairs(t) do
				print(k, v)
			end
		end
	elseif "-check" == tokens[1] then
		local tEnts = Entities:FindAllInSphere(Vector(0, 0, 0), 1000)
		for _, hEnt in ipairs(tEnts) do
			if hEnt:GetClassname() == "npc_dota_creature" then
				print(hEnt:GetUnitName())
			end
		end
	elseif "-showdamage" == tokens[1] then
		_G.NOSHOWDAMAGE = tokens[2] == '0'
		self.tConfig['NOSHOWDAMAGE'] = _G.NOSHOWDAMAGE
		self:UpdateNetTable()
	elseif "-passboss" == tokens[1] then
		_G.PASSBOSS = tokens[2] ~= '0'
	elseif "-showdrop" == tokens[1] then
		_G.NOSHOWDROP = tokens[2] == '0'
		self.tConfig['NOSHOWDROP'] = _G.NOSHOWDROP
		self:UpdateNetTable()
	elseif "-hasdrop" == tokens[1] then
		_G.NOHASDROP = tokens[2] == '0'
		self.tConfig['NOHASDROP'] = _G.NOHASDROP
		self:UpdateNetTable()
	elseif "-showgold" == tokens[1] then
		_G.NOSHOWGOLD = tokens[2] == '0'
		self.tConfig['NOSHOWGOLD'] = _G.NOSHOWGOLD
		self:UpdateNetTable()
	elseif "-map" == tokens[1] then
		DOTA_SpawnMapAtPosition(tokens[2], Vector(0, 0, 0), false, function(self, id)
			print('-map ready', self, id)
		end, function(self, id)
			print('-map ok', self, id)
		end, public)
	elseif "-gmcfg" == tokens[1] then
		game:config()
	elseif "-tmp" == tokens[1] then
	end

	EventManager:fireEvent(EomDebug.PlayerChat, iPlayerID, tokens)
end

--防止暴力测试网表爆炸
function public:SwitchNetTabelOnOff(bOn)
	if bOn then
		CustomNetTables.SetTableValue = CustomNetTables._SetTableValueDebug or CustomNetTables.SetTableValue
	else
		CustomNetTables._SetTableValueDebug = CustomNetTables._SetTableValueDebug or CustomNetTables.SetTableValue
		function CustomNetTables:SetTableValue() end
	end
end

function public:DebugPK(iPlayerID, sType)
	local tPkKV = LoadKeyValues("scripts/npc/kv/debug_pk.kv")
	local tPkData = tPkKV[sType]
	if not tPkData then return end

	local tPkDatas = tPkData
	local sHeroGroup = tPkData.hero_groud
	if sHeroGroup then
		-- 单任务
		tPkDatas = { tPkData }
	end

	-- 处理全英雄模式
	local tGroups = LoadKeyValues("scripts/npc/kv/hero_group.kv")
	if not tGroups then return end

	local tAllHerosPkDatas = {}
	for k, tPkData in pairs(tPkDatas) do
		if tPkData.all_heroes and 'string' == type(tPkData.hero_groud) then
			tPkDatas[k] = nil
			local tHeros = tGroups[tPkData.hero_groud]
			if tHeros and tHeros.all_heroes then
				for _, tCards in pairs(KeyValues.CardsKv) do
					for sCardName, _ in pairs(tCards) do
						local tHeros2 = deepcopy(tHeros)
						tHeros2[sCardName] = deepcopy(tHeros.all_heroes)
						tHeros2.all_heroes = nil
						local tPkData2 = deepcopy(tPkData)
						tPkData2.all_heroes = nil
						tPkData2.hero_groud_name = tPkData2.hero_groud
						tPkData2.hero_groud = tHeros2
						table.insert(tAllHerosPkDatas, tPkData2)
					end
				end
			end
		end
	end
	for k, v in pairs(tAllHerosPkDatas) do
		table.insert(tPkDatas, v)
	end

	--测试任务队列
	self:DebugPKList(iPlayerID, tPkDatas)
end
function public:DebugPK_Once()
	local iPlayerID = self.tDebugPKOrder.iPlayerID
	local tPkData = self.tDebugPKOrder.tPkData

	if not tPkData.count or 1 > tPkData.count then
		self.tDebugPKOrder = nil
		SendToConsole("host_timescale 1")
		BuildSystem:EachBuilding(iPlayerID, function(hBuilding, iPlayerID, iEntIndex)
			BuildSystem:RemoveBuilding(hBuilding:GetUnitEntity())
		end)

		EventManager:unregister(ET_BATTLE.ON_BATTLEING_ENDWAIT_START, 'DebugPK_ON_BATTLEING_ENDWAIT_START', self)

		GameTimer(0, function()
			if self.tDebugPKList then
				self:DebugPKList(iPlayerID, self.tDebugPKList)
			end
		end)

		return
	end
	SendToConsole("host_timescale 10")
	tPkData.count = tPkData.count - 1

	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	if IsValid(hHero) then
		hHero:SetHealth(hHero:GetMaxHealth())
	end

	--设置关卡
	local iRound = tPkData.round or 1
	self:OnRoundButtonPressed(nil, { iRound = iRound })
	self:OnNoWaitButtonPressed()

	--创建单位
	self:HeroGroupSpawn(iPlayerID, tPkData.hero_groud)
	--创建神器
	self:ArtifactGroupSpawn(iPlayerID, tPkData.art_groud)

	EventManager:register(ET_BATTLE.ON_BATTLEING_ENDWAIT_START, 'DebugPK_ON_BATTLEING_ENDWAIT_START', self)
end
function public:DebugPK_ON_BATTLEING_ENDWAIT_START()
	if not self.tDebugPKOrder then return end
	local iPlayerID = self.tDebugPKOrder.iPlayerID
	local tPkData = self.tDebugPKOrder.tPkData

	--生成数据
	local tData = {
		hero_groud = 'string' == type(tPkData.hero_groud) and tPkData.hero_groud or tPkData.hero_groud_name or '',
		unit_damages = {},
		round = Spawner:GetRound(),
	}

	---@param hBuilding Building
	BuildSystem.EachBuilding(iPlayerID, function(hBuilding)
		tData.unit_damages[hBuilding:GetUnitEntityName()] = {
			damage_phy = hBuilding:GetRoundDamage(DAMAGE_TYPE_PHYSICAL),
			damage_mag = hBuilding:GetRoundDamage(DAMAGE_TYPE_MAGICAL),
			damage_pure = hBuilding:GetRoundDamage(DAMAGE_TYPE_PURE),
		}
	end)

	Service:POST("Debug.debug_pk", {
		data = tData,
		player_name = PlayerResource:GetPlayerName(iPlayerID),
		server_key = ServerKey
	}, function(data, response)
	end, 30)

	--
	self:DebugPK_Once()
end
function public:DebugPKList(iPlayerID, tDebugPKList)
	self.tDebugPKList =	tDebugPKList
	for i, tPkData in pairs(self.tDebugPKList) do
		if tPkData then
			if 1 >= TableCount(self.tDebugPKList) then
				self.tDebugPKList = nil
			else
				self.tDebugPKList[i] = nil
			end

			self.tDebugPKOrder = {
				tPkData = tPkData,
				iPlayerID = iPlayerID,
			}

			self:DebugPK_Once()
			return
		end
	end
end


-- 队伍切换
function public:TeamChangePressed(_, tData)
	ChangePlayerTeam(tData.PlayerID, tonumber(tData.team))
end
--UI事件************************************************************************************************************************
	do
	function public:UIDebug_Select(_, tData)
		local hPlayer = PlayerResource:GetPlayer(tData.PlayerID)
		if not hPlayer then return end

		local sKey = tData.sKey
		local val = load('return ' .. sKey)()
		if type(val) == 'table' then
			local tTable = {}
			local tVal = {}
			local function doonce(t, tVal, tIgnore)
				tIgnore = tIgnore or {}
				for k, v in pairs(t) do
					if type(k) == 'table' then
						if not tTable[tostring(k)] then
							tTable[tostring(k)] = true
							tTable[tostring(k)] = doonce(k, {})
						end
						k = tostring(k)
					elseif type(v) == 'userdata' then
						local mv = getmetatable(v)
						if mv ~= nil and mv['__name'] ~= nil then
							k = 'userdata=' .. mv['__name']
						else
							k = 'userdata'
						end
					elseif type(v) == 'function' then
						k = 'function'
					end

					if type(v) == 'table' then
						if not tTable[tostring(v)] then
							tTable[tostring(v)] = true
							tTable[tostring(v)] = doonce(v, {})
						end
						tVal[k] = tostring(v)
					elseif type(v) == 'userdata' then
						local mv = getmetatable(v)
						if mv ~= nil and mv['__name'] ~= nil then
							tVal[k] = 'userdata=' .. mv['__name']
						else
							tVal[k] = 'userdata'
						end
					elseif type(v) ~= 'function' then
						tVal[k] = v
					end
				end
				return tVal
			end
			tVal = doonce(val, tVal)

			CustomGameEventManager:Send_ServerToPlayer(hPlayer, "UIDebug_SelectResult", {
				val_type = 'json',
				val = json.encode(tVal),
				tables = json.encode(tTable),
				key = sKey,
			})
		elseif type(val) == 'userdata' then
			local sVal = ''
			local mv = getmetatable(val)
			if mv ~= nil and mv['__name'] ~= nil then
				sVal = '(userdata : ' .. mv['__name'] .. ')'
			else
				sVal = '(userdata)'
			end
			CustomGameEventManager:Send_ServerToPlayer(hPlayer, "UIDebug_SelectResult", {
				val_type = type(val),
				val = sVal,
				key = sKey,
			})
		else
			CustomGameEventManager:Send_ServerToPlayer(hPlayer, "UIDebug_SelectResult", {
				val_type = type(val),
				val = tostring(val),
				key = sKey,
			})
		end
	end
end
--UI事件************************************************************************************************************************
return public