if player == nil then
	---@class player
	player = {
	}
end

local public = player

function public:login(call, iPlayerID)
	Service:POST('player.login',
	{
		uid = GetAccountID(iPlayerID),
		sid = GetSteamID(iPlayerID),
		name = GetPlayerName(iPlayerID),
	}, function(data)
		print('player.login')
		if data and data.status == 0 then
			-- TODO:
		end
		call(data)
	end)
end