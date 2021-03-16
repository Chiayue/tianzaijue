if game == nil then
	---@class game
	game = {
	}
end

local public = game

function public:config(call)
	Service:POST('game.config',
	{}, function(data)
		if data and data.status == 0 then
			-- TODO:
		end
		if is_function(call) then
			call(data)
		end
	end)
end