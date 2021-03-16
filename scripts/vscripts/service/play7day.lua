if Play7Day == nil then
	---@class Play7Day
	Play7Day = {
	}
end
---@type Play7Day
local public = Play7Day

function public:Init(bReload)
	Request:Event("play.recv_reward", Dynamic_Wrap(public, "OnRecvReward"), public)
	Request:Event("play.recv_nian_reward", Dynamic_Wrap(public, "OnRecvNianReward"), public)
end


-- 请求领取任务奖励
function public:OnRecvReward(params)
	local iPlayerID = params.PlayerID
	local sDay = tostring(tonumber(params.day) or '')

	local tTable = NetEventData:GetTableValue('service', 'player_7play_' .. iPlayerID)
	if not tTable then return 'error_not_data' end
	local tDayData = tTable[sDay]
	if not tDayData then return 'error_day_numb' end

	local fVal = tonumber(tDayData[1]) or 0
	local fSum = tonumber(tDayData[2]) or 1
	local bReceive = 1 == tonumber(tDayData[3])

	-- 验证是否完成
	if fVal < fSum then
		return 'error_play7day_not_finish'
	end

	-- 验证是否已经领取
	if bReceive then
		return 'error_play7day_received'
	end

	local data = Service:POSTSync('play.recv_reward', {
		uid = GetAccountID(iPlayerID),
		sid = sDay,
	})

	print('play.recv_reward', data)
	if data then
		DeepPrintTable(data)
	end

	return data
end


-- 请求领取年兽奖励
function public:OnRecvNianReward(params)
	local iPlayerID = params.PlayerID
	local sDay = tostring(tonumber(params.day) or '')

	local tTable = NetEventData:GetTableValue('service', 'player_nian_play_' .. iPlayerID)
	if not tTable then return 'error_not_data' end
	local tDayData = tTable[sDay]
	if not tDayData then return 'error_day_numb' end

	local fVal = tonumber(tDayData[1]) or 0
	local fSum = tonumber(tDayData[2]) or 1
	local bReceive = 1 == tonumber(tDayData[3])

	-- 验证是否完成
	if fVal < fSum then
		return 'error_play7day_not_finish'
	end

	-- 验证是否已经领取
	if bReceive then
		return 'error_play7day_received'
	end

	local data = Service:POSTSync('play.recv_nian_reward', {
		uid = GetAccountID(iPlayerID),
		sid = sDay,
	})

	print('play.recv_nian_reward', data)
	if data then
		DeepPrintTable(data)
	end

	return data
end

















return public