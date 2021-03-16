local m = {}

---英雄单体成就
m.achv_type_1 = "hero_single"
---力量英雄成就
m.achv_type_2 = "hero_str"
---敏捷英雄成就
m.achv_type_3 = "hero_agi"
---智力英雄成就
m.achv_type_4 = "hero_int"
---全英雄成就
m.achv_type_5 = "hero_all"
---难度成就
m.achv_type_6 = "difficulty"
---隐藏成就
m.achv_type_7 = "hidden"

---要忽略的英雄，这些英雄不算成就
m.ignore_hero = {}


---所有成就，key是类型，value是该类型下所有成就的id
local all_achv = {
	[m.achv_type_1] = {"1","2","3","4","5"},
	[m.achv_type_2] = {"1","2","3","4","5"},
	[m.achv_type_3] = {"1","2","3","4","5"},
	[m.achv_type_4] = {"1","2","3","4","5"},
	[m.achv_type_5] = {"1","2","3","4","5"},
	[m.achv_type_6] = {"1","2","3","4","5_1","5_2","6_1","6_3","7_1","7_4","8_1","8_2","9_1","9_3","10_1","10_4","11_1","11_5","12_1","12_5","13_1","13_6","14_1","14_7","15_1","16_1","17_1","18_1","19_1","20_1","21_1","22_1"},
	[m.achv_type_7] = {"1","2","3","4"}
}


---各个玩家的数据
--key：玩家id
--value：{
--	hero_single_1 = {heroName = "xxxx"}, ---xxxx是达成时间
--	hero_single_2 = {heroName = "xxxx"},
--	hero_str_1 = {time = "xxxx"},
--	hero_all_1 = {time = "xxxx"},
--	difficulty_1 = {time = "xxxx"},
--	...
--}
local player_achievements = {}

---各个玩家的通关数据
--key：玩家id
--value：{
--	heroName = {
--		total=123 --总通关次数,
--		difficulty = { --各个难度的通关次数
--			"1" = 123,
--			"2" = 123,
--			...
--		}
--	}
--}
local player_pass_count = {}


local GetPlayerDataForType = function(PlayerID,achvType,heroName)
	local achievements = all_achv[achvType];
	local achv = {}
	for idx, achvID in pairs(achievements) do
		--由于id并不是连续的数字，向客户端发送索引以保证顺序（以定义时的顺序为准）
		local data = {idx=idx}
		achv[achvID] = data
		--达成的，设置达成时间
		local achieved,time = m.HasAchieved(PlayerID,achvType,achvID,heroName);
		if achieved then
			data.time = time
		end
	end
	return achv
end

function m.InitPlayerData(achievements,passCount)
	local players = PlayerUtil.GetAllPlayersID(false,true)
	for _, PlayerID in pairs(players) do
		local aid = PlayerUtil.GetAccountID(PlayerID);
		if achievements then
			local data = achievements[aid]
			if data then
			
				local playerData = {}
				player_achievements[PlayerID] = playerData
				
				for _, var in pairs(data) do
					if var.id then
						if var.hero then
							if playerData[var.id] then
								playerData[var.id][var.hero] = var.time
							else
								playerData[var.id] = {[var.hero]=var.time}
							end
						else
							playerData[var.id] = {time=var.time}
						end
					end
				end
			end
		end
		
		--记录通关次数
		if passCount then
			player_pass_count[PlayerID] = passCount[aid]
		end

	end
end

---获取某个成就在服务器存储的成就id
--@param #string achvType 成就类型，引用SrvAchv.achv_typeXXX
--@param #string achvID 成就在DOTA端定义的id
function m.GetAchievementServerID(achvType,achvID)
	return achvType.."_"..achvID;
end

---某个玩家新完成了一个成就，存储至服务端
--@param #any player 可以是玩家的英雄或者玩家id
--@param #string achvType 成就类型，引用SrvAchv.achv_typeXXX
--@param #string achvID 成就id
--@param #string heroName 对于成就类型是单英雄成就的，需要添加英雄名称条件
function m.AddAchievement(player,achvType,achvID,heroName)
	local PlayerID = player
	if type(PlayerID) ~= "number" then
		PlayerID = PlayerUtil.GetOwnerID(PlayerID);
	end
	
	if type(PlayerID) == "number" and achvType and achvID then
		local aid = PlayerUtil.GetAccountID(PlayerID)
		
		local serverID = m.GetAchievementServerID(achvType,achvID)
		if achvType == m.achv_type_1 and not heroName then
			serverID = nil;
		end
		
		if aid and serverID then
			local params = {}
			params.aid = aid
			params.mode = 1
			params.id = serverID
			params.hero = heroName
			
			SrvHttp.load("tzj_achievement",params,function(data)
				if data then
					if data.result then
						local cache = player_achievements[PlayerID]
						if not cache then
							cache = {}
							player_achievements[PlayerID] = cache
						end
						
						if heroName then
							if cache[serverID] then
								cache[serverID][heroName] = data.result.time
							else
								cache[serverID] = {
									[heroName] = data.result.time
								}
							end
						else
							cache[serverID] = {
								time = data.result.time
							}
						end
						
						--由于涉及到排序显示，这里暂时按系列进行同步
						if achvType == m.achv_type_6 then
							m.SyncPlayerDataToClient(PlayerID,false,true,false)
						elseif achvType == m.achv_type_7 then
							m.SyncPlayerDataToClient(PlayerID,false,false,true)
						else
							m.SyncPlayerDataToClient(PlayerID,true,false,false)
						end
						
					elseif data.error then
						DebugPrint("server response error:",data.error)
					end
				end
			end)
			
		end
	end
