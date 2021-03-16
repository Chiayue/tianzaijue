if not TreasureBox then
	---@class TreasureBox
	TreasureBox = {

	}
end
---@type TreasureBox
local public = TreasureBox


function public:init(bReload)
	Request:Event("box.open", Dynamic_Wrap(public, "ReqOpenBox"), public)
	Request:Event("box.buyopen", Dynamic_Wrap(public, "ReqBuyOpenBox"), public)
end


--- 请求开宝箱
function public:ReqOpenBox(params)
	local iPlayerID = params.PlayerID
	local sBoxID = tostring(params.box_id)
	local iCount = tonumber(params.count)

	-- 验证是否拥有
	local tPlayerData = NetEventData:GetTableValue('service', 'player_box_' .. iPlayerID)
	if not tPlayerData or not tPlayerData[sBoxID] or iCount > tonumber(tPlayerData[sBoxID]) then
		return 'dota_hud_error_treasure_not_enoght'
	end

	-- 请求加经验
	local tData = {
		--account id
		uid = PlayerResource:GetSteamAccountID(iPlayerID),
		--宝箱 id
		sid = sBoxID,
		count = iCount,
	}

	local data = Service:POSTSync('box.open', tData)
	if data and -1 ~= data.status then
		---@class EventData_OpenBox
		local tEventData = {
			PlayerID = iPlayerID,
			iCount = iCount,
		}
		EventManager:fireEvent(ET_PLAYER.ON_OPEN_BOX, tEventData)
	end
	return data
end

--- 请求购买并打开宝箱
function public:ReqBuyOpenBox(params)
	local iPlayerID = params.PlayerID
	local sProductID = tostring(params.product_id)
	local iCount = tonumber(params.count)

	-- 验证商品
	local tProducts = NetEventData:GetTableValue('service', 'info_shop_product')
	if not tProducts then
		return 'error_not_found_product_info'
	end
	local tProduct = tProducts[sProductID]
	if not tProduct then
		return 'error_not_found_product_' .. sProductID
	end

	local tData = {
		uid = GetAccountID(iPlayerID),
		sid = sProductID,
		count = iCount,
	}
	local data = Service:POSTSync('box.buyopen', tData)
	if data and -1 ~= data.status then
		if 'table' == type(data.data) then
			---@class EventData_OpenBox
			local tEventData = {
				PlayerID = iPlayerID,
				iCount = #data.data,
			}
			EventManager:fireEvent(ET_PLAYER.ON_OPEN_BOX, tEventData)
		end
	end
	return data
end
















































return public