-- 整体游戏逻辑脚本
if Game == nil then
	---@class Game 游戏逻辑
	Game = {
		tRoundBalanceRecord = {}
	}
end
---@class Game 游戏逻辑
local public = Game

function public:init(bReload)
	if not bReload then
	end

	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
	GameEvent("entity_killed", Dynamic_Wrap(public, "OnEntityKilled"), public)

	EventManager:register(ET_GAME.GAME_BEGIN, 'OnGameBegin', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_GAME.EPISODE_BEGIN, 'OnEpisodeBegin', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_GAME.ROUND_CHANGE, 'OnRoundChange', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_GAME.NPC_FIRST_SPAWNED, 'OnNPCFirstSpawned', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_GAME.GAME_BALANCE, 'OnGameBalance', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_GAME.GAME_END, 'OnGameEnd', self, EVENT_LEVEL_MEDIUM)

	EventManager:register(ET_BATTLE.ON_PREPARATION, 'OnPreparation', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_BATTLE.ON_PREPARATION_END, 'OnPreparationEnd', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_BATTLE.ON_BATTLEING, 'OnInBattle', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_BATTLE.ON_BATTLEING_END, 'OnBattleEnd', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_BATTLE.ON_BOSS_BOMB, 'OnBossBomb', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_BATTLE.ON_BATTLEING_ENDWAIT_START, 'OnBattleEndWaitStart', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_BATTLE.ON_BATTLEING_ENDWAIT_END, 'OnBattleEndWaitEnd', self, EVENT_LEVEL_MEDIUM)


	-- EventManager:register(ET_PLAYER.ALL_LOADED_FINISHED, 'OnAllLoadedFinished', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_LOADED_FINISHED, 'OnLoadedFinished', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_DAMAGE, 'OnDamage', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_DEATH, 'OnDeath', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ENEMY_COUNT_CHANGE, 'OnEnemyCountChange', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ROUND_RESULT, 'OnRoundResult', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.LEVEL_CHANGED, 'OnLevelChanged', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.CONNECT_STATE_CHANGE, 'OnConnectStateChanged', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_PLAYER_HERO_SPAWNED, 'OnPlayerHeroSpawned', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_ITEM_LVLUPDATE, 'OnPlayerItemLvlUpdate', self, EVENT_LEVEL_MEDIUM)

	EventManager:register(ET_PLAYER.ON_TOWER_SPAWNED, 'OnTowerSpawned', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_SELL, 'OnTowerSell', self, EVENT_LEVEL_MEDIUM)
	-- EventManager:register(ET_PLAYER.ON_TOWER_DEATH, 'OnTowerDeath', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_TO_CARD, 'OnTowerToCard', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_CARD_SELL, 'OnTowerCardSell', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_CARD_EXCHANGE, 'OnTowerCardExchange', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_SPAWNED_FROM_CARD, 'OnTowerSpawnedFromCard', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_LEVELUP_FROM_CARD, 'OnTowerLevelUpFromCard', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_NEW_ITEM_ENTITY, 'OnTowerNewItemEntity', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_DESTROY_ITEM_ENTITY, 'OnTowerDestroyItemEntity', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_DESTROY, 'OnTowerDestroy', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_DESTROYED, 'OnTowerDestroyed', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_PLAYER.ON_TOWER_LEVELUP, 'OnTowerLevelUp', self, EVENT_LEVEL_MEDIUM)

	EventManager:register(ET_PLAYER.ON_HERO_USE_SPELL, 'OnHeroUseSpell', self, EVENT_LEVEL_MEDIUM)

	EventManager:register(ET_PLAYER.ON_HERO_CARD_LEVELUP, 'OnPlayerHeroCardLevelUp', self, EVENT_LEVEL_MEDIUM)

	EventManager:register(ET_PLAYER.ON_COMMANDER_LEVELUP, 'OnPlayerCommanderLevelUp', self, EVENT_LEVEL_MEDIUM)
	-- EventManager:register(ET_PLAYER.ON_BUY_SHARINGITEM, 'OnPlayerBuySharingItem', self, EVENT_LEVEL_MEDIUM)
	EventManager:register(ET_ENEMY.ON_SPAWNED, 'OnEnemySpawned', self, EVENT_LEVEL_MEDIUM)
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- GAMERULES
function public:OnGameRulesStateChange()
	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		print('DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP')
	elseif state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		print('DOTA_GAMERULES_STATE_HERO_SELECTION')

		for iPlayerID = 0, PlayerResource:GetPlayerCount() - 1, 1 do
			if PlayerResource:IsValidPlayerID(iPlayerID) then
				PlayerData:InitPlayerInfo(iPlayerID)
			end
		end

		local tEnts = {
			Entities:FindByName(nil, "player_info_0"),
			Entities:FindByName(nil, "player_info_1"),
			Entities:FindByName(nil, "player_info_2"),
			Entities:FindByName(nil, "player_info_3"),
			Entities:FindByName(nil, "player_info_boss_0"),
			Entities:FindByName(nil, "player_info_boss_1"),
			Entities:FindByName(nil, "player_info_boss_2"),
			Entities:FindByName(nil, "player_info_boss_3"),
		}
		for n, hEnt in pairs(tEnts) do
			hEnt:AddCSSClasses("player_position_" .. ((n - 1) % 4))
			hEnt:IgnoreUserInput()
		end
		local tEntsflag = {
			Entities:FindAllByName("player_flag_0"),
			Entities:FindAllByName("player_flag_1"),
			Entities:FindAllByName("player_flag_2"),
			Entities:FindAllByName("player_flag_3"),
		}
		for n, tEnt in pairs(tEntsflag) do
			for _, hEnt in pairs(tEnt) do
				hEnt:AddCSSClasses("player_flag_" .. n)
				hEnt:IgnoreUserInput()
			end
		end

		DOTA_PlayerColor = {
			3372543,
			16739072,
			15986699,
			12517567,
			6750143,
			10774784,
			33569,
			6674935,
			10597447,
			16680642,
		}

		DOTA_PlayerColorVector = {}

		for i, v in ipairs(DOTA_PlayerColor) do
			local hex = string.format("%x", v)
			local x = tonumber("0x" .. string.sub(hex, 1, 2)) or 0
			local y = tonumber("0x" .. string.sub(hex, 3, 4)) or 0
			local z = tonumber("0x" .. string.sub(hex, 5, 6)) or 0
			table.insert(DOTA_PlayerColorVector, Vector(x, y, z))
			PlayerResource:SetCustomPlayerColor(i - 1, x, y, z)
		end

		DOTA_PlayerColorVector[0] = Vector(255, 255, 255)
	elseif state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		print('DOTA_GAMERULES_STATE_STRATEGY_TIME')
	elseif state == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
		print('DOTA_GAMERULES_STATE_TEAM_SHOWCASE')
	elseif state == DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD then
		print('DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD')
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		print('DOTA_GAMERULES_STATE_PRE_GAME')
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print('DOTA_GAMERULES_STATE_GAME_IN_PROGRESS')
	elseif state == DOTA_GAMERULES_STATE_POST_GAME then
		print('DOTA_GAMERULES_STATE_POST_GAME')
	elseif state == DOTA_GAMERULES_STATE_DISCONNECT then
		print('DOTA_GAMERULES_STATE_DISCONNECT')
	end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- ET_GAME
