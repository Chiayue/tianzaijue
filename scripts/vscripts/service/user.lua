if User == nil then
	---@class User
	User = {}
end

---@type User
local public = User

function public:UpdateNetTables()
end

function public:ReqPlayerLogin(call, iPlayerID)
	Service:POST('user.login',
	{
		steamid = GetAccountID(iPlayerID),
	},
	function(data)
		if data and data.status == 0 then
		end
		call(data)
	end)
end

----------------------------------------------------------------------------------------------------
-- public