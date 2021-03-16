if not IsServer() then
	return
end
----------------------------------------------------------------------------------------------------
-- 服务器数据工具脚本
----------------------------------------------------------------------------------------------------
local STABLE = _G._STABLE or {}
_G._STABLE = STABLE
function StableRequest(obj, funRequest, ...)
	local k = DoUniqueString('STABLE')
	STABLE[k] = {
		status = false,
		retry = SERVER_RETRY
	}
	local args = { ... }

	local function callback(status)
		if status then
			STABLE[k] = nil
		else
			STABLE[k].retry = STABLE[k].retry - 1
			if STABLE[k].retry > 0 then
				if args then
					funRequest(obj, callback, unpack(args))
				else
					funRequest(obj, callback)
				end
			else
				STABLE[k] = false
			end
		end
	end

	funRequest(obj, callback, ...)
	return k
end
function GetRequestStatus(index)
	if type(STABLE[index]) == 'table' then
		return STABLE[index].status
	end
	if STABLE[index] == nil then
		return true
	end
	return STABLE[index]
end

function CALL(func, ...)
	if func and type(func) == 'function' then
		local args = { ... };
		return func(unpack(args));
	end
end

function GetAccountID(iPlayerID)
	if PlayerResource:IsValidPlayer(iPlayerID) then
		_Player2Account = _Player2Account or {}
		_Account2Player = _Account2Player or {}
		_Player2Account[iPlayerID] = tonumber(PlayerResource:GetSteamAccountID(iPlayerID))
		_Account2Player[_Player2Account[iPlayerID]] = iPlayerID
		return tonumber(PlayerResource:GetSteamAccountID(iPlayerID))
	end
	return -1;
end

function GetSteamID(iPlayerID)
	if PlayerResource:IsValidPlayer(iPlayerID) then
		return tostring(PlayerResource:GetSteamID(iPlayerID))
	end
	return -1;
end

function GetPlayerName(iPlayerID)
	if PlayerResource:IsValidPlayer(iPlayerID) then
		return PlayerResource:GetPlayerName(iPlayerID)
	end
	return -1;
end

function GetPlayerIDByAccount(iAccountID)
	return _Account2Player and _Account2Player[iAccountID]
end

function GetMatchID()
	if IsInToolsMode() then
		if _MATCH_ID then
			return _MATCH_ID
		end
		local s = ''
		for k, v in pairs(LocalTime()) do
			s = s .. v
		end
		s = s .. RandomInt(1000, 9999)
		_MATCH_ID = tonumber(s)
		return _MATCH_ID
	end
	return tostring(GameRules:Script_GetMatchID())
end

function GetGameTime()
	return math.floor(GameRules:GetGameTime())
end

--玩家相关
function GetPlayerHero(iPlayerID)
	if PlayerResource:IsValidPlayerID(iPlayerID) then
		return PlayerResource:GetSelectedHeroEntity(iPlayerID)
	end
end
function GetPlayerHealth(iPlayerID)
	return PlayerData:GetHealth(iPlayerID)
end
function GetPlayerMana(iPlayerID)
	return PlayerData:GetMana(iPlayerID)
end
function GetPlayerLevel(iPlayerID)
	local hHero = GetPlayerHero(iPlayerID)
	if IsValid(hHero) then
		return hHero:GetLevel()
	end
end

function GetPlayer(iPlayerID)
	if tonumber(iPlayerID) then
		return PlayerResource:GetPlayer(tonumber(iPlayerID))
	end
end

--- 发送事件到一个玩家
function SendGameEvent2Player(iPlayerID, sEventName, tData)
	local hPlayer = GetPlayer(iPlayerID)
	if hPlayer then
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, sEventName, tData)
	end
end
--- 发送事件到所有玩家
function SendGameEvent2AllPlayer(sEventName, tData)
	CustomGameEventManager:Send_ServerToAllClients(sEventName, tData)
end