function public:OnGameBegin(params)
	DotaTD:EachPlayer(function(_, iPlayerID)
		-- 通用天赋技能
		TalentGeneral:UpdatePlayerTalentGeneral(iPlayerID)

		-- 初始化玩家卡组进入游戏
		Draw:InitPlayerCardPools(iPlayerID)
		-- 开局抽卡
		Draw:DrawStartCard(iPlayerID)

		--初始金币
		local iGold = Settings:GetInitGold(iPlayerID)
		PlayerData:ModifyGold(iPlayerID, iGold)
	end)

	--玩家幸运值开始计时
	Draw:StartLuckyTime()

	Recorder:GameStart()
end

--- 章节开始
function public:OnEpisodeBegin(params)
	--章节开始后，初始镜头聚焦在BOSS战场中央
	local vBoss = Spawner:SeeBoos(nil, Spawner:GetRound(), false, params.iDuration)
	Spawner:ShowBoos(Spawner:GetRound(), params.iDuration)

	--展示结束回归视角
	GameTimer(6, function()
		local fDuration = 1
		DotaTD:EachPlayer(function(_, iPlayerID)
			local vPos = Spawner.tTeamCameraPos[PlayerData:GetPlayerTeamID(iPlayerID)]
			local hLooker = LetMeSeeSee(iPlayerID, vBoss, fDuration, {
				duration = fDuration,
				position_x = vPos.x,
				position_y = vPos.y,
				position_z = vPos.z,
				acceleration = 10000,
			})
		end)
	end)

	local tRoundData = Spawner:GetRoundData(Spawner:GetRound() + 1)