end

---检测某个玩家是否完成了指定ID的成就
--@param #any player 可以是玩家的英雄或者玩家id
--@param #string achvType 成就类型，引用SrvAchv.achv_typeXXX
--@param #string achvID 成就id
--@param #string heroName 对于成就类型是单英雄成就的，需要添加英雄名称条件
--@return #boolean 是否完成
--@return #string 如果完成了，返回完成时间（格式=yyyy-MM-dd HH:mm:ss）
function m.HasAchieved(player,achvType,achvID,heroName)
	if type(player) ~= "number" then
		player = PlayerUtil.GetOwnerID(player);
	end
	
	if type(player) == "number" and achvType and achvID then
		local data = player_achievements[player]
		if data then
			local key = m.GetAchievementServerID(achvType,achvID)
			
			if achvType == m.achv_type_1 then
				if heroName then
					local result = data[key] and data[key][heroName]
					if result then
						if result == "?" then
							return true,"UNKNOWN"
						else
							return true,result
						end
					end
				end
			else
				local result = data[key]
				if result then
					if result.time == "?" then
						return true,"UNKNOWN"
					else
						return true,result.time
					end
				end
			end
		end
	end
	return false;
end

---获得某个玩家已经完成的所有成就信息，返回的数据不是副本，不要随意修改<p>
--返回的数据结构为：{
--	achvType_achvID = {heroName = "xxxx"}, ---英雄单体成就类，xxxx是达成时间
--	achvType_achvID = {time = "xxxx"}, --其他成就
--	...
--}
--@param #any player 玩家ID或玩家的英雄
function m.GetPlayerData(player)
	local PlayerID = PlayerUtil.TryGetPlayerID(player)
	if PlayerID then
		return player_achievements[PlayerID]
	end
end

---获取玩家某个类型下已完成的成就信息，返回的数据不是副本，不要随意修改<p>
--返回的数据结构为：{
--	achvType_achvID = {heroName = "xxxx"}, ---英雄单体成就类，xxxx是达成时间
--	achvType_achvID = {time = "xxxx"}, --其他成就
--	...
--}
--@param #any player 玩家ID或玩家的英雄
--@param #string achvType 成就类型，引用SrvAchv.achv_typeXXX
function m.GetPlayerDataForType(player,achvType)
	local PlayerID = PlayerUtil.TryGetPlayerID(player)
	if PlayerID then
		local data = player_achievements[PlayerID]
		if data then
			local result = {}
			for key, value in pairs(data) do
				if string.find(key,achvType) then
					result[key] = value
				end
			end
			return result;
		end
	end
end

---获取某个玩家某个英雄的通关次数
--@param #any player 玩家ID或玩家的英雄
--@param #string heroName 英雄名字
--@return #number,#number 返回两个值，第一个是总通关次数；第二个是当前难度通关次数。传入参数异常的话，返回nil
function m.GetHeroPassCount(player,heroName)
	local PlayerID = PlayerUtil.TryGetPlayerID(player)
	if PlayerID and heroName then
		local data = player_pass_count[PlayerID]
		if data then
			local heroData = data[heroName]
			if heroData then
				local total = heroData.total or 0
				local difficulty = heroData.difficulty and heroData.difficulty[GetGameDifficulty()] or 0
				return total,difficulty
			end
		end
		
		return 0,0
	end
end

function m.SyncPlayerDataToClient(PlayerID,heroType,difficultyType,hiddenType)
	if PlayerUtil.IsValidPlayer(PlayerID) then
		local data = {}
		--单英雄
		if heroType then
			local heroData = {}
			data.hero = heroData
			
			--排序后发往客户端
			local all_hero = UnitKV.GetAllActiveHeroes()
			local heroNames = {}
			for heroName, _ in pairs(all_hero) do
				if not m.ignore_hero[heroName] then
					table.insert(heroNames,heroName)
				end
			end
			table.sort(heroNames)
			for _, heroName in ipairs(heroNames) do
				table.insert(heroData,{hero={name=heroName,primary=all_hero[heroName].primary},achv=GetPlayerDataForType(PlayerID,m.achv_type_1,heroName)})
			end
			--力量
			table.insert(heroData,{other=1,achv=GetPlayerDataForType(PlayerID,m.achv_type_2)})
			--敏捷
			table.insert(heroData,{other=2,achv=GetPlayerDataForType(PlayerID,m.achv_type_3)})
			--智力
			table.insert(heroData,{other=3,achv=GetPlayerDataForType(PlayerID,m.achv_type_4)})
			--全部
			table.insert(heroData,{other=0,achv=GetPlayerDataForType(PlayerID,m.achv_type_5)})
		end
		
		--难度类
		if difficultyType then
			data.difficulty = GetPlayerDataForType(PlayerID,m.achv_type_6)
		end
		
		--隐藏
		if hiddenType then
			data.hidden = GetPlayerDataForType(PlayerID,m.achv_type_7)
		end
		
		SendToClient(PlayerID,"tzj_game_data_achievement_update",data)
	end
end


function m.Client_GetPlayerData(_,keys)
	m.SyncPlayerDataToClient(keys.PlayerID,true,true,true)
end

---用来记录通关次数的
function m.RecordPassCount(PlayerID)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	local hero = PlayerUtil.GetHero(PlayerID);
	if aid and hero then
		return {hero=hero:GetUnitName()}
	end
end

RegisterEventListener("tzj_game_data_achievement_get",m.Client_GetPlayerData)
return m;