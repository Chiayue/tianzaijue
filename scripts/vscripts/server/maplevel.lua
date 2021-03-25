local m = {}

---游戏通关奖励（包含各种经验加成后的值）
m.Reason_Game_Bonus = 1
---天灾之路
m.Reason_Battle_Pass = 2


---key = 玩家id，value = {exp=123, lvl=123,now=123,max=123}
local playerData = {}

local maxLevel = 25

local levelExp = {}

---计算等级，返回当前等级和当前等级下拥有的经验值和最大经验值
local function CalculateLevel(mapExp)
	for lvl, totalExp in ipairs(levelExp) do
		if mapExp < totalExp then
			local lastLevelTotalExp = levelExp[lvl - 1] or 0;
			return lvl,mapExp - lastLevelTotalExp,totalExp - lastLevelTotalExp
		end
	end
	--数值超了，以实际的最大等级计
	local max = #levelExp
	local levelData = levelExp[max] - levelExp[max - 1];
	return max,levelData,levelData
end

function m.InitPlayerData(srv_data)
	local players = PlayerUtil.GetAllPlayersID(false,true)
	for _, PlayerID in pairs(players) do
		local data = srv_data and srv_data[PlayerUtil.GetAccountID(PlayerID)]
		local exp = data and data.exp or 0
		local lvl,now,max = CalculateLevel(exp)
		playerData[PlayerID] = {exp=exp,lvl=lvl,now=now,max=max}
	end
	
	m.SyncDataToClient()
end

function m.SyncDataToClient(PlayerID)
	if PlayerID then
		SetNetTableValue("PlayerInfo","map_level_"..tostring(PlayerID),playerData[PlayerID])
	else
		for PlayerID, data in pairs(playerData) do
			SetNetTableValue("PlayerInfo","map_level_"..tostring(PlayerID),data)
		end
	end
end


function m.GetPlayerMapExp(PlayerID)
	if PlayerID then
		local data = playerData[PlayerID]
		return data and data.exp
	end
	return 0
end

---获得某个玩家的地图等级。默认返回1
function m.GetPlayerLevel(PlayerID)
	if PlayerID then
		local data = playerData[PlayerID]
		return data and data.lvl
	end
	return 0
end

---增加某个玩家的经验
--@param #number PlayerID 玩家id
--@param #number exp 要增加的经验值，只能是正数
--@param #number reason 增加原因，引用SrvMapLevel.ReasonXXX
function m.AddPlayerMapExp(PlayerID,exp,reason)
	if PlayerUtil.IsValidPlayer(PlayerID) and type(exp) == "number" and exp > 0 then
		local aid = PlayerUtil.GetAccountID(PlayerID);
		local params = {
			mode = 1,
			aid = aid,
			exp = exp,
			reason = reason
		}
		SrvHttp.load("tzj_map_exp",params,function(result)
			if result then
				if type(result.exp) == "number" then
					local lvl,now,max = CalculateLevel(result.exp)
					playerData[PlayerID] = {exp=result.exp,lvl=lvl,now=now,max=max}
					m.SyncDataToClient(PlayerID)
				elseif result.error then
					DebugPrint("server response error:",result.error)
				end
			end
		
		end)
	end
end


local function init()
	local exp = 0
	for lvl=1, maxLevel do
		if lvl < 11 then
			exp = exp + 100 * lvl
		elseif lvl < 21 then
			exp = exp + 200 * lvl - 1000
		elseif lvl < 31 then
			exp = exp + 2000 * lvl - 3000
		end
		
		levelExp[lvl] = exp
	end
	
	SetNetTableValue("config","map_level_max",{value=maxLevel})
end
init()
return m;