end
--- 回合数改变
---@param params {round: number , iLastRound: number}
function public:OnRoundChange(params)
	EModifier:NotifyEvt("OnRoundChange", params)

	local iRound = params.round
	if Spawner:IsBossRound(iRound) then
		--Boss关：防御塔传送到Boss地图
		BuildSystem.typeBuildingMap = BUILDING_MAP_TYPE.BOSS
	else
		BuildSystem.typeBuildingMap = BUILDING_MAP_TYPE.BASE
	end

	--传送对应关卡地图位置
	BuildSystem:MoveBuildingToMap(nil, BuildSystem.typeBuildingMap)
	--传送指挥官去对应位置
	Commander:MoveToMap(nil, BuildSystem.typeBuildingMap)

	--处理玩家：每回合恢复，伤害统计，抽卡升级消耗更新
	PlayerData:OnRoundChange(params)

	--调整不同回合抽卡概率
	Draw:ChangeRoundDrawChance(iRound)
end
function public:OnNPCFirstSpawned(params)
	local hSpawnedUnit = EntIndexToHScript(params.entindex)
	if not IsValid(hSpawnedUnit) then
		return
	end

	if hSpawnedUnit:IsRealHero() == false then
		local sUnitName = hSpawnedUnit:GetUnitName()
		local tKV = KeyValues.UnitsKv[hSpawnedUnit:GetUnitName()]
		if tKV then
			if tKV.AttackSpeedActivityModifiers ~= nil
			or tKV.AttackRangeActivityModifiers ~= nil
			or tKV.MovementSpeedActivityModifiers ~= nil
			then
				hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_activity_modifiers", nil)
			end

			-- 初始modifier
			if tKV.AmbientModifiers then
				hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, tKV.AmbientModifiers, nil)
			end
		end
	end

	--英雄出生
	if IsValid(hSpawnedUnit) and hSpawnedUnit:IsRealHero() then
		local iPlayerID = GetPlayerID(hSpawnedUnit)
		if iPlayerID and -1 ~= iPlayerID then
			---@class EventData_ON_PLAYER_HERO_SPAWNED
			local tEvent = {
				PlayerID = iPlayerID,
				hUnit = hSpawnedUnit,
			}
			EventManager:fireEvent(ET_PLAYER.ON_PLAYER_HERO_SPAWNED, tEvent)
		end
	end

	if (hSpawnedUnit:GetUnitName() ~= 'npc_dota_thinker'
	and hSpawnedUnit:GetUnitName() ~= 'npc_dota_dummy'
	and hSpawnedUnit:GetUnitName() ~= 'npc_hitbox')
	then
		-- 注册修正伤害
		hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_fix_damage", nil)
	end
