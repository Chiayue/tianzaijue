if nil == PlayerData then
	---@class PlayerData
	PlayerData = {
		---@type PlayerOneData[]
		playerDatas = {}, --玩家数据
		playerRoundDamage = {}, --玩家回合伤害统计
		tDamageRecord = {}, --一次要发送的伤害数据
		playerRoundResult = {}, --玩家回合胜负结果统计
		tPlayerHeroes = {},

		tPlayerGoldRoundLost = {}, --玩家宝箱回合损失的金币统计

		tAbilityData = {}, -- 技能数据(记录永久成长的数据)
	}
	PlayerData = class({}, PlayerData)
end
---@type PlayerData
local public = PlayerData

UI_INTERVAL = 0.5

function public:init(bReload)
	if not bReload then
		self.playerDatas = {}
		self.playerRoundDamage = {}
		self.tDamageRecord = {}
		self.playerRoundResult = {}
		self.tPlayerGoldRoundLost = {}
		self.tPlayerHeroes = {}
		self.tConnectState = {}
		self.tAbilityData = {}
	end
	-- 修改器类型
	EventManager:register(ET_GAME.GAME_BEGIN, 'OnGameBegin', self)
	EventManager:register(ET_GAME.NPC_DEATH, 'OnNPCDeath', self)
	EventManager:register(ET_ENEMY.ON_ENTER_DOOR, 'OnEnemyEnterDoor', self)
	EventManager:register(ET_PLAYER.ON_TOWER_DEATH, 'OnTowerDeath', self)
	EventManager:register(ET_BATTLE.ON_BATTLEING, 'OnBattleing', self)
	EventManager:register(ET_BATTLE.ON_BATTLEING_ENDWAIT_END, 'OnBattleingWaitEnd', self)
	EventManager:register(ET_PLAYER.ON_COMMANDER_SPAWNED, 'OnCommanderSpawned', self)
	EventManager:register(ET_GAME.DAMAGE_FILTER, 'OnDamageFilter', self)
	EventManager:register(ET_GAME.ROUND_CHANGE, 'OnRoundChange', self)

	CustomUIEvent("PlayerOperate_LevelUp", Dynamic_Wrap(public, "OnPlayerOperate_LevelUp"), public)
	CustomUIEvent("PlayerNeedCard", Dynamic_Wrap(public, "PlayerNeedCard"), public)
	CustomUIEvent("PlayerNeedTag", Dynamic_Wrap(public, "PlayerNeedTag"), public)
	ListenToGameEvent("player_chat", Dynamic_Wrap(public, "OnPlayerChat"), public)
	CustomUIEvent("custom_damage_record_total_get", Dynamic_Wrap(public, "OnClientGetTatalDamageRecord"), public)

	-- self:UpdateNetTables()
	self:SendDamageRecordThinker()
end

-- 游戏开始初始化玩家信息
function public:InitPlayerInfo(iPlayerID)
	GameTimer('PlayerData_ConnectionState' .. iPlayerID, 0, function()
		if self.tConnectState[iPlayerID] ~= PlayerResource:GetConnectionState(iPlayerID) then
			---@class EventData_CONNECT_STATE_CHANGE
			local tEvent = {
				PlayerID = iPlayerID,
				last_state = self.tConnectState[iPlayerID],
				state = PlayerResource:GetConnectionState(iPlayerID)
			}
			EventManager:fireEvent(ET_PLAYER.CONNECT_STATE_CHANGE, tEvent)
			self.tConnectState[iPlayerID] = PlayerResource:GetConnectionState(iPlayerID)


			if tEvent.state == DOTA_CONNECTION_STATE_ABANDONED then
				-- 放弃
				if PlayerData:IsAlive(iPlayerID) then
					PlayerData:ModifyHealth(iPlayerID, -PlayerData:GetHealth(iPlayerID))
				end
			elseif tEvent.state == DOTA_CONNECTION_STATE_DISCONNECTED then
				-- 断线
			end

			if tEvent.last_state == DOTA_CONNECTION_STATE_DISCONNECTED
			and tEvent.state == DOTA_CONNECTION_STATE_CONNECTED then
				-- 重新连接
				-- -run GameRules:SendCustomMessage(tostring(PlayerResource:GetTeam(0)), 0,0)
				-- -run GameRules:SendCustomMessage(tostring(PlayerResource:GetPlayer(0):GetTeam()), 0,0)
				-- -run GameRules:SendCustomMessage(tostring(PlayerResource:GetPlayerCountForTeam(2)), 0,0)
				-- -run GameRules:SendCustomMessage(tostring(PlayerData:GetHero(0):GetTeamNumber()), 0,0)
				-- -run ChangePlayerTeam(0,6)
				-- -run PlayerResource:SetCustomTeamAssignment(0, 6)
				-- -run GameRules:SetCustomGameTeamMaxPlayers(2, 1)
			end
		end

		local hHero = PlayerData:GetHero(iPlayerID)
		if IsValid(hHero) then
			local typeHeroTeam = hHero:GetTeamNumber()
			local hPlayer = PlayerResource:GetPlayer(iPlayerID)
			if IsValid(hPlayer) then
				local typePlayerTeam = hPlayer:GetTeam()
				if typeHeroTeam ~= typePlayerTeam then
					ChangePlayerTeam(iPlayerID, typeHeroTeam)
				end
			end
		end

		return 0.5
	end)
end

