if BP == nil then
	---@class BP Battlepass
	BP = {
	}
end

---@type BP
local public = BP

function public:Init(bReload)
	Request:Event("bp.recv", Dynamic_Wrap(public, "ReqReceive"), public)
	Request:Event("bp.recvall", Dynamic_Wrap(public, "ReqReceiveAll"), public)
	if IsInToolsMode() then
		Request:Event("bp.addxp", Dynamic_Wrap(public, "ReqAddXP"), public)
	end
end

---请求领取一个奖励
function public:ReqReceive(params)
	local iPlayerID = params.PlayerID
	local level = params.level
	local sid = params.sid

	local tData = {
		--account id
		uid = PlayerResource:GetSteamAccountID(iPlayerID),
		--物品id
		sid = sid,
		--经验
		level = level,
	}

	local data = Service:POSTSync('bp.recv', tData)
	return data
end

---请求领取全部奖励
function public:ReqReceiveAll(params)
	local iPlayerID = params.PlayerID

	local tData = {
		--account id
		uid = PlayerResource:GetSteamAccountID(iPlayerID),
	}

	local data = Service:POSTSync('bp.recvall', tData)
	return data
end

---请求领取全部奖励
function public:ReqAddXP(params)
	local iPlayerID = params.PlayerID

	local tData = {
		--account id
		uid = PlayerResource:GetSteamAccountID(iPlayerID),
		xp = 500,
	}

	local data = Service:POSTSync('bp.addxp', tData)
	return data
end

return public