end
---@param tEvent EventData_ON_PLAYER_HERO_SPAWNED
function public:OnPlayerHeroSpawned(tEvent)
	PlayerData:SetHero(tEvent.PlayerID, tEvent.hUnit)

	--玩家位置
	Birthplace:SetPlayerInBirthplace(tEvent.PlayerID)
	--初始化信使模型特效称号相关
	Courier:InitPlayerUnit(tEvent.PlayerID, tEvent.hUnit)

	-- 添加modifier
	tEvent.hUnit:AddNewModifier(tEvent.hUnit, nil, "modifier_builder", nil)

	--消失血条buff
	tEvent.hUnit:AddNewModifier(tEvent.hUnit, nil, 'modifier_no_health_bar', nil)

	--归零数据
	PlayerData:UpdatePlayerHealthInfo(tEvent.PlayerID)

	--创建指挥官
	Commander:InitPlayerCommander(tEvent.PlayerID)

	--补齐法术卡
	HandSpellCards:InitPlayerSpellCard(tEvent.PlayerID)

	-- --添加消耗品
	Consumable:OnPlayerHeroSpawned(tEvent)
end
--- 物品升星
---tEvent { PlayerID = iPlayerID, iItemID = iItemID, level = 1 }
function public:OnPlayerItemLvlUpdate(tEvent)
end
function public:OnGameEnd(params)
	if 0 == PlayerData:GetAlivePlayerCount() then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	else
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end
end
function public:OnGameBalance(params)
	-- Recorder:GameEnd()
end

---单位被击杀
function public:OnEntityKilled(tEvent)
	-- 	game_event_name	entity_killed
	-- damagebits	0
	-- game_event_listener	503316484
	-- entindex_attacker	497
	-- entindex_killed	490
	-- splitscreenplayer	-1
	local hUnit = EntIndexToHScript(tEvent.entindex_killed)

	EventManager:fireEvent(ET_GAME.NPC_DEATH, tEvent)

	-- 自动单位销毁
	if IsValid(hUnit) then
		if not hUnit:UnitCanRespawn() then
			hUnit:GameTimer('UnitDestroy', 5, function()
				if hUnit:IsAlive() then
					return
				end
				local tBuffs = hUnit:FindAllModifiers()
				for _, hBuff in pairs(tBuffs) do
					if IsValid(hBuff) then
						hBuff:Destroy()
					end
				end

				---@class EventData_NPC_DESTROYED
				local tEvent2 = {
					iEntID = tEvent.entindex_killed
				}
				EventManager:fireEvent(ET_GAME.NPC_DESTROYED, tEvent2)

				UTIL_Remove(hUnit)
			end)
		end
	else
		EventManager:fireEvent(ET_GAME.NPC_DESTROYED, {
			iEntID = tEvent.entindex_killed
		})
	end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- ET_BATTLE
--- 备战阶段
function public:OnPreparation(params)
	EModifier:NotifyEvt("OnPreparation", params)

	Spawner:StartRoundTimer()

	local tRoundData = Spawner:GetRoundData()

	-- 检查是否需要 选择法术牌
	SelectSpellCard:CheckSelectSepllCard(tRoundData)

	-- Boss回合给本地玩家建筑添加颜色光环
	BuildSystem:OnPreparation_AddColorAura()


	--重置棋子
	BuildSystem:ResetUnitOnPreparation()
	--重置指挥官
	-- Commander:ResetUnitOnPreparation()
end
--- 备战结束
function public:OnPreparationEnd(params)
	EModifier:NotifyEvt("OnPreparationEnd", params)
	DotaTD:EachPlayer(function(iTeamNum, iPlayerID)
		PlayerData:UpdatePlayerHealthInfo(iPlayerID, 0, true)
	end)
end
--- 战斗阶段
function public:OnInBattle(params)
	BuildSystem:OnInBattle()
	Spawner:StartWaveTimer(Spawner:GetRound())

	DotaTD:EachPlayer(function(n, playerID)
		Recorder:PlayerStartRound(playerID)
	end)

	--- 创建完战斗单位广播
	EModifier:NotifyEvt("OnInBattle", params)
