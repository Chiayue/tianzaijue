local m = {}

local season = nil

function m.Init(bp)
	season = bp and bp.season
	if season then
		SetNetTableValue("config","season_time",season)
	end
	
	---{
	--	pid={
	--		exp=123213, --通行证经验
	--		quest = {
	--			day = {
	--				questName = {
	--					state = "0/10"
	--				},
	--				questName = {
	--					state = "1/1",
	--					exp = 123, --完成任务奖励的经验值
	--					finished="2021-01-01 12:23:59" --完成任务的时间
	--				}
	--			},
	--			week = {
	--				questName = {
	--					state = "0/10"
	--				},
	--				questName = {
	--					state = "1/1",
	--					exp = 123, --完成任务奖励的经验值
	--					finished="2021-01-01 12:23:59" --完成任务的时间
	--				}
	--			}
	--		},
	--		reward = { --通行证已领取的奖励信息
	--			basic = {
	--				1 = {
	--					item = "xxxx",
	--					count = 123,
	--					time = "2021-01-01 12:23:59"
	--				},
	--				2 = ...
	--			},
	--			advanced = {
	--				1 = {
	--					item = "xxxx",
	--					count = 123,
	--					time = "2021-01-01 12:23:59"
	--				},
	--				2 = ...
	--			}
	--		},
	--		[advanced="2021-01-01 12:12:12"] --有的话，代表激活了高级通行证
	--	}
	--}
	local data = {}
	
	local playerData = bp and bp.player or {}
	local quests = bp and bp.quest or {}
	
	local players = PlayerUtil.GetAllPlayersID(false,true)
	for idx, PlayerID in ipairs(players) do
		local aid = PlayerUtil.GetAccountID(PlayerID)
		
		local pData = {exp=0}
		if playerData[aid] then
			pData = playerData[aid]
			
			if pData.reward then
				pData.reward = JSON.decode(pData.reward)
			end
		end
		if quests[aid] then
			pData.quest = quests[aid]
		end
		Shopmall:SetPlayerBP(PlayerID,pData,idx == #players)
	end
end

---获得当前赛季（"1","2","3"...）
function m.GetSeason()
	return season and season.code
end

---判断是否可以在商城购买通行证（赛季最后一天就不可以购买了）
function m.IsBPPurchasble()
	return season and not season.finished and not season.last
end

---判断当前赛季是否已经结束
function m.IsSeasonFinished()
	return not season or season.finished
end

---领取奖励
--@param #number PlayerID 玩家ID
--@param #table rewards 奖励信息{
--	basic = {--基础版通行证奖励
--		level = {name="itemName"（物品名称，如果是晶石奖励，名称固定为：jing_stone）,count=123（为空或者0，则认为是不可叠加的）,valid=123（为空则永久有效）},
--		level = {name="itemName",count=123（为空或者0，则认为是不可叠加的）,valid=123（为空则永久有效）,noStore=true/false（是否不增加商城道具，有些是不需要加进商城存储的）},
--		...
--	},
--	advanced = {
--		level = {name="itemName"（物品名称，如果是晶石奖励，名称固定为：jing_stone）,count=123（为空或者0，则认为是不可叠加的）,valid=123（为空则永久有效）},
--		level = {name="itemName",count=123（为空或者0，则认为是不可叠加的）,valid=123（为空则永久有效）},
--		...
--	}
--}
--@param #function callback 回调函数，参数:success(boolean),jing（如果success为true，并且有晶石奖励，则返回更新后的晶石数量），result(一个表，可能包含basic和advanced两个元素，每个元素包含对应类型的通行证奖励领取时间)
function m.ReceiveReward(PlayerID,rewards,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if aid and type(rewards) == "table" and type(callback) == "function" then
		local season = SrvBattlePass.GetSeason();
		if not season then
			callback(false)
			return;
		end
		
		PlayerUtil.LockAction(PlayerID,"bp_rr",function()
			local params = {};
			params.mode = 2
			params.aid = aid;
			params.season = season
			params.rewards = JSON.encode(rewards)
			
			SrvHttp.load("tzj_bp",params,function(srv_data)
				PlayerUtil.UnlockAction(PlayerID,"bp_rr")
				
				if srv_data then
					if srv_data.success then
						local jing = srv_data.jing
						callback(true,jing,{basic=srv_data.basic,advanced=srv_data.advanced})
					else
						callback(false)
					end
				else
					callback(false)
					DebugPrint("[Store.BuyItem] Server response nothing");
				end
			
			end)
		end)
	end
end

---初始化玩家任务。可以一次初始化多个玩家的数据，减少网络请求
--@param #table quest 任务信息
--{
--	playerID = {
--		day = {--每日任务
--			questName={...},
--			questName={...},
--			...
--		},
--		week = {--每周任务
--			questName={...},
--			questName={...},
--			...
--		}
--	},
--	playerID = ... 
--}
--@param #function callback 回调函数，参数success(boolean，请求是否正常处理了，不代表任务初始化是否成功)，arg2(success=true的时候，返回一个表，表元素的key是玩家id，value是任务初始化结果（结果可能成功也可能失败）；success=false的时候返回错误代码数字：0=未知错误，1=赛季不符)
function m.InitQuest(quest,callback)
	if type(quest) == "table" and type(callback) == "function" then
		local season = SrvBattlePass.GetSeason();
		if not season then
			callback(false)
			return;
		end
		
		local idMap = {}
		
		local toServer = {}
		for pid, data in pairs(quest) do
			local aid = PlayerUtil.GetAccountID(pid)
			if aid then
				toServer[aid] = data
				idMap[aid] = pid
			end
		end
		
		
		local params = PlayerUtil.GetAllAccount(true,true);
		params.mode = 3
		params.season = season
		params.quest = JSON.encode(toServer)
		
		SrvHttp.load("tzj_bp",params,function(srv_data)
			if srv_data then
				local result = srv_data.result
				if result then
					local toCallback = {}
					for aid, pid in pairs(idMap) do
						toCallback[pid] = result[aid]
					end
					callback(true,toCallback)
				else
					local error = 0
					if srv_data.error == "2" then
						error = 1
					end
					callback(false,error)
				end
			else
				callback(false)
				DebugPrint("[Store.BuyItem] Server response nothing");
			end
		
		end)
	end
end

---完成单个玩家单个任务，记录到服务器，并发放奖励。
--@param #number PlayerID 玩家ID
--@param #number questType 任务类型：1=每日，2=每周
--@param #string questName 任务名称
--@param #table questData 任务内容，必须包含字段exp=123，代表任务奖励的通行证经验。服务器只有获得了该字段的值，才会更新完成时间，并发放exp代表的通行证经验
--@param #function callback 回调函数，调用参数为：
--success(boolean)，是否处理成功
--data，返回值。成功的时候，返回一个表；失败的时候返回错误代码，数字：0=未知错误，1=参数错误，2=DOTA端赛季尚未初始化或当前赛季已经结束,3=DOTA端赛季和服务器赛季不一致
function m.FinishQuest(PlayerID,questType,questName,questData,callback)
	local quests = {}
	if questType == 1 then
		quests.day = {[questName]=questData}
	elseif questType == 2 then
		quests.week = {[questName]=questData}
	end
	m.FinishQuestsBatch({[PlayerID]=quests},function(success,data)
		if success then
			callback(true,data[PlayerID])
		else
			callback(false,data)
		end
	end)
end

---完成多个玩家的多个任务
--@param #table quests 任务信息
--{
--	PlayerID = {
--		day = {--每日任务
--			questName={...}, --任务数据中必须包含exp字段，才会发放通行证经验奖励
--			...
--		},
--		week = {--每周任务
--			questName={...},
--			...
--		}
--	},
--	PlayerID = ...
--}
--@param #function callback 回调函数，调用参数为：
--success(boolean)，是否处理成功
--data，返回值。成功的时候，返回一个表；失败的时候返回错误代码，数字：0=未知错误，1=参数错误，2=DOTA端赛季尚未初始化或当前赛季已经结束,3=DOTA端赛季和服务器赛季不一致
function m.FinishQuestsBatch(quests,callback)
	local season = m.GetSeason();
	if not season or m.IsSeasonFinished() then
		callback(false,2)
		return;
	end
	
	local idMap = {}
	
	local toServer = {}
	for PlayerID, data in pairs(quests) do
		local aid = PlayerUtil.GetAccountID(PlayerID)
		if aid then
			toServer[aid] = data
			
			idMap[aid] = PlayerID
		end
	end
	
	
	local params = PlayerUtil.GetAllAccount(true,true);
	params.mode = 4
	params.season = season
	params.quest = JSON.encode(toServer)
	
	SrvHttp.load("tzj_bp",params,function(srv_data)
		if srv_data then
			local error = srv_data.error
			if error then
				if error == "1" or error == "3" then
					callback(false,1)
				elseif error == "2" then
					callback(false,3)
				else
					callback(false,0)
				end
			elseif srv_data.result then
				local result = {}
				for aid, pid in pairs(idMap) do
					result[pid] = srv_data.result[aid]
				end
				callback(true,result)
			else
				callback(false,0)
			end
		else
			callback(false,0)
			DebugPrint("[Store.BuyItem] Server response nothing");
		end
	
	end)
end

return m;