--UI事件************************************************************************************************************************
	do
	--升级玩家人口
	function public:OnPlayerOperate_LevelUp(eventSourceIndex, events)
		local iPlayerID = events.PlayerID

		--上限
		if self:GetPlayerLevel(iPlayerID) >= PLAYER_LEVEL_MAX then
			return
		end

		--金币不足
		local iGold = GET_LEVELUP_COST_GOLD(iPlayerID)
		if PlayerData:GetGold(iPlayerID) < iGold then
			return
		end

		PlayerData:ModifyGold(iPlayerID, -iGold)
		self:AddPlayerLevel(iPlayerID, 1)
	end

	function public:PlayerNeedCard(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local sCardName = events.card_name

		if self:CheckPlayerMessageCD(iPlayerID) then
			return
		end

		CustomGameEventManager:Send_ServerToAllClients("drodo_chat", {
			player_id = iPlayerID,
			text = sCardName,
			time_stamp = math.floor(GameRules:GetGameTime()),
			type = 'need_hero',
		})
	end
	function public:PlayerNeedTag(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local sTag = events.tag

		if self:CheckPlayerMessageCD(iPlayerID) then
			return
		end

		CustomGameEventManager:Send_ServerToAllClients("drodo_chat", {
			player_id = iPlayerID,
			text = sTag,
			time_stamp = math.floor(GameRules:GetGameTime()),
			type = 'need_tag',
		})
	end
	function public:CheckPlayerMessageCD(iPlayerID)
		if not self.tPlayerMessageCD then self.tPlayerMessageCD = {} end
		if not self.tPlayerMessageCD[iPlayerID] then
			self.tPlayerMessageCD[iPlayerID] = {
				time = 0,
				iCount = 0,
			}
		end
		if 3 <= (GameRules:GetGameTime() - self.tPlayerMessageCD[iPlayerID].time) then
			self.tPlayerMessageCD[iPlayerID] = {
				time = 0,
				iCount = 0,
			}
		else
			if 3 <= self.tPlayerMessageCD[iPlayerID].iCount then
				return true
			end
		end
		self.tPlayerMessageCD[iPlayerID].iCount = self.tPlayerMessageCD[iPlayerID].iCount + 1
		self.tPlayerMessageCD[iPlayerID].time = GameRules:GetGameTime()
	end
end
--事件监听************************************************************************************************************************
	do
	--- 玩家加载完成，初始化玩家基础数据
	function public:InitPlayerBaseData(tEvent)
		local iPlayerID = tEvent.PlayerID
		-- local tEnts = {
		-- 	Entities:FindByName(nil, "player_avatar_0"),
		-- 	Entities:FindByName(nil, "player_avatar_1"),
		-- 	Entities:FindByName(nil, "player_avatar_2"),
		-- 	Entities:FindByName(nil, "player_avatar_3"),
		-- }
		-- for n, hEnt in pairs(tEnts) do
		-- 	hEnt:AddCSSClasses("player_position_"..n)
		-- 	hEnt:IgnoreUserInput()
		-- end
		-- 初始化玩家数据
		---@class PlayerOneData
		local tPlayerOneData = {
			team_id = self:GetPlayerTeamID(iPlayerID),
			is_death = 0, --玩家是否死亡，1为阵亡

			player_level = 1, --玩家等级，人口
			gold_cost_draw_card = GET_DRAW_CARD_COST_GOLD_ALL(iPlayerID), --一阶抽卡消耗
			gold_cost_levelup = GET_LEVELUP_COST_GOLD(iPlayerID), --升级人口消耗

			gold = 0,
			spend_gold = 0,
			total_gold = 0,
			crystal = 0,
			spend_crystal = 0,
			total_crystal = 0,

			take_damage = 0, -- 受到伤害
			mana = PLAYER_MANA, --玩家魔法
			health = PLAYER_HEALTH, --玩家生命
			mana_max = PLAYER_MANA,
			health_max = PLAYER_HEALTH,
			mana_regen = PLAYER_MANA_REGEN, -- 每回合魔法恢复
			health_regen = PLAYER_HEALTH_REGEN, -- 每回合生命恢复

			commander_id = -1,

			common_refreshtimes = self:GetRefreshTimes(iPlayerID),
			max_refreshtimes = GET_MAX_MATCH_REFRESH_TIMES,

			account_id = GetAccountID(iPlayerID),
		}

		self.playerDatas[iPlayerID] = tPlayerOneData
		self.playerRoundDamage[iPlayerID] = {}
		self.playerRoundResult[iPlayerID] = {}
		self.tPlayerGoldRoundLost[iPlayerID] = {}
		self.tAbilityData[iPlayerID] = {}
		self:UpdateNetTables()
	end

	---@param bSet boolen 累计iDamage 承受伤害 true直接设置 false 累加
	function public:UpdatePlayerHealthInfo(iPlayerID, iDamage, bSet)
		iDamage = iDamage or 0
		bSet = bSet or false
		local tPlayerData = self.playerDatas[iPlayerID]
		if tPlayerData then
			if bSet then
				tPlayerData.take_damage = iDamage
			else
				tPlayerData.take_damage = iDamage + tPlayerData.take_damage
			end
			self:UpdateNetTables()
		end
	end

	--单位死亡
	function public:OnNPCDeath(tEvent)
		local hUnit = EntIndexToHScript(tEvent.entindex_killed)
		if not IsValid(hUnit) then return end
		if not hUnit.Spawner_spawnerPlayerID then return end
		if GSManager:getStateType() ~= GS_Battle then return end

		local function doonce(iPlayerID)
			if self:IsPlayerDeath(iPlayerID) then return end

			local iLostCount = Spawner:GetPlayerNoSpawnCount(iPlayerID) + Spawner:GetPlayerMissingCount(iPlayerID)
			if 0 >= iLostCount then
				--该玩家怪物全部死亡
				if Spawner:IsBossRound() then
					--Boss回合，全部玩家胜利
					self:SetPlayerRoundResult(iPlayerID, Spawner:GetRound(), true)
				else
					--普通回合，胜负取决是否有怪进门
					self:SetPlayerRoundResult(iPlayerID, Spawner:GetRound(), 0 == Spawner:GetPlayerEnterDoorCount(iPlayerID))
				end
			end
		end

		if - 1 == hUnit.Spawner_spawnerPlayerID then
			--公共单位死亡判断全部玩家
			DotaTD:EachPlayer(function(_, iPlayerID)
				doonce(iPlayerID)
			end)
		else
			doonce(hUnit.Spawner_spawnerPlayerID)
		end
	end
	---怪物进入传送门
	function public:OnEnemyEnterDoor(tEvent)
		local hUnit = EntIndexToHScript(tEvent.entindex)
		if not IsValid(hUnit) then return end
		local iPlayerID = hUnit.Spawner_spawnerPlayerID
	end
	---玩家防御棋子死亡
	function public:OnTowerDeath(tEvent)
		local hBuilding = tEvent.hBuilding
		local iPlayerID = hBuilding:GetPlayerOwnerID()

		--Boss回合全部玩家全部棋子死亡玩家失败
		if Spawner:IsBossRound() then
			local bAllDeath = true
			BuildSystem:EachBuilding(function(hBuilding)
				if not hBuilding:IsDeath() then
					bAllDeath = false
				end
			end)

			--该玩家防御塔全部死亡
			if bAllDeath then
				DotaTD:EachPlayer(function(_, iPlayerID2)
					if self:IsPlayerDeath(iPlayerID2) then return end
					self:SetPlayerRoundResult(iPlayerID2, Spawner:GetRound(), false)
				end)
			end
		end
	end

	---战斗结束设置剩余玩家胜负结果
	function public:OnBattleEnd_SetPlayerResult(iRound)
		DotaTD:EachPlayer(function(_, iPlayerID)
			if self:IsPlayerDeath(iPlayerID) then return end

			if Spawner:IsGoldRound() then
				--宝箱关：时间到了宝箱没跑算胜利
				if not self:GetPlayerRoundResult(iPlayerID, iRound) then
					self:SetPlayerRoundResult(iPlayerID, iRound, true)
					return
				end
			end
			if not self:GetPlayerRoundResult(iPlayerID, iRound) then
				self:SetPlayerRoundResult(iPlayerID, iRound, false)
				return
			end
		end)
	end

	--- 游戏开始
	function public:OnGameBegin()
		DotaTD:EachPlayer(function(_, iPlayerID)
			--更新抽卡，升级的消耗金币数
			if PlayerData.playerDatas[iPlayerID] then
				PlayerData.playerDatas[iPlayerID].gold_cost_draw_card = GET_DRAW_CARD_COST_GOLD_ALL(iPlayerID)
				PlayerData.playerDatas[iPlayerID].gold_cost_levelup = GET_LEVELUP_COST_GOLD(iPlayerID)
			end
		end)
		PlayerData:UpdateNetTables()
	end

	--- 回合数改变
	---@param tEvent EventData_RoundChange
	function public:OnRoundChange(tEvent)
		DotaTD:EachPlayer(function(_, iPlayerID)
			self.playerRoundResult[iPlayerID][tEvent.round] = nil

			--恢复
			self:AddHealth(iPlayerID, self:GetHealthRegen(iPlayerID))
			self:AddMana(iPlayerID, self:GetManaRegen(iPlayerID))

			--伤害统计
			if PlayerData.playerRoundDamage[iPlayerID] then
				if #PlayerData.playerRoundDamage[iPlayerID] > 0 then
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "show_round_damage", PlayerData.playerRoundDamage[iPlayerID][#PlayerData.playerRoundDamage[iPlayerID]])
				end
				local iIndex = Spawner:GetRound()
				PlayerData.playerRoundDamage[iPlayerID][iIndex] = {}
			end

			--更新抽卡，升级的消耗金币数
			if PlayerData.playerDatas[iPlayerID] then
				PlayerData.playerDatas[iPlayerID].gold_cost_draw_card = GET_DRAW_CARD_COST_GOLD_ALL(iPlayerID)
				PlayerData.playerDatas[iPlayerID].gold_cost_levelup = GET_LEVELUP_COST_GOLD(iPlayerID)
			end
		end)
		PlayerData:UpdateNetTables()
	end

	-- 更新抽卡，升级的消耗金币数
	function public:RefreshPlayerData()
		DotaTD:EachPlayer(function(_, iPlayerID)
			--更新抽卡，升级的消耗金币数
			if PlayerData.playerDatas[iPlayerID] then
				PlayerData.playerDatas[iPlayerID].gold_cost_draw_card = GET_DRAW_CARD_COST_GOLD_ALL(iPlayerID)
				PlayerData.playerDatas[iPlayerID].gold_cost_levelup = GET_LEVELUP_COST_GOLD(iPlayerID)
			end
		end)
		PlayerData:UpdateNetTables()
	end
	--- 战斗开始
	function public:OnBattleing()
		if Spawner:IsBossRound() then
			GameTimer(0.1, function()
				--开局没棋子算输
				local bHasBuilding
				BuildSystem:EachBuilding(function()
					bHasBuilding = true
					return true
				end)
				if not bHasBuilding then
					DotaTD:EachPlayer(function(_, iPlayerID)
						if self:IsPlayerDeath(iPlayerID) then return end
						self:SetPlayerRoundResult(iPlayerID, Spawner:GetRound(), false)
					end)
				end
			end)
		end
	end
	--- 战斗结束
	function public:OnBattleingWaitEnd()
		BuildSystem:EachBuilding(function(hBuilding)
			local hUnit = hBuilding:GetUnitEntity()
			if IsValid(hUnit) then
				hUnit:RemoveGesture(ACT_DOTA_VICTORY)
			end
		end)
	end

	--- 指挥官创建
	---@param tEvent EventData_ON_COMMANDER_SPAWNED
	function public:OnCommanderSpawned(tEvent)
		local iPlayerID = tEvent.PlayerID
		if PlayerData.playerDatas and PlayerData.playerDatas[iPlayerID] then
			PlayerData.playerDatas[iPlayerID].commander_id = tEvent.hCommander:GetEntityIndex()
			PlayerData.playerDatas[iPlayerID].commander_name = tEvent.hCommander:GetUnitName()
			PlayerData:UpdateNetTables()
		end
	end

	---监听伤害，统计
	---@param tEvent EventData_DAMAGE_FILTER
	function public:OnDamageFilter(tEvent)
		local hAttacker = tEvent.hAttacker
		local hVictim = tEvent.hVictim
		local iDamageType = tEvent.typeDamage
		local fDamage = tEvent.fDamage

		if IsValid(hAttacker) and hAttacker ~= hVictim then
			local iPlayerID = GetPlayerID(hAttacker)
			if PlayerResource:IsValidPlayerID(iPlayerID) then
				hAttacker = hAttacker.GetSource and hAttacker:GetSource()
				local hHero = PlayerData:GetHero(iPlayerID)
				if IsValid(hAttacker) and IsValid(hHero) then
					if hHero:IsFriendly(hAttacker) then

						if hAttacker == hHero then
							hAttacker = Commander:GetCommander(iPlayerID) or hHero
						end

						local sUnitName = hAttacker:GetUnitName()
						local tRoundDamage = PlayerData.playerRoundDamage[iPlayerID][Spawner:GetRound()]
						if tRoundDamage == nil then
							tRoundDamage = {}
							PlayerData.playerRoundDamage[iPlayerID][Spawner:GetRound()] = tRoundDamage
						end
						if tRoundDamage[sUnitName] == nil then tRoundDamage[sUnitName] = {} end
						tRoundDamage[sUnitName][iDamageType] = (tRoundDamage[sUnitName][iDamageType] or 0) + fDamage

						local iEntID = hAttacker:GetEntityIndex()
						if not self.tDamageRecord[iEntID] then self.tDamageRecord[iEntID] = {} end
						self.tDamageRecord[iEntID][tostring(iDamageType)] = (self.tDamageRecord[iEntID][tostring(iDamageType)] or 0) + fDamage
					end
				end
			end
		end
	end

	function public:OnPlayerChat(keys)
		local iPlayerID = keys.playerid
		CustomGameEventManager:Send_ServerToAllClients("drodo_chat", {
			player_id = iPlayerID,
			text = keys.text,
			time_stamp = math.floor(GameRules:GetGameTime()),
			type = 'player_chat',
		})
	end

	function public:OnClientGetTatalDamageRecord(_, tEvent)
		local player = PlayerResource:GetPlayer(tEvent.PlayerID)
		if player then
			CustomGameEventManager:Send_ServerToPlayer(player, "custom_damage_record_total", PlayerData.playerRoundDamage)
		end
	end
end
--事件监听************************************************************************************************************************
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("player_data", "player_datas", self.playerDatas)
end

function public:SendDamageRecordThinker()
	GameTimer('PlayerData_SendDamageRecordThinker', 0, function()
		if _G.NOSHOWDAMAGE
		or GSManager:getStateType() ~= GS_Battle
		then
			return 0.5
		end

		for k, v in pairs(self.tDamageRecord) do
			FireGameEvent("custom_damage_record", {
				json = json.encode(self.tDamageRecord)
			})
			self.tDamageRecord = {}
			break
		end

		return 0.1
	end)
end

---修改魂晶数量
function public:ModifyCrystal(iPlayerID, iCrystal, bRecord)
	iCrystal = math.floor(iCrystal)
	self.playerDatas[iPlayerID].crystal = self.playerDatas[iPlayerID].crystal + iCrystal
	if bRecord or bRecord == nil then
		self:RecordTotalCrystal(iPlayerID, iCrystal)
	end
	if not _G.NOSHOWGOLD then
		self:ShowCrystal(iPlayerID, iCrystal)
	end
	self:UpdateNetTables()
end
function public:ShowCrystal(iPlayerID, iCrystal)
	if 0 == iCrystal then return end
	local hHero = PlayerData:GetHero(iPlayerID)
	if IsValid(hHero) then
		local particle = ParticleManager:CreateParticle('particles/msg_fx/msg_gold.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW, hHero)
		ParticleManager:SetParticleControlEnt(particle, 0, hHero, 5, "attach_hitloc", hHero:GetOrigin(), true)
		ParticleManager:SetParticleControl(particle, 1, Vector(iCrystal < 0 and 1 or 10, math.abs(iCrystal), 9))
		ParticleManager:SetParticleControl(particle, 2, Vector(3, #tostring(iCrystal) + (iCrystal < 0 and 1 or 2), 0))
		ParticleManager:SetParticleControl(particle, 3, Vector(78, 206, 204))
		ParticleManager:ReleaseParticleIndex(particle)
		-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, hHero, iCrystal, nil)
	end
end

---获取魂晶数量
function public:GetCrystal(iPlayerID)
	return self.playerDatas[iPlayerID].crystal
end

function public:GetTotalCrystal(iPlayerID)
	return self.playerDatas[iPlayerID].total_crystal
end

--- 记录玩家魂晶信息
function public:RecordTotalCrystal(iPlayerID, iCrystal)
	if iCrystal > 0 then
		self.playerDatas[iPlayerID].total_crystal = iCrystal + self.playerDatas[iPlayerID].total_crystal
	else
		self.playerDatas[iPlayerID].spend_crystal = -1 * iCrystal + self.playerDatas[iPlayerID].spend_crystal
	end
end

--- 给玩家掉魂晶
function public:DropCrystal(iPlayerID, vStart, iCrystal)
	iCrystal = math.floor(iCrystal)
	local hHero = self:GetHero(iPlayerID)
	if IsValid(hHero) and hHero:IsAlive() then

		if _G.NOSHOWDROP then
			-- 不显示
			self:ModifyCrystal(iPlayerID, iCrystal)
		else
			local fDuration = 1
			local iPtcl = ParticleManager:CreateParticle("particles/crystal/crystal_trail.vpcf", PATTACH_CUSTOMORIGIN, hHero)
			ParticleManager:SetParticleControl(iPtcl, 0, vStart)
			ParticleManager:SetParticleControlEnt(iPtcl, 1, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(iPtcl, 2, Vector(fDuration, 0, 0))
			GameTimer(fDuration, function()
				self:ModifyCrystal(iPlayerID, iCrystal)
				ParticleManager:DestroyParticle(iPtcl, false)
				local iPtcl = ParticleManager:CreateParticle("particles/crystal/crystal_active.vpcf", PATTACH_CUSTOMORIGIN, hHero)
				ParticleManager:SetParticleControlEnt(iPtcl, 0, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(iPtcl)
			end)
		end
	end
end
--- 给玩家掉金币
function public:DropGold(iPlayerID, vStart, iGold)
	iGold = math.floor(iGold)
	local hHero = self:GetHero(iPlayerID)
	if IsValid(hHero) and hHero:IsAlive() then

		if _G.NOSHOWDROP then
			-- 不显示
			self:ModifyGold(iPlayerID, iGold)
		else
			local fDuration = 1
			local iPtcl = ParticleManager:CreateParticle("particles/gold/gold_trail.vpcf", PATTACH_CUSTOMORIGIN, hHero)
			-- ParticleManager:SetParticleControlEnt(iPtcl, 0, hDrop, PATTACH_POINT_FOLLOW, "attach_hitloc", hDrop:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(iPtcl, 0, vStart)
			ParticleManager:SetParticleControlEnt(iPtcl, 1, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(iPtcl, 2, Vector(fDuration, 0, 0))
			GameTimer(fDuration, function()
				self:ModifyGold(iPlayerID, iGold)
				ParticleManager:DestroyParticle(iPtcl, false)
				local iPtcl = ParticleManager:CreateParticle("particles/gold/gold_active.vpcf", PATTACH_CUSTOMORIGIN, hHero)
				ParticleManager:SetParticleControlEnt(iPtcl, 0, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(iPtcl, 1, hHero:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(iPtcl, 3, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(iPtcl)
			end)
		end
	end
end
--- 给玩家掉大钱袋
function public:DropGoldChest(iPlayerID, vStart, vEnd, iGold)
	iGold = math.floor(iGold or 1)
	local hGoldChest = CreateItem("item_goldchest", nil, nil)
	SetPlayerID(hGoldChest, iPlayerID)
	if not hGoldChest then return end
	hGoldChest:SetPurchaseTime(0)
	hGoldChest:SetCurrentCharges(iGold)
	local hDrop = CreateItemOnPositionSync(vStart, hGoldChest)

	hGoldChest:LaunchLoot(true, RandomFloat(300, 600), 0.75, vEnd)
	hGoldChest:SetCastOnPickup(true)
	hDrop:SetModelScale(2)
end

--- 修改玩家金币	+ 添加 - 减少
---@param bRecord boolean 是否计入总获得/花费金币 默认记录
function public:ModifyGold(iPlayerID, iGold, bRecord)
	if not self.playerDatas[iPlayerID] then return end

	iGold = math.floor(iGold)

	self.playerDatas[iPlayerID].gold = self:GetGold(iPlayerID) + iGold
	if bRecord or bRecord == nil then
		self:RecordGold(iPlayerID, iGold)
	end
	self:UpdateNetTables()

	---@class EventData_PLAYER_GOLD_CHANGE
	local tEventData = {
		PlayerID = iPlayerID,
		iChange = iGold,
		iGold = self.playerDatas[iPlayerID].gold,
	}
	EventManager:fireEvent(ET_PLAYER.ON_GOLD_CHANGE, tEventData)

	if not _G.NOSHOWGOLD then
		self:ShowGold(iPlayerID, iGold)
	end
end

--- 记录玩家金币信息
function public:RecordGold(iPlayerID, iGold)
	if iGold > 0 then
		self.playerDatas[iPlayerID].total_gold = iGold + self.playerDatas[iPlayerID].total_gold
		EventManager:fireEvent(ET_PLAYER.ON_ADD_TOTAL_GOLD, {
			PlayerID = iPlayerID,
			iTotalGold = self.playerDatas[iPlayerID].total_gold,
			iAdd = iGold,
		})
	else
		self.playerDatas[iPlayerID].spend_gold = -1 * iGold + self.playerDatas[iPlayerID].spend_gold
	end
end
function public:ShowGold(iPlayerID, iGold)
	if 0 == iGold then return end
	local hHero = PlayerData:GetHero(iPlayerID)
	if IsValid(hHero) then
		if 0 < iGold then
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, hHero, iGold, nil)
		else
			local particle = ParticleManager:CreateParticle('particles/msg_fx/msg_gold.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW, hHero)
			ParticleManager:SetParticleControlEnt(particle, 0, hHero, 5, "attach_hitloc", hHero:GetOrigin(), true)
			ParticleManager:SetParticleControl(particle, 1, Vector(iGold < 0 and 1 or 10, math.abs(iGold), 9))
			ParticleManager:SetParticleControl(particle, 2, Vector(3, #tostring(iGold) + (iGold < 0 and 1 or 2), 0))
			ParticleManager:SetParticleControl(particle, 3, Vector(200, 165, 0))
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end
end

function public:GetTotalGold(iPlayerID)
	if self.playerDatas[iPlayerID] then
		return self.playerDatas[iPlayerID].total_gold
	end
	return 0
end

function public:GetGold(iPlayerID)
	if self.playerDatas[iPlayerID] then
		return self.playerDatas[iPlayerID].gold
	end
	return 0
end

function public:CreateLineupTable(hBuilding)
	local hUnit = hBuilding:GetUnitEntity()
	local tHeroes = {}

	tHeroes.name = hBuilding:GetUnitEntityName() -- 名字
	tHeroes.build_round = hBuilding:GetBuildRound() -- 建造回合
	tHeroes.damage = hBuilding:GetTotalDamage() -- 伤害

	local tItems = {}
	local iItemWorth = 0
	for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9, 1 do
		local hItem = hUnit:GetItemInSlot(i)
		local sItemName = ""
		if IsValid(hItem) then
			sItemName = hItem:GetName()
			iItemWorth = iItemWorth + GetItemCost(hItem:GetName())
		end
		tItems[i] = sItemName
	end
	tHeroes.items = tItems -- 物品列表
	tHeroes.item_worth = iItemWorth -- 物品价值

	return tHeroes
end

function public:SaveLineup(iPlayerID)
	local tStatistics = self.playerDatas[iPlayerID].statistics

	tStatistics.heroes = {}
	tStatistics.nonheroes = {}
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		if hBuilding:IsHero() then
			local tHeroes = self:CreateLineupTable(hBuilding)
			table.insert(tStatistics.heroes, tHeroes)
		else
			local tNonheroes = self:CreateLineupTable(hBuilding)
			table.insert(tStatistics.nonheroes, tNonheroes)
		end
	end)

	local funcSort = function(a, b)
		return a.build_round < b.build_round
	end

	table.sort(tStatistics.heroes, funcSort)
	table.sort(tStatistics.nonheroes, funcSort)
end

function public:CorrectGold()
	-- DotaTD:EachPlayer(function(n, iPlayerID)
	-- 	local iGold = PlayerResource:GetGold(iPlayerID)
	-- 	if iGold > CORRECT_GOLD then
	-- 		local iExchange = iGold-CORRECT_GOLD
	-- 		self:ModifyExtraGold(iPlayerID, iExchange)
	-- 		PlayerResource:ModifyGold(iPlayerID, -iExchange, false, DOTA_ModifyGold_Unspecified)
	-- 	elseif iGold < CORRECT_GOLD and self:GetExtraGold(iPlayerID) > 0 then
	-- 		local iExchange = math.max(iGold-CORRECT_GOLD, -self:GetExtraGold(iPlayerID))
	-- 		self:ModifyExtraGold(iPlayerID, iExchange)
	-- 		PlayerResource:ModifyGold(iPlayerID, -iExchange, false, DOTA_ModifyGold_Unspecified)
	-- 	end
	-- end)
end

---设置玩家某回合胜负结果
function public:SetPlayerRoundResult(iPlayerID, iRound, bWin)
	local iResult = bWin and 1 or 0
	if nil ~= self.playerRoundResult[iPlayerID][iRound] then
		return
	end

	self.playerRoundResult[iPlayerID][iRound] = iResult
	CustomNetTables:SetTableValue("player_data", "round_result", self.playerRoundResult)

	---@class EventData_PlayerRoundResult
	local tData = {
		PlayerID = iPlayerID,
		is_win = self:GetPlayerRoundResult(iPlayerID, iRound),
	}
	EventManager:fireEvent(ET_PLAYER.ROUND_RESULT, tData)

	if bWin then
		BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
			local hUnit = hBuilding:GetUnitEntity()
			if IsValid(hUnit) and hUnit:IsAlive() then
				hUnit:StartGesture(ACT_DOTA_VICTORY)
			end
		end)
	end
end
---玩家某回合胜负结果 0负1胜nil超时
function public:GetPlayerRoundResult(iPlayerID, iRound)
	if nil == iPlayerID then
		local t = {}
		DotaTD:EachPlayer(function(_, iPlayerID)
			t[iPlayerID] = self:GetPlayerRoundResult(iPlayerID, iRound)
		end)
		return t
	else
		if not iRound then iRound = Spawner:GetRound() end
		local tRound = self.playerRoundResult[iPlayerID]
		if tRound then
			return tRound[iRound]
		end
	end
	return 0
end

---玩家某宝箱回合金币损失
function public:SetPlayerGoldRoundLost(iPlayerID, iRound, iGold)
	self.tPlayerGoldRoundLost[iPlayerID][iRound] = math.abs(iGold)
end
---玩家某宝箱回合金币损失
function public:GetPlayerGoldRoundLost(iPlayerID, iRound)
	if nil == iPlayerID then
		local t = {}
		DotaTD:EachPlayer(function(_, iPlayerID)
			t[iPlayerID] = self:GetPlayerGoldRoundLost(iPlayerID, iRound)
		end)
		return t
	else
		local tRound = self.tPlayerGoldRoundLost[iPlayerID]
		return tRound[iRound]
	end
end

--获取玩家队伍ID
function public:GetPlayerTeamID(iPlayerID)
	return iPlayerID + 1
end
--用队伍ID获取玩家ID
function public:GetPlayerIDByTeamID(iTeamID)
	return iTeamID - 1
end

--获取玩家等级,人口
function public:GetPlayerLevel(iPlayerID)
	if self.playerDatas[iPlayerID] then
		return self.playerDatas[iPlayerID].player_level or 1
	end
	return 1
end
function public:AddPlayerLevel(iPlayerID, iLevel)
	self.playerDatas[iPlayerID].player_level = self.playerDatas[iPlayerID].player_level + iLevel
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	if IsValid(hHero) and hHero:IsAlive() then
		hHero:AddExperience(iLevel, 0, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end

	---@class EventData_PLAYER_LEVEL_CHANGED
	local tEvent = {
		PlayerID = iPlayerID,
		iChange = iLevel,
		iCount = self.playerDatas[iPlayerID].player_level,
	}
	EventManager:fireEvent(ET_PLAYER.LEVEL_CHANGED, tEvent)
end

--获取玩家数量
function public:GetPlayerCount(bAlive)
	local iCount = 0
	DotaTD:EachPlayer(function(_, iPlayerID)
		iCount = iCount + 1
	end)
	return iCount
end
--获取允许玩家最大数量
function public:GetPlayerMaxCount()
	return 4
end

--获取剩余玩家数量
function public:GetAlivePlayerCount()
	local iCount = 0
	DotaTD:EachPlayer(function(_, iPlayerID)
		if not self:IsPlayerDeath(iPlayerID) then
			iCount = iCount + 1
		end
	end)
	return iCount
end

--处理玩家失败扣血
function public:LosePlayerHP()
	--玩家失败扣血
	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPlayerDeath(iPlayerID) then return end
		if 1 == PlayerData:GetPlayerRoundResult(iPlayerID) then return end

		if 0 < Spawner:GetRoundLoseHPMode() then
			--扣n条命
			EventManager:fireEvent(ET_PLAYER.ON_DAMAGE, {
				PlayerID = iPlayerID,
				attacker = PlayerData:GetHero(iPlayerID),
				damage = Spawner:GetRoundLoseHPMode(),
			})
		elseif - 1 == Spawner:GetRoundLoseHPMode() then
			--扣到一血
			EventManager:fireEvent(ET_PLAYER.ON_DAMAGE, {
				PlayerID = iPlayerID,
				attacker = PlayerData:GetHero(iPlayerID),
				damage = math.max(1, PlayerData:GetHealth(iPlayerID) - 1),
			})
		elseif - 2 == Spawner:GetRoundLoseHPMode() then
			--不扣血
		end
	end)
end

---玩家是否死亡
function public:IsPlayerDeath(iPlayerID)
	return self.playerDatas[iPlayerID] and 0 >= self.playerDatas[iPlayerID].health
end
function public:IsAlive(iPlayerID)
	return not public:IsPlayerDeath(iPlayerID)
end

---设置玩家英雄
function public:SetHero(iPlayerID, hHero)
	self.tPlayerHeroes[iPlayerID] = hHero
end
---获取玩家英雄
function public:GetHero(iPlayerID)
	return self.tPlayerHeroes[iPlayerID] or PlayerResource:GetSelectedHeroEntity(iPlayerID)
end
---获取玩家血量
function public:GetHealth(iPlayerID)
	return self.playerDatas[iPlayerID].health
end
---设置玩家血量
function public:ModifyHealth(iPlayerID, iVal)
	if IsInToolsMode() and EomDebug.bInvincible then
		return
	end
	if Spawner:IsGoldRound() and 0 >= iVal then
		return
	end

	local hHero = PlayerData:GetHero(iPlayerID)
	if IsValid(hHero) then
		local iParticleID = ParticleManager:CreateParticle("particles/msg_fx/msg_damage.vpcf", PATTACH_OVERHEAD_FOLLOW, hHero)
		if 0 > iVal then
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(1, -iVal, 0))
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(2, #tostring(iVal), 0))
		else
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(0 > iVal and 1 or 0, iVal, 0))
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(2, #tostring(iVal) + 1, 0))
		end
		ParticleManager:SetParticleControl(iParticleID, 3, Vector(255, 100, 100))
	end

	self.playerDatas[iPlayerID].health = math.min(self.playerDatas[iPlayerID].health + iVal, PLAYER_HEALTH)
	self.playerDatas[iPlayerID].is_death = 0 >= self.playerDatas[iPlayerID].health and 1 or 0
	PlayerData:UpdatePlayerHealthInfo(iPlayerID, iVal)

	if 0 >= self.playerDatas[iPlayerID].health then
		---@class EventData_PlayerDeath
		local tData = {
			PlayerID = iPlayerID,
		}
		EventManager:fireEvent(ET_PLAYER.ON_DEATH, tData)
	end
	self:UpdateNetTables()
end

---给玩家加血
function public:AddHealth(iPlayerID, iVal)
	local hHero = Commander:GetCommander(iPlayerID)
	if IsValid(hHero) and hHero:IsAlive() then
		hHero:Heal(iVal, hHero)
	end
end
---获取玩家加魔
function public:GetMana(iPlayerID)
	return self.playerDatas[iPlayerID].mana
end
---给玩家加魔
function public:AddMana(iPlayerID, iVal)
	self.playerDatas[iPlayerID].mana = math.min(self.playerDatas[iPlayerID].mana + iVal, PLAYER_MANA)
	local hHero = PlayerData:GetHero(iPlayerID)
	if IsValid(hHero) and hHero:IsAlive() then
		hHero:SetMaxMana(self.playerDatas[iPlayerID].mana_max)
		hHero:SetMana(self.playerDatas[iPlayerID].mana)
	end
	self:UpdateNetTables()
end

---增加玩家每回合魔法恢复
function public:AddManaRegen(iPlayerID, iVal)
	local t = self.playerDatas[iPlayerID]
	if t then
		t.mana_regen = t.mana_regen + iVal
	end
end
---增加玩家每回合生命恢复
function public:AddHealthRegen(iPlayerID, iVal)
	local t = self.playerDatas[iPlayerID]
	if t then
		t.health_regen = t.health_regen + iVal
	end
end
---获取玩家每回合魔法恢复
function public:GetManaRegen(iPlayerID)
	local t = self.playerDatas[iPlayerID]
	-- 回蓝百分比
	local fRagenPct = self:GetPlayerHeroPercentageManaRegen(iPlayerID)
	fRagenPct = (100 + math.max(-100, fRagenPct)) * 0.01
	local fRegen = (t and t.mana_regen or 0) * fRagenPct + self:GetPlayerHeroConstantManaRegen(iPlayerID)
	return fRegen
end
---获取玩家每回合生命恢复
function public:GetHealthRegen(iPlayerID)
	local t = self.playerDatas[iPlayerID]
	return t and t.health_regen or 0
end
---获取玩家技能数据
function public:GetAbilityData(iPlayerID, sAbilityName)
	if iPlayerID.GetUnitName then
		iPlayerID = GetPlayerID(iPlayerID)
	end
	if iPlayerID == -1 then
		return nil
	end
	local tAbilityData = self.tAbilityData[iPlayerID]
	if self.tAbilityData[iPlayerID][sAbilityName] == nil then
		self.tAbilityData[iPlayerID][sAbilityName] = {}
	end
	return self.tAbilityData[iPlayerID][sAbilityName]
end
function public:SetAbilityData(iPlayerID, sAbilityName, key, value)
	if iPlayerID.GetUnitName then
		iPlayerID = GetPlayerID(iPlayerID)
	end
	if iPlayerID == -1 then
		return nil
	end
	local tAbilityData = self.tAbilityData[iPlayerID]
	if self.tAbilityData[iPlayerID][sAbilityName] == nil then
		self.tAbilityData[iPlayerID][sAbilityName] = {}
	end
	self.tAbilityData[iPlayerID][sAbilityName].key = value
end

---判断某个点是否在某玩家场地区域
function public:IsPointInPlayerRange(iPlayerID, vPos)
	if Spawner and Spawner.tTeamMapPoints then
		local hEntPoint = Spawner.tTeamMapPoints[PlayerData:GetPlayerTeamID(iPlayerID)]
		if IsValid(hEntPoint) then
			local vPosPlayer = hEntPoint:GetAbsOrigin()
			local fHeight = 4000
			local fWidth = 2500
			local v1 = vPosPlayer + Vector(0, fHeight / 2, 0) + Vector(fWidth / 2, 0, 0)
			local v2 = vPosPlayer - Vector(0, fHeight / 2, 0) + Vector(fWidth / 2, 0, 0)
			local v3 = vPosPlayer + Vector(0, fHeight / 2, 0) - Vector(fWidth / 2, 0, 0)
			local v4 = vPosPlayer - Vector(0, fHeight / 2, 0) - Vector(fWidth / 2, 0, 0)
			-- 3	1
			-- 4	2
			-- DebugDrawLine(v1, v2, 255, 255, 255, true, 50)
			-- DebugDrawLine(v1, v3, 255, 255, 255, true, 50)
			-- DebugDrawLine(v4, v2, 255, 255, 255, true, 50)
			-- DebugDrawLine(v4, v3, 255, 255, 255, true, 50)
			return IsPointInPolygon(vPos, { v1, v2, v4, v3 })
		end
	end
	return false
end

---玩家战斗是否结束
function public:IsBattling(iPlayerID)
	return GSManager:getStateType() == GS_Battle and 1 ~= self:GetPlayerRoundResult(iPlayerID, Spawner:GetRound())
end

----------------------------------------------------------------------------------------------------
-- 注册修改器
---获取指挥官魔法恢复
function public:GetPlayerHeroConstantManaRegen(iPlayerID)
	local iBonus = 0
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_HERO_CONSTANT_MANA_REGEN)) do
		local iVal = tonumber(tVals[1]) or 0
		if type(key) == 'table' then
			---@type eom_modifier
			local hBuff = key
			if hBuff:GetPlayerID() ~= iPlayerID then
				iVal = 0
			end
		end
		iBonus = iVal + iBonus
	end
	return iBonus
end
if not EModifier:HasModifier(EMDF_HERO_CONSTANT_MANA_REGEN) then EModifier:CreateModifier(EMDF_HERO_CONSTANT_MANA_REGEN) end

--- 获取玩家指挥官蓝量恢复百分比修改
function public:GetPlayerHeroPercentageManaRegen(iPlayerID)
	local fRagenPct = 0
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_HERO_PERCENTAGE_MANA_REGEN)) do
		local iVal = tonumber(tVals[1]) or 0
		if type(key) == 'table' then
			---@type eom_modifier
			local hBuff = key
			if hBuff:GetPlayerID() ~= iPlayerID then
				iVal = 0
			end
		end
		fRagenPct = iVal + fRagenPct
	end
	return fRagenPct
end
if not EModifier:HasModifier(EMDF_HERO_PERCENTAGE_MANA_REGEN) then EModifier:CreateModifier(EMDF_HERO_PERCENTAGE_MANA_REGEN) end

--- 获取指挥官升级百分比
function public:GetcmdUpgradeDiscont(iPlayerID)
	local iDiscount = 0
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_CMD_UPGRADE_DISCOUNT_PERCENTAGE)) do
		local iVal = tonumber(tVals[1]) or 0
		if type(key) == 'table' then
			---@type eom_modifier
			local hBuff = key
			if hBuff:GetPlayerID() ~= iPlayerID then
				iVal = 0
			end
		end
		iDiscount = iVal + iDiscount
	end
	return iDiscount
end
if not EModifier:HasModifier(EMDF_CMD_UPGRADE_DISCOUNT_PERCENTAGE) then
	EModifier:CreateModifier(EMDF_CMD_UPGRADE_DISCOUNT_PERCENTAGE, function()
		public:UpdateNetTables()
	end)
end

---获取玩家档案经验百分比
function public:GetPlayerLevelXPPercent(iPlayerID)
	local fPct = 100
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_PLAYER_LEVELXP_PERCENT, iPlayerID)) do
		local iVal = tonumber(tVals[1]) or 0
		if type(key) == 'table' then
			---@type eom_modifier
			local hBuff = key
			if hBuff:GetPlayerID() ~= iPlayerID then
				iVal = 0
			end
		end
		fPct = iVal + fPct
	end
	return fPct
end
if not EModifier:HasModifier(EMDF_PLAYER_LEVELXP_PERCENT) then EModifier:CreateModifier(EMDF_PLAYER_LEVELXP_PERCENT) end

---获取玩家回合金币百分比
function public:GetPlayerRoundGoldPercentage(iPlayerID)
	local fPct = 100
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_ROUND_GOLD_PERCENTAGE, iPlayerID)) do
		local iVal = tonumber(tVals[1]) or 0
		if type(key) == 'table' then
			---@type eom_modifier
			local hBuff = key
			if hBuff:GetPlayerID() ~= iPlayerID then
				iVal = 0
			end
		end
		fPct = iVal + fPct
	end
	return fPct
end
if not EModifier:HasModifier(EMDF_ROUND_GOLD_PERCENTAGE) then EModifier:CreateModifier(EMDF_ROUND_GOLD_PERCENTAGE) end

---获取玩家杀怪金币百分比
function public:GetPlayerKillGoldPercentage(iPlayerID, params)
	local fPct = 100
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_KILL_GOLD_PERCENTAGE, iPlayerID, params)) do
		local iVal = tonumber(tVals[1]) or 0
		fPct = iVal + fPct
	end
	return fPct