end
--- 战斗结束
function public:OnBattleEnd(params)
	EModifier:NotifyEvt("OnBattleEnd", params)

	--确定玩家胜负
	PlayerData:OnBattleEnd_SetPlayerResult(Spawner:GetRound())

	--玩家掉血
	if not Spawner:IsBossRound() then
		--BOSS回合等吟唱后扣
		PlayerData:LosePlayerHP()
	end
end
--- Boss爆炸阶段
function public:OnBossBomb(params)
end
--- 战斗结束等待阶段 开始
function public:OnBattleEndWaitStart(params)

	--宝箱回合结算
	if Spawner:IsGoldRound() then
		Spawner:CheckGoldCreeps()
	end

	--结算回合奖励
	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsAlive(iPlayerID) then
			if Game.tRoundBalanceRecord[iPlayerID] then return end
			if 1 == PlayerData:GetPlayerRoundResult(iPlayerID, Spawner:GetRound()) then return end

			self:RoundBalance(iPlayerID)
		end
	end)
	Game.tRoundBalanceRecord = {}

	local tRoundData = Spawner:GetRoundData()
	if tRoundData then
		-- 检查是否需要 五谷丰登
		SelectItem:CheckSelectItemOnBattleEnd(tRoundData)
	end

	--清除该轮怪物
	Spawner:ClearEnemy()
end
function public:RoundBalance(iPlayerID)
	--重置棋子
	BuildSystem:ResetUnitOnBattleEnd(iPlayerID)
	--重置指挥官
	Commander:ResetUnitOnBattleEnd(iPlayerID)

	--战斗结算 发送给客户端数据
	local tResult = {
		--回合奖励
		round_gold = {},
		win_gold = {},
		win_crystal = {},
		player_win = PlayerData:GetPlayerRoundResult(nil, Spawner:GetRound()),
		gold_round_lost = PlayerData:GetPlayerGoldRoundLost(nil, Spawner:GetRound()),
	}

	--结算回合奖励
	local tRoundData = Spawner:GetRoundData()
	if tRoundData then
		local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
		if IsValid(hHero) and hHero:IsAlive() and not PlayerData:IsPlayerDeath(iPlayerID) then
			local iGold = 0
			local fGoldRate = PlayerData:GetPlayerRoundGoldPercentage(iPlayerID) * 0.01
			local iCrystal = 0

			tResult.round_gold[iPlayerID] = tonumber(tRoundData.round_gold) * fGoldRate
			iGold = iGold + tResult.round_gold[iPlayerID]

			if 1 == PlayerData:GetPlayerRoundResult(iPlayerID, Spawner:GetRound()) then
				-- 全清奖励计算
				tResult.win_gold[iPlayerID] = tonumber(tRoundData.bonus_round_gold) * fGoldRate
				iGold = iGold + tResult.win_gold[iPlayerID]

				tResult.win_crystal[iPlayerID] = tonumber(tRoundData.bonus_round_crystal)

				iCrystal = iCrystal + tResult.win_crystal[iPlayerID]
			end

			PlayerData:ModifyGold(iPlayerID, iGold)
			PlayerData:ModifyCrystal(iPlayerID, iCrystal)
		end
	end
	--结算税收奖励
	tResult.tax = HeroCardData:JudgeTax(iPlayerID)
	--发送战斗结算信息
	local player = PlayerResource:GetPlayer(iPlayerID)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "custom_battle_result", tResult)
	end

	-- 后台数据记录
	local iTax = 0
	if tResult.tax[iPlayerID] then
		for k, iGold in pairs(tResult.tax[iPlayerID]) do
			iTax = iTax + iGold
		end
	end
	local tData = {
		-- 玩家漏怪数量
		miss_enemy = Spawner:GetPlayerRoundMissCount(iPlayerID),
		tax = iTax
	}
	Recorder:ReqPlayerRoundResult(iPlayerID, tData)
end
--- 战斗结束等待阶段 结束
function public:OnBattleEndWaitEnd(params)
	--Boss战结束等待完成
	if Spawner:IsBossRound() then
		-- GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
		--视角回归
		DotaTD:EachPlayer(function(_, iPlayerID)
			Spawner:SeePlayer(iPlayerID, iPlayerID)
		end)
	end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- ET_PLAYER
