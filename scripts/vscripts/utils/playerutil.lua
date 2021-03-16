---玩家数据
--key是玩家id，value是一个table，包括各个玩家的数据
local PlayerData = {}
---内部数据，为了避免和其他模块调用setAttribute时用的key冲突，再维护一个表，仅供内部使用
--key是玩家id，value是一个table
local InternalData = {}
---房主玩家id
local hostPlayerID = nil;

local m = {}

---内部设置指定key的玩家数据。value可以是nil，会覆盖。
--已用key：
--hero（英雄实体）,host_player(房主玩家id)
local SetKV = function(player,key,value)
	if player and key then
		if type(player) == "table" then
			player = m.GetOwnerID(player)
		end
		if type(player) == "number" and m.IsValidPlayer(player) then
			local data = InternalData[player]
			if not data then
				data = {}
				InternalData[player] = data
			end
			data[key] = value
		end
	end
end

---内部获取指定key的玩家数据
--可用key：
--hero（英雄实体）,host_player(房主玩家id)
local GetKV = function(player,key)
	if player and key then
		if type(player) == "table" then
			player = m.GetOwnerID(player)
		end
		if type(player) == "number" and m.IsValidPlayer(player) then
			local data = InternalData[player]
			if data then
				return data[key]
			end
		end
	end
end

local colors = {
	[0]={55,121,254},
	[1]={104,254,193},
	[2]={191,5,193},
	[3]={241,240,17}
}

---初始化玩家数据
function m.AddPlayer(PlayerID)
	if PlayerID and m.IsValidPlayer(PlayerID) then
		if PlayerData[PlayerID] == nil then
			PlayerData[PlayerID] = {}
			InternalData[PlayerID] = {}
			
			local player = m.GetPlayer(PlayerID,true)
			if GameRules:PlayerHasCustomGameHostPrivileges(player) then
				hostPlayerID = PlayerID;
			end
			
			local color = colors[PlayerID];
			if color then
				PlayerResource:SetCustomPlayerColor(PlayerID,color[1],color[2],color[3])
			end
		end
	end
end

---设置一个玩家的英雄实体，同时根据英雄单位，初始化玩家的相应属性<br>
--当玩家断开连接后，通过玩家id将获取不到玩家，也就不能获取其控制的英雄，会出现各种bug，所以这里单独存储一下
function m.SetHero(PlayerID,hero)
	SetKV(PlayerID,"hero",hero)
end


---根据玩家信息获取对应的英雄实体。英雄实体有个函数：HasOwnerAbandoned，不知道是不是能获取玩家是否离开游戏这个状态
--@param #any player 玩家id或者玩家所拥有的单位实体
function m.GetHero(player)
	if player then
		--先尝试从缓存中读取英雄（玩家掉线以后貌似通过接口是获取不到英雄的），没有的话，在尝试返回玩家拥有的英雄
		local hero = GetKV(player,"hero")
		if hero then
			return hero
		end
		local playerEntity = PlayerResource:GetPlayer(player)
		if playerEntity then
			return playerEntity:GetAssignedHero()
		end
	end
end

---根据玩家id或者玩家拥有的实体，获取玩家实体。
--@param #any PlayerID 玩家id或玩家拥有的实体
--@param #boolean allState 是否返回所有状态的玩家，默认只返回连入游戏的玩家
--<ul>
--	<li>DOTA_CONNECTION_STATE_UNKNOWN</li>
--	<li>DOTA_CONNECTION_STATE_NOT_YET_CONNECTED</li>
--	<li>DOTA_CONNECTION_STATE_CONNECTED</li>
--	<li>DOTA_CONNECTION_STATE_DISCONNECTED</li>
--	<li>DOTA_CONNECTION_STATE_ABANDONED</li>
--	<li>DOTA_CONNECTION_STATE_LOADING</li>
--	<li>DOTA_CONNECTION_STATE_FAILED</li>
--</ul>
function m.GetPlayer(PlayerID,allState)
	if type(PlayerID) == "table" then
		PlayerID = PlayerID:GetPlayerOwnerID()
	end
	if allState or PlayerResource:GetConnectionState(PlayerID) == DOTA_CONNECTION_STATE_CONNECTED then
		return PlayerResource:GetPlayer(PlayerID);
	end
end

function m.GetHostPlayerID()
	return hostPlayerID
end

---根据单位实体返回该单位所属的玩家id
function m.GetOwnerID(unit)
	if EntityNotNull(unit) then
		return unit:GetPlayerOwnerID()
	end
end

---获取拥有这个单位的玩家实体
function m.GetOwner(unit)
	if type(unit) == "table" and unit.GetPlayerOwner then
		return unit:GetPlayerOwner()
	end
end

---尝试获取玩家id。用于不确定player是玩家id还是玩家单位的情况。
--无法获取的时候，返回nil
function m.TryGetPlayerID(player)
	if type(player) == "number" and m.IsValidPlayer(player) then
		return player;
	end
	
	if type(player) == "table" and player.GetPlayerOwnerID then
		return player:GetPlayerOwnerID()
	end
end

---返回所有玩家的id数组
--@param #boolean noDisconnect 忽略不在线的玩家（无论是断开连接还是离开游戏）
--@param #boolean noAbandoned 忽略已经离开游戏的玩家
function m.GetAllPlayersID(noDisconnect,noAbandoned)
	local result = {}
	for playerID, data in pairs(PlayerData) do
		if type(playerID) == "number" then
			if noDisconnect then
				if PlayerResource:GetConnectionState(playerID) == DOTA_CONNECTION_STATE_CONNECTED then
					table.insert(result,playerID)
				end
			elseif noAbandoned then
				if PlayerResource:GetConnectionState(playerID) ~= DOTA_CONNECTION_STATE_ABANDONED then
					table.insert(result,playerID)
				end
			else
				table.insert(result,playerID)
			end
		end
	end
	return result;
