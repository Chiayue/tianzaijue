--玩家连接或者断开游戏的处理
local m = {}

--玩家连接游戏的时候会调用一两次，只是在连接的时候调用，而不是完全连接（区分下面的ConnectFull）
--function m:PlayerConnect(keys)
----[[DebugPrint('[BAREBONES] PlayerConnect')
--  DebugPrintTable(keys)--]]
--
--end

---某个玩家成功连接到服务器，无论是第一次还是第几次
--PlayerID  (string): 0  (number)
--game_event_listener  (string): 67108872  (number)
--game_event_name  (string): player_connect_full  (string)
--index  (string): 0  (number)
--splitscreenplayer  (string): -1  (number)
--userid  (string): 1  (number)
function m:OnConnectFull(keys)
	local PlayerID = keys.PlayerID;
	---如果是观战的，不处理
	if PlayerResource:IsValidPlayer(PlayerID) then
		--添加玩家信息
		PlayerUtil.AddPlayer(PlayerID)
		--必须加上这一步操作，否则在创建英雄不生效
		if PlayerResource:GetCustomTeamAssignment(PlayerID) ~= TEAM_PLAYER then
			PlayerResource:SetCustomTeamAssignment(PlayerID,TEAM_PLAYER)
		end
		
		local reconnect = PlayerUtil.getAttrByPlayer(PlayerID,"player_reconnect")
		if reconnect then
			PlayerUtil.setAttrByPlayer(PlayerID,"player_reconnect",nil)
		end
	end
end


--当玩家断开连接的时候触发
--PlayerID: 2	(number)
-- name: sardine	(string)
--networkid: [U:1:334237028]	(string)
--reason: 29	(number)
--splitscreenplayer: -1	(number)
--userid: 2	(number)
--xuid: 76561198294502756
function m:OnDisconnect(keys)
--	local PlayerID = keys.PlayerID
--	SendToAllClient("zxj_player_disconnect",{PlayerID=PlayerID,SteamID=PlayerUtil.GetSteamID(keys.PlayerID)})
--	local reconnect = PlayerUtil.getAttrByPlayer(PlayerID,"player_reconnect")
--	if reconnect then
--		PlayerUtil.setAttrByPlayer(PlayerID,"player_reconnect",nil)
--	end
end


--玩家重连进游戏时候进行处理，主要是给玩家加特效、修改状态、初始化独立的ui等等(这个应该是点击重新连接就会触发，并不是重新连入后触发)
--	PlayerID: 2	(number)
--	splitscreenplayer: -1	(number)
function m:OnPlayerReconnect(keys)
	local PlayerID = keys.PlayerID;
	---如果是观战的，不处理
	if PlayerResource:IsValidPlayer(PlayerID) then
		--如果游戏已经开始了，就重新加载游戏运行时的相关内容
		PlayerUtil.setAttrByPlayer(PlayerID,"player_reconnect",true)
	end
end


return m