function public:OnAllLoadedFinished(params)
	-- local function Enter()
	-- GameRules:GetGameModeEntity():GameTimer(UI_INTERVAL, function() PlayerData:UpdateNetTables() return UI_INTERVAL end)
	-- GameRules:GetGameModeEntity():Timer(0, function() PlayerData:CorrectGold() return 0 end)
	-- end
end
--- 玩家加载：初始化玩家数据
function public:OnLoadedFinished(params)
	local iPlayerID = params.PlayerID

	ChangePlayerTeam(iPlayerID, DOTA_TEAM_GOODGUYS)

	local hPlayer = PlayerResource:GetPlayer(iPlayerID)
	if hPlayer ~= nil then
		hPlayer:SetSelectedHero(FORCE_PICKED_HERO)
	end

	Artifact:InitPlayerData(iPlayerID)
	PlayerBuildings:InitPlayerData(iPlayerID)
	BuildSystem:UpdateNetTables()
	HeroCardData:InitPlayerHandCardData(params)
	HandSpellCards:InitPlayerSpellCardData(params)
	Items:InitPlayerItemData(params)
	PlayerData:InitPlayerBaseData(params)
	SelectItem:InitPlayerSelectItemData(params)
	Spawner:InitPlayerSpawnerData(params)
	Commander:InitPlayerInfo(iPlayerID)
	Draw:InitPlayerData(iPlayerID)
	Contract:InitPlayerData(iPlayerID)
end

--- 玩家受到伤害
function public:OnDamage(params)
	local iDamage = params.damage
	local iPlayerID = params.PlayerID
	PlayerData:ModifyHealth(iPlayerID, -iDamage)
end
--- 玩家死亡
function public:OnDeath(params)
	local iPlayerID = params.PlayerID

	-- 清除金币魂晶
	PlayerData:ModifyGold(iPlayerID, -PlayerData:GetGold(iPlayerID), false)
	PlayerData:ModifyCrystal(iPlayerID, -PlayerData:GetCrystal(iPlayerID), false)

	-- 清除全部英雄
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		BuildSystem:RemoveBuilding(hBuilding:GetUnitEntity())
	end)

	-- 清除抽卡列表
	Draw.tPlayerCardSelectionList[iPlayerID] = {}
	Draw.tPlayerSpellCardSelectionList[iPlayerID] = {}
	Draw:UpdateNetTables()

	-- 清除全部物品
	Items:RemoveAllItem(iPlayerID)

	-- 清除全部神器
	Artifact:RemoveAll(iPlayerID)

	-- 清除全部法术卡
	HandSpellCards:RemoveAll(iPlayerID)
	-- 清除全部英雄卡
	HeroCardData:RemoveAll(iPlayerID)

	-- local bAllDeath = true
	-- DotaTD:EachPlayer(function(_, iPlayerID)
	-- 	if not PlayerData:IsPlayerDeath(iPlayerID) then
	-- 		bAllDeath = false
	-- 	end
	-- end)
end

function public:OnEnemyCountChange(params)
end
---@param params EventData_PlayerRoundResult
function public:OnRoundResult(params)
	local iPlayerID = params.PlayerID
	Recorder:PlayerEndRound(iPlayerID)

	if 1 == params.is_win then
		Game.tRoundBalanceRecord[iPlayerID] = true
		-- 个人先打完结算
		self:RoundBalance(iPlayerID)
	end
end
function public:OnLevelChanged(params)
	local iPlayerID = params.PlayerID
	local iChange = params.iChange
	local iCount = params.iCount
	PlayerBuildings:SetPlayerMaxBuildingCount(iPlayerID, math.min(HERO_BUILDING_MAX_COUNT, BUILDING_MIN_COUNT + iCount - 1))

	--更新抽卡，升级的消耗金币数
	if PlayerData.playerDatas[iPlayerID] then
		PlayerData.playerDatas[iPlayerID].gold_cost_draw_card = GET_DRAW_CARD_COST_GOLD_ALL(iPlayerID)
		PlayerData.playerDatas[iPlayerID].gold_cost_levelup = GET_LEVELUP_COST_GOLD(iPlayerID)
	end
	PlayerData:UpdateNetTables()
