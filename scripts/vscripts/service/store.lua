if Store == nil then
	---@class Store Store
	Store = {
		PaymentState = {
			pending = 0,
			completed = 1,
			failed = 2,
			error = 3,
		}
	}
end
tPlayerStoreOrder = {}
---@type Store
local public = Store

PayType = {
	-- 月石
	moonstone = enumid(6660001),
	-- 星石
	starstone = enumid(6660002),
	-- 魂石，买英雄用
	soulstone = enumid(6660004),
	-- 星辉
	stardust = enumid(6660003)
}
enum(PayType)

function public:Init()
	Request:Event("shop.buy", Dynamic_Wrap(public, "StoreBuyItem"), public)
	Request:Event("order.create", Dynamic_Wrap(public, "StoreCreateOrder"), public)
	Request:Event("order.query", Dynamic_Wrap(public, "StoreOrderQuery"), public)
	Request:Event("order.check", Dynamic_Wrap(public, "OrderCheck"), public)
	Request:Event("cdkey.use", Dynamic_Wrap(public, "UseCDK"), public)
end

function public:InitPlayer(iPlayerID)

end


function public:StoreBuyItem(params)
	local iPlayerID = params.PlayerID
	local pid = tonumber(params.pid)
	local count = tonumber(params.count)

	local err = {
		status = -1,
		data = 'params error'
	}

	local tSealItme = NetEventData:GetTableValue('service', 'info_shop_product')

	if not pid or not iPlayerID or not exist(tSealItme, function(v, k)
		return string.equal(k, pid)
	end) then
		return err
	end

	local data = Service:POSTSync('shop.buy', {
		uid = GetAccountID(iPlayerID),
		pid = pid,
		count = count,
	})

	if data and data.status == 1 then
	end

	return data
end

function public:StoreCreateOrder(params)
	local iPlayerID = params.PlayerID
	local sid = params.sid
	local count = params.count
	local paytype = params.paytype
	local title = params.title

	local err = {
		status = -1,
		data = 'params error'
	}

	if not sid or not count or count <= 0 then
		return err
	end

	-- payssion 特殊处理
	local pmid = '';
	if tonumber(paytype) == nil then
		pmid = paytype
		paytype = 4000
	end

	local tReqData = {
		uid = GetAccountID(iPlayerID),
		itemid = sid,
		itemcount = count,
		paytype = paytype,
		pmid = pmid,
		body = title,
		title = title,
	}

	print('StoreCreateOrder req:')
	DeepPrintTable(tReqData)

	local data = Service:POSTSync('shop.order_create', tReqData)

	print('StoreCreateOrder res:')
	DeepPrintTable(data)

	if data and data.status == 0 then
		tPlayerStoreOrder[iPlayerID] = tPlayerStoreOrder[iPlayerID] or {}
		tPlayerStoreOrder[iPlayerID][data.data.order] = self.PaymentState.pending
	end

	print('StoreCreateOrder return:')

	return data
end

function public:StoreOrderQuery(params)
	local iPlayerID = params.PlayerID
	local order = params.order

	if not order then
		return "NOT_ORDER"
	end

	local data = Service:POSTSync('shop.order_query', {
		uid = GetAccountID(iPlayerID),
		orderid = order
	})

	return data
end

function public:OrderCheck(params)
	local iPlayerID = params.PlayerID

	local data = Service:POSTSync('shop.order_check', {
		uid = GetAccountID(iPlayerID),
	})

	return data
end

function public:UseCDK(params)
	local iPlayerID = params.PlayerID
	local key = params.key

	local data = Service:POSTSync('cdkey.use', {
		uid = GetAccountID(iPlayerID),
		key = key
	})

	return data
end

local tQueryTimes = {
	[1] = {
		time = 10,
		count = 1,
	},
	[2] = {
		time = 1,
		count = 30,
	},
	[3] = {
		time = 2,
		count = 30,
	},
	[4] = {
		time = 5,
		count = 30,
	},
	[5] = {
		time = 10,
		count = 30,
	},
	[6] = {
		time = 30,
		count = 10000,
	},
}
local fQueryTimer = 1
local tOrderQuery = {}
local function QueryOrder(order, iPlayerID)
	Service:POST('shop.order_query', {
		uid = GetAccountID(iPlayerID),
		orderid = order
	}, function(data)
		tOrderQuery[order].query = false
		if data then
			if data.status >= 0 then
				if tPlayerStoreOrder[iPlayerID][order] ~= data.status then
					tPlayerStoreOrder[iPlayerID][order] = data.status
					print('order status')
					DeepPrintTable(data)
					-- for iPlayer, v in pairs(tPlayerStoreOrder) do
					NetEventData:SetTableValue('service', 'order_status_' .. iPlayerID, {
						[order] = {
							status = data.status,
							firstpay = string.equal(data.data.firstpay, GetAccountID(iPlayerID))
						}
					})
					-- end
				end
				tPlayerStoreOrder[iPlayerID][order] = data.status
			end
			if data.status == Store.PaymentState.completed
			or data.status == Store.PaymentState.failed then
				tOrderQuery[order] = nil
			end
		end
	end)
end
local function AutoQueryOrder()
	Timer(1, function()
		for iPlayerID, v in pairs(tPlayerStoreOrder) do
			for order, status in pairs(v) do
				if status == Store.PaymentState.pending
				or status == Store.PaymentState.error then
					if tOrderQuery[order] == nil then
						tOrderQuery[order] = {
							status = status, -- 订单状态
							query = false, -- 是否请求中
							queryTime = 0, -- 查询进行时间
							queryCount = 0, -- 查询次数
							timerIndex = 1,
							-- 请求计时数据
							timerData = copy(tQueryTimes[1]),
						}
					end
					local tOrderQueryData = tOrderQuery[order]
					if not tOrderQueryData.query then
						-- 计时
						tOrderQueryData.queryTime = tOrderQueryData.queryTime + fQueryTimer
						tOrderQueryData.timerData.time = tOrderQueryData.timerData.time - fQueryTimer

						-- 时间不足进行下一跳
						if tOrderQueryData.timerData.time < 0 then
							tOrderQueryData.timerData.count = tOrderQueryData.timerData.count - 1
							if tOrderQueryData.timerData.count <= 0 then
								tOrderQueryData.timerIndex = math.min(tOrderQueryData.timerIndex + 1, #tQueryTimes)
								tOrderQueryData.timerData = copy(tQueryTimes[tOrderQueryData.timerIndex])
							else
								tOrderQueryData.timerData.time = tQueryTimes[tOrderQueryData.timerIndex].time
							end
							-- 开始查询订单
							tOrderQueryData.query = true
							tOrderQueryData.queryCount = tOrderQueryData.queryCount + 1
							QueryOrder(order, iPlayerID)
						end
					end
				end
			end
		end
		return fQueryTimer
	end)
end

AutoQueryOrder()