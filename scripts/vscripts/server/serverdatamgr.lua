local m = {}

local serverTime = nil

local safeCall = function(func)
	local status,msg = pcall(func)
	if not status then
		DebugPrint("Server Data Init faild:",msg)
	end
end

function m.Init(srv_data)
	if srv_data then
		local tzj = srv_data.tzj or {}
		
		serverTime = tzj.server_time
		
		safeCall(function() SrvAchv.InitPlayerData(tzj.achievement,tzj.pass_count) end)
		safeCall(function() SrvNetEquip.InitPlayerData(tzj.net_equip) end)
		safeCall(function() SrvMapLevel.InitPlayerData(tzj.map_exp) end)
		safeCall(function() SrvStore.InitPlayerData(tzj.store,srv_data.MagicStone) end)
		safeCall(function() SrvBattlePass.Init(tzj.battlepass) end)
		safeCall(function() SrvInvite.Init(tzj.invite) end)
		safeCall(function() SrvPlayerCustom.Init(tzj.custom) end)
		
		--数据量有点大，分开处理
		TimerUtil.createTimerWithDelay(10,function()
			SrvRank.LoadData()
		end)
	end
end

---返回服务器系统时间：yyyyMMddHHmmss字符串
function m.GetServerTime()
	return serverTime and serverTime.time
end

---返回服务器时间是否是当前月份的最后一天
function m.IsLastDateOfMonth()
	return serverTime and serverTime.isLastDate
end


function m.GameFinished(playerWin,onlinePlayers,error)
	if not error then
		local params = nil
		local status,error = pcall(function()
			params = PlayerUtil.GetAllAccount(true)
			params.mode = 1;
			
			SrvNetEquip.SyncItemPosition();
			
			local difficulty = GetGameDifficulty()
			params.nd = difficulty
		
			if onlinePlayers then
				local allData = {}
				
				for _, PlayerID in pairs(onlinePlayers) do
					local aid = PlayerUtil.GetAccountID(PlayerID)
					if aid then
						local data = {}
						allData[aid] = data
						
						--通关数据
						if playerWin then
							local passCount = SrvAchv.RecordPassCount(PlayerID)
							if passCount then
								data.passCount = passCount
							end
						end
						--地图经验
						local mapExp = m.GetMaxExpToServer(PlayerID,playerWin)
						if mapExp then
							data.mapExp = mapExp
						end
						
						--成就
						local achv = m.GetAchievementsToServer(PlayerID,difficulty,playerWin)
						if achv then
							data.achv = achv
						end
						
						--通行证任务
						local quest = m.GetBPQuest(PlayerID,difficulty,playerWin)
						if quest then
							quest.season = SrvBattlePass.GetSeason()
							data.quest = quest
						end
						
						local jing = m.GetJingToServer(PlayerID,playerWin)
						if jing then
							data.jing = jing
						end
					end
					
				end
				params.data = JSON.encode(allData)
			end
			
			local custom = SrvPlayerCustom.ToServer();
			if TableLen(custom) > 0 then
				params.custom = JSON.encode(custom)
			end
		
		end)
		
		if not params then
			params = {mode=1}
			params.error = "获取玩家id失败"
		end
		
		if not status then
			if params.error then
				params.error2 = params.error
			end
			params.error = error
		end
		
		SrvHttp.load("tzj_gf",params)
	else
		SrvHttp.load("tzj_gf",{mode=1,error=error})
	end
	
end

---获得某个玩家的通关经验数据，用于向服务器存储。返回空，则不同步。
--返回一个table，数据结构：
--{exp=123,reason=SrvMapLevel.Reason_Game_Bonus}
function m.GetMaxExpToServer(PlayerID,playerWin)
	local bonus = Stage.finishedexp(PlayerID, playerWin );
	if bonus then
		return {exp=bonus,reason=SrvMapLevel.Reason_Game_Bonus}
	end
end

---获得某个玩家通关后获得的晶石奖励
--返回一个table，数据结构：
--{bonus=123,reason="换个号或或或"}
function m.GetJingToServer(PlayerID,playerWin)
	local bonus = Stage.finishedjing(PlayerID,playerWin);
	if bonus > 0 then
		return {bonus=bonus,reason="游戏结束奖励"}
	end
end

---获得玩家要同步到服务器的成就信息。返回空，则不同步
--返回一个table，数据结构：
--	{ --这个表是个数组形态的结构
--		{id="xxxxx",hero="xxxxxx"},
--		{id="xxxxx",hero="xxxxxx"},
--		...
--	}
--
--每个数组元素中的id获取为：(需要用到成就类型和成就dota端定义的id)
--local id = SrvAchv.GetAchievementServerID(achvType,achvID)
function m.GetAchievementsToServer(PlayerID)
	return Sachievement:GetAchiThis( PlayerID)
end

---获得某个玩家要更新的通行证任务信息，用来保存通行证任务的进度，返回table结构：
--{
--	day = {--每日任务
--		questName={...}, --如果任务数据中包含exp=123，则认为完成了任务，会自动发放奖励（已经发放过的，不会二次发放）
--		questName={...},
--		...
--	},
--	week = {--每周任务
--		questName={...},
--		questName={...},
--		...
--	}
--}
--这里最好是把已经成功领取过奖励的任务给过滤掉，减少数据量
function m.GetBPQuest(PlayerID,difficulty,playerWin)
	return Shopmall:GetQuestNoFinish(PlayerID)
end

---结算奖励存档装备
--返回一个表，数组类型{
--	{src="结算",item="xxxxx",quality=1,grade=1,attr={...},slot=1,score=123},
--	{src="结算",item="xxxxx",quality=1,grade=1,attr={...},slot=1,score=123},
--	{src="结算",item="xxxxx",quality=1,grade=1,attr={...},slot=1,score=123},
--	{src="结算",item="xxxxx",quality=1,grade=1,attr={...},slot=1,score=123},
--	....
--}
function m.GetNetEquip(PlayerID,difficulty,playerWin)
	local net ={}
	local hero = PlayerUtil.GetHero(PlayerID)
	if not hero then
		return net
	end
	for k,v in pairs(Stage.playerinfo[PlayerID].netItem) do
		local show_list = item.show_list
		local item = EntIndexToHScript(v)
		local net2 ={}
		net.src="结算奖励"
		net.item = item:GetAbilityName()
		net.quality = show_list.itemrare
		net.grade  = show_list.itemlevel
		net.attr["item_attributes"] = show_list.item_attributes
		net.attr["item_attributes_spe"] = show_list.item_attributes_spe
		net.slot =Netbackpack:GetNotUseIndex(hero) --如果是-1 就代表没有位置
		net.score= show_list.zdl
		table.insert(net, net2) 
	end
	return net
	
end

---结算商城道具奖励
--返回一个表，数组结构{
--	{name="xxxxx",count=nil/123,valid=nil/123},
--	{name="xxxxx",count=nil/123,valid=nil/123},
--	{name="xxxxx",count=nil/123,valid=nil/123},
--	{name="xxxxx",count=nil/123,valid=nil/123},
--	{name="xxxxx",count=nil/123,valid=nil/123}
--}
function m.GetStoreItem(PlayerID,difficulty,playerWin)
	local store ={}
	if playerWin then
		table.insert(store, Stage.playerinfo[PlayerID].store_items) 
	end
	return store
	
end

return m;