end
function public:OnConnectStateChanged(params)
	local iPlayerID = params.PlayerID
	local last_state = params.last_state
	local state = params.state

	print('Player connection state change. player id is ', iPlayerID)

	-- DOTAConnectionState_t.DOTA_CONNECTION_STATE_UNKNOWN	0
	-- DOTAConnectionState_t.DOTA_CONNECTION_STATE_NOT_YET_CONNECTED	1
	-- DOTAConnectionState_t.DOTA_CONNECTION_STATE_CONNECTED	2
	-- DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED	3
	-- DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED	4
	-- DOTAConnectionState_t.DOTA_CONNECTION_STATE_LOADING	5
	-- DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED	6
	if state == DOTA_CONNECTION_STATE_DISCONNECTED then
		print('DOTA_CONNECTION_STATE_DISCONNECTED')
	elseif state == DOTA_CONNECTION_STATE_CONNECTED then
		print('DOTA_CONNECTION_STATE_CONNECTED')
	end
end

function public:OnTowerSpawned(params)
	BuildSystem:OnTowerSpawned(params)
	BuildSystem:OnTowerSpawned_AddColorAura(params)
end

---@param params EventData_ON_TOWER_SELL
function public:OnTowerSell(params)
	local hBuilding = params.hBuilding

	-- 建筑出售：归还其身上物品
	local hUnit = hBuilding:GetUnitEntity()
	if IsValid(hUnit) then
		local iPlayerID = hUnit:GetPlayerOwnerID()

		--卸下全部装备
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			local hItem = hUnit:GetItemInSlot(i)
			if hItem and hItem.tItemData then
				Items:ItemTake(iPlayerID, hItem.tItemData.iItemID)
			end
		end
	end

	--卡牌回归卡池
	Draw:ModifyCardCountInPlayerPool(hBuilding:GetPlayerOwnerID(), hBuilding:GetUnitEntityName(), hBuilding:GetCurrentXP() + 1)
end
function public:OnTowerDeath(params)
	-- local hBuilding = params.hBuilding
	-- local iPlayerID = hBuilding:GetPlayerOwnerID()
	-- if not Spawner:IsBossRound() then
	-- 	local bAllDeath = true
	-- 	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
	-- 		if not hBuilding:IsDeath() then
	-- 			bAllDeath = false
	-- 		end
	-- 	end)
	-- 	--该玩家防御塔全部死亡
	-- 	if bAllDeath then
	-- 		for _, hUnit in pairs(Spawner:GetMissing(iPlayerID)) do
	-- 			hUnit:AddNewModifier(hUnit, nil, "modifier_movespeed_alldeath", nil)
	-- 		end
	-- 	end
	-- end
end
function public:OnTowerToCard(params)
	local hBuilding = params.hBuilding
	local hUnit = hBuilding:GetUnitEntity()
	if IsValid(hUnit) then
		local iPlayerID = hUnit:GetPlayerOwnerID()
		local tCardData = params.tCardData
		local iCardID = tCardData.iCardID
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			local hItem = hUnit:GetItemInSlot(i)
			if hItem and hItem.tItemData then
				--装备物品给卡牌
				-- Items:ItemGiveCard(iPlayerID, hItem.tItemData.iItemID, iCardID, i)
				Items:ItemTake(iPlayerID, hItem.tItemData.iItemID)
			end
		end
	end
end