end

---判断一个玩家是否在线
function m.IsPlayerConnected(PlayerID)
	return PlayerResource:GetConnectionState(PlayerID) == DOTA_CONNECTION_STATE_CONNECTED
end

---判断一个玩家是否已经离开游戏了，彻底断开了
--@param #number PlayerID 玩家id，为空返回false
function m.IsPlayerLeaveGame(PlayerID)
	if not PlayerID then
		return false;
	end
	return PlayerResource:GetConnectionState(PlayerID) == DOTA_CONNECTION_STATE_ABANDONED
end

---这个应该是判断是否是正在游戏的玩家的。可以用来区分观战玩家
function m.IsValidPlayer(PlayerID)
	--IsValidPlayer必须传入非空值
	return PlayerID and PlayerResource:IsValidPlayer(PlayerID)
end

---获取当前进入游戏的玩家数量
--@param #boolean noDisconnect 忽略不在线的玩家
function m.GetPlayerCount(noDisconnect)
	if noDisconnect then
		local count = 0
		for playerID, data in pairs(PlayerData) do
			if type(playerID) == "number" then
				if noDisconnect then
					if PlayerResource:GetConnectionState(playerID) == 2 then
						count = count + 1
					end
				else
					count = count + 1
				end
			end
		end
		
		return count
	else--这个会返回加入该队伍的玩家数量，即使该玩家已经离开游戏了
		return PlayerResource:GetPlayerCountForTeam(TEAM_PLAYER)
	end
end


---获取玩家的某项属性。参数为空或者找不到，则返回nil
--@param #any player 玩家id或者单位实体
--@param #string attrName 属性标识，不可为空
function m.getAttrByPlayer(player,attrName)
	if player and attrName and PlayerData then
		if type(player) == "table" then
			player = m.GetOwnerID(player)
		end
		if type(player) == "number" then
			local data = PlayerData[player]
			if data then
				return data[attrName]
			end
		end
	end
end

---设置玩家的属性
--@param #any player 玩家id或者单位实体。默认只有初始化过英雄的玩家才会有缓存数据，如果不存在缓存数据，则不会存储当前数据。
--@param #string attrName 属性标识，不可为空
--@param #any value 属性值，可为空
function m.setAttrByPlayer(player,attrName,value)
	if player and attrName and PlayerData then
		if type(player) == "table" then
			player = m.GetOwnerID(player)
		end
		if type(player) == "number" and m.IsValidPlayer(player) then
			local data = PlayerData[player]
			if data then
				data[attrName] = value
			end
		end
	end
end

---获取指定玩家的SteamID
--@param #number PlayerID 玩家id
--@param #boolean returnNum 是否返回数值，默认返回的是字符串形式
function m.GetSteamID(PlayerID,returnNum)
	if returnNum then
		return PlayerResource:GetSteamID(PlayerID)
	else
		return tostring(PlayerResource:GetSteamID(PlayerID));
	end
end

---获取指定玩家的AccountID（玩家信息能看到的那一串数字）
--@param #number PlayerID 玩家id
--@param #boolean returnNum 是否返回数值，默认返回的是字符串形式
function m.GetAccountID(PlayerID,returnNum)
	if returnNum then
		return PlayerResource:GetSteamAccountID(PlayerID);
	else
		return tostring(PlayerResource:GetSteamAccountID(PlayerID));
	end
end

---获取所有玩家账号，并拼接成字符串。返回一个表，账号字符串作为表的aid属性
function m.GetAllAccount(onlyAid,noAbandoned)
	local aids = nil;
	local sids = nil;
	for _,PlayerID in ipairs(PlayerUtil.GetAllPlayersID(false,noAbandoned)) do
		local accountID = PlayerUtil.GetAccountID(PlayerID)
		if aids then
			aids = aids .. "," .. accountID
		else
			aids = accountID;
		end
		
		if not onlyAid then
			local steamID = PlayerUtil.GetSteamID(PlayerID)
			if not sids then
				sids = {}
			end
			
			sids[accountID] = steamID
		end
	end
	
	if onlyAid then
		return {aid=aids}
	else
		if sids then
			sids = JSON.encode(sids)
		end
		return {aid=aids,sidMap=sids}
	end
end

---锁定玩家操作，锁定后不可重复执行该操作。除非调用了UnlockAction清除锁定状态
function m.LockAction(PlayerID,actionName,handler)
	local attr = "action_"..actionName;
	if not m.getAttrByPlayer(PlayerID,attr) then
		m.setAttrByPlayer(PlayerID,attr,true)
		
		local status = pcall(handler)
		if not status then
			m.UnlockAction(PlayerID,actionName)
		else
			return true;
		end
	end
end
---清除玩家某个操作的锁定状态
function m.UnlockAction(PlayerID,actionName)
	m.setAttrByPlayer(PlayerID,"action_"..actionName,false)
end

---修改某个玩家的金币数量
--@param #any player 玩家ID或者玩家拥有的单位
--@param #number gold 金币，可正可负
--@return #number 返回修改了多少
function m.ModifyGold(player,gold)
	if type(player) == "table" then
		player = m.GetOwnerID(player)
	end
	return PlayerResource:ModifyGold(player, gold, false, DOTA_ModifyGold_Unspecified)
end

return m;