end
if not EModifier:HasModifier(EMDF_KILL_GOLD_PERCENTAGE) then EModifier:CreateModifier(EMDF_KILL_GOLD_PERCENTAGE) end

---获取玩家宝箱关额外时间
function GetGoldRoundDurationBonus(iPlayerID)
	local iDuration = 0
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_GOLD_ROUND_DURATION_BONUS, iPlayerID)) do
		local iVal = tonumber(tVals[1]) or 0
		iDuration = iDuration + iVal
	end
	return iDuration
end
if not EModifier:HasModifier(EMDF_GOLD_ROUND_DURATION_BONUS) then EModifier:CreateModifier(EMDF_GOLD_ROUND_DURATION_BONUS) end

---获取玩家宝箱额外金钱掉落
function GetGoldRoundGoldBonusPercentage(iPlayerID)
	local fPct = 100
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_GOLD_ROUND_GOLD_BONUS_PERCENTAGE, iPlayerID)) do
		local iVal = tonumber(tVals[1]) or 0
		fPct = fPct + iVal
	end
	return fPct
end
if not EModifier:HasModifier(EMDF_GOLD_ROUND_GOLD_BONUS_PERCENTAGE) then EModifier:CreateModifier(EMDF_GOLD_ROUND_GOLD_BONUS_PERCENTAGE) end

-- 获取玩家通用刷新次数
function public:GetPlayerRefreshTimes(iPlayerID)
	return self.playerDatas[iPlayerID].common_refreshtimes
end
-- 获取每局剩余次数
function public:GetPlayerRefreshTimesLeft(iPlayerID)
	return self.playerDatas[iPlayerID].max_refreshtimes
end
function public:GetRefreshTimes(iPlayerID)
	local tTable = NetEventData:GetTableValue('service', 'player_ingameitem_' .. iPlayerID)
	if tTable then
		for k, iCount in pairs(tTable) do
			if tostring(k) == '1129001' then
				return iCount
			end
		end
		return 0
	end
end
function public:ModifyRefreshTimes(iPlayerID, times)
	local time = times or 1
	self.playerDatas[iPlayerID].common_refreshtimes = self:GetRefreshTimes(iPlayerID)
	self.playerDatas[iPlayerID].max_refreshtimes = self.playerDatas[iPlayerID].max_refreshtimes - 1
end

return public