---@param params EventData_ON_TOWER_CARD_SELL
function public:OnTowerCardSell(params)
	local iPlayerID = params.PlayerID
	local tCardData = params.tCardData
	local iCardID = params.iCardID
	local sCardName = params.tCardData.sCardName

	--重置在卡牌上的物品
	for k, tData in pairs(tCardData.tItems) do
		Items:ItemTake(iPlayerID, tData.iItemID)
	end

	--卡牌回归卡池
	Draw:ModifyCardCountInPlayerPool(iPlayerID, sCardName, tCardData.iXP + 1)
end
---@param params EventData_ON_TOWER_CARD_EXCHANGE
function public:OnTowerCardExchange(params)
	local iPlayerID = params.PlayerID
	local tCardData = params.tCardData
	local iCardID = params.iCardID
	local sCardName = params.tCardData.sCardName

	--重置在卡牌上的物品
	for k, tData in pairs(tCardData.tItems) do
		Items:ItemTake(iPlayerID, tData.iItemID)
	end
end
function public:OnTowerSpawnedFromCard(params)
	BuildSystem:UpdataBuildingAbilityTag(params.PlayerID)

	local iPlayerID = params.PlayerID
	local tCardData = params.tCardData
	local iCardID = params.iCardID
	local hBuilding = params.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	--创建卡牌上的物品给建筑实体
	for k, tData in pairs(tCardData.tItems) do
		Items:ItemGive(iPlayerID, tData.iItemID, hUnit, tData.iItemSlot)
	end
end
function public:OnTowerLevelUpFromCard(params)
	local iPlayerID = params.PlayerID

	BuildSystem:UpdataBuildingAbilityTag(iPlayerID)

	local tCardData = params.tCardData
	local iCardID = params.iCardID
	local hBuilding = params.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	--创建卡牌上的物品给建筑实体
	for k, tData in pairs(tCardData.tItems) do
		Items:ItemTake(iPlayerID, tData.iItemID)
		local hItem = Items:ItemGive(iPlayerID, tData.iItemID, hUnit)
	end
end
function public:OnTowerNewItemEntity(params)
	local iPlayerID = params.PlayerID
	local hItem = params.hItem
	local hBuilding = params.hBuilding
end
function public:OnTowerDestroyItemEntity(params)
	local iPlayerID = params.PlayerID
	local hItem = params.hItem
	local hBuilding = params.hBuilding
end
function public:OnTowerDestroy(params)
	local iPlayerID = params.PlayerID
	local hBuilding = params.hBuilding
	local hUnit = hBuilding:GetUnitEntity()
	if IsValid(hUnit) then
		Items:ItemTakeByEntID(iPlayerID, hUnit:GetEntityIndex())
	end
end
function public:OnTowerDestroyed(params)
	BuildSystem:UpdataBuildingAbilityTag(params.PlayerID)
end
function public:OnTowerLevelUp(params)
	-- params
	-- PlayerID
	-- hBuilding
	-- iLevel
	-- iLevelOld
	local iPlayerID = params.PlayerID
	EmitSoundForPlayer('T3.ui_level_up_01', iPlayerID)
end
--- 指挥官使用技能卡
---@param params {iPlayerID: number, sCardName:string}
function public:OnHeroUseSpell(params)
	EModifier:NotifyEvt("OnHeroUseSpell", params)
end
--- 玩家英雄卡升级
---params: {PlayerID,iLevel,iLastLevel,hCard}
function public:OnPlayerHeroCardLevelUp(params)
	local iPlayerID = params.PlayerID
	if params.iLevel ~= params.iLastLevel then
		--- 累计升级任务
		EmitSoundForPlayer('T3.ui_level_up_01', iPlayerID)
	end
end
--- 玩家指挥官升级
---params: {PlayerID,iLevel,iLastLevel}
function public:OnPlayerCommanderLevelUp(params)
	local iPlayerID = params.PlayerID
	if params.iLevel ~= params.iLastLevel then
	end
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--ET_ENEMY
--- 怪物出生
---@param params {PlayerID:number, hUnit:handle}
function public:OnEnemySpawned(params)
	EModifier:NotifyEvt("OnEnemySpawned", { iPlayerID = params.PlayerID, hUnit = params.hUnit })
end
return public