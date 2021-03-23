--游戏状态变化时的处理逻辑
local m = {}

---在地图上创建几个商店单位，点击打开商店
local createShopUnit = function()
	for var=1, 4 do
		local point = EntityHelper.findEntityByName("sd_"..tostring(var));
		if point then
			point = point:GetAbsOrigin();
			local unit = CreateUnitEX("unit_shop_"..tostring(var),point,true,nil,TEAM_PLAYER)
			if unit then
				AddLuaModifier(unit,unit,"modifier_invulnerable")
				AddLuaModifier(unit,unit,"modifier_disarmed")
				AddLuaModifier(unit,unit,"modifier_no_healthbar")

				unit:FaceTowards(Vector(0,0,0))

				if var == 2 then
					unit:SetSkin(1)
					local wearable = unit:FirstMoveChild()
					while wearable do
						if wearable:GetClassname() == "dota_item_wearable" and wearable.SetSkin then
							wearable:SetSkin(1)
						end
						wearable = wearable:NextMovePeer()
					end
				elseif var == 4 then
					unit:AddActivityModifier("arcana")
				end
			end
		end
	end
end

--游戏状态改变的时候触发（比如是选择英雄还是游戏进行中还是游戏结束等等状态）
---------------------------------------------------------------------------------
-- 游戏阶段变更
---------------------------------------------------------------------------------
function m:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		EachPlayer(function(n, iPlayerID)
			-- 初始化玩家商城数据
			Shopmall(iPlayerID)
		end)
		Backpack:setpublic()
		
		m.InitData(1)
		
	elseif nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		TimerUtil.createTimerWithDelay(2,createShopUnit)

		EachPlayer(function(n, iPlayerID)
			-- 初始化玩家数据
			PlagueLand.playergold[iPlayerID]={
				totalgold=0,
				nowgold=0,
				costgold=0,
			}
			;
			Stage.playerinfo[iPlayerID]={
				boss_damage=0,
				jing = 0 ,--晶石奖励
				bp_exp = 0, ---通行证历练值
				map_exp = 0 ,--修行经验
				net_items = nil ,--本局打boss获得的存档装备信息，是一个数组，每一个元素是对应物品的id
				bp_rewards = nil,
				achv = nil, --本局达成了几个成就，没有就空着
			}

		end)




		GameRules:GetGameModeEntity():SetContextThink("CorrectGold", function()
			PlagueLand:CorrectGold()
			return 0
		end,1)
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then --英雄选择结束
		local totalTime = 25 		--游戏准备时间
		local difficulty =   GetGameDifficulty()
		if difficulty >=36 then
			totalTime = totalTime +10
		end
		local time = totalTime
		
		Stage.jygchance = Stage.jyg[difficulty] 
		Stage.gjgchance = Stage.gjg[difficulty] 
		Stage.max_boss_count = Stage.max_boss[difficulty]
		Stage.bosscountdown = Stage.countdown[difficulty]
		
		local ms = GetGameDifficultyModel()  --难度模式
		Stage.Yxms(ms)
		if difficulty >= 42 then
			Stage.intervalWave = Stage.intervalWave - 2
			Stage.time= Stage.time-25
			Stage.num = Stage.num - 45
		end
		m.SyncConfig(); 
		bgm.PlayNormal(false,1)
		
		TimerUtil.createTimer(function()
			CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_attack_timer",{now=Stage.wave,next=time,total=totalTime})
			if time == 0 then
				Stage.difficultygjg(difficulty) --根据难度调整高级怪的出现权重
				Stage.StartAttack()
				Stage.SpawnAttackBoss()
				Stage.gamelose()
				if Stage.playernum == 1 then
					local hero= PlayerUtil.GetHero(0)  --如果出怪时是只有一个玩家，就减少2S复活时间
					if hero and hero.cas_table.swfhsj then
						hero.cas_table.swfhsj = hero.cas_table.swfhsj -2
					end
				end
				--刷怪后30秒刷第一次任务
				MisSion:InitMission(30)
				return nil
			end
			time = time -1
			return 1
		end)
	end

end

function m.InitData(count)
	local params = PlayerUtil.GetAllAccount();
	SrvHttp.get("gi",params,function(data)
		
		local validPlayers = nil
		if data then
			validPlayers = data.tzj and data.tzj.valid
		else
			if count > 10 then
				return;
			end
			
			SendToAllClient("tzj_setup_loading_time_out",{count=count})			
			m.InitData(count + 1)
			return;
		end
		
		SrvDataMgr.Init(data)
		
		GameSetup.StartSetup(validPlayers)
	end)
end


function m.SyncConfig()
	local bossCount = Stage.max_boss_count
	local bossInterval = Stage.bosscountdown
	
	SetNetTableValue("config","survival_boss",{count=bossCount,interval=bossInterval})
end

return m;
