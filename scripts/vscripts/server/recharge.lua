local m = {}

local locks = {}

local CanAction = function(PlayerID,action,delay)
	local key = action..PlayerID
	if locks[key] then
		return false;
	end
	locks[key] = true
	TimerUtil.createTimerWithDelayAndRealTime(delay,function()
		locks[key] = nil
	end)
	return true;
end

---充值
function m.Client_Recharge(_,data)
	local PlayerID,count,type = data.PlayerID,data.count,data.type
	if not PlayerUtil.IsValidPlayer(PlayerID) or not CanAction(PlayerID,"recharge",3) then
		SendToClient(PlayerID,"tzj_recharge_notify",{busy=true})
		return;
	end
	
	if count > 0 and count%100 == 0 then
		--之前的订单会被覆盖掉
		local orderNO = PlayerUtil.GetAccountID(PlayerID).."_"..GetDateTime()
		PlayerUtil.setAttrByPlayer(PlayerID,"recharge_order",orderNO)
		
		SendToClient(PlayerID,"tzj_recharge_return",{order=orderNO,init=true})
		
		local aid = PlayerUtil.GetAccountID(PlayerID);
		local params = {aid = aid,payno = orderNO,msc = count,type = type,content = 0}
		params.time = 5
		params.width = 150
		params.height = 150
		
		SrvHttp.get("recharge",params,function(data)
			if data and data.success == "1" and data.url and data.url ~= "" then--成功创建订单
				---订单变化，可能被取消
				local orderNumber = PlayerUtil.getAttrByPlayer(PlayerID,"recharge_order");
				if orderNumber ~= orderNO then
					return;
				end
				
				SendToClient(PlayerID,"tzj_recharge_return",{order=orderNO,url=data.url,type=type})
				
				if type ~= 3 then
					m.Query(params.time,PlayerID,orderNO)
				end
			else --请求失败，删除掉
				PlayerUtil.setAttrByPlayer(PlayerID,"recharge_order",nil)
				SendToClient(PlayerID,"tzj_recharge_return",{order=orderNO})
			end
		end)
	else
		SendToClient(PlayerID,"tzj_recharge_notify",{busy=true})
	end
end

function m.Query(time,PlayerID,orderNO)
	local count = time * 60 
	local delay = 5 --5秒查询一次结果
	TimerUtil.createTimerWithRealTime(function()
		local orderNumber = PlayerUtil.getAttrByPlayer(PlayerID,"recharge_order");
		--缓存的订单发生了变化，就不再查询了
		if orderNumber == orderNO then
			count = count-1;
			if count == 0 then --时间结束了也没有支付，取消订单
				PlayerUtil.setAttrByPlayer(PlayerID,"recharge_order",nil)
				SendToClient(PlayerID,"tzj_recharge_canceld",{timeout=true})
			else
				--更新客户端显示的有效时间
				SendToClient(PlayerID,"tzj_recharge_update_timer",{time=count})
				--每隔一段时间异步查询一次支付结果
				delay = delay - 1
				if delay == 0 then
					m.QueryOrderStatus(PlayerID,orderNumber)
					delay = 5;
				end
				return 1;
			end
		end
	end)
end

---查询订单状态
function m.QueryOrderStatus(PlayerID,orderNumber,overtimeChek,isManualConfirm)
	if not PlayerUtil.IsValidPlayer(PlayerID) then
		return;
	end
	local aid = PlayerUtil.GetAccountID(PlayerID)
	SrvHttp.get("rechargeQuery",{payno=orderNumber,aid=aid},function(data)
		if not data then
			if overtimeChek then
				SendToClient(PlayerID,"tzj_recharge_notify",{overtime=true})
			end
			return;
		end
	
		local cachedOrder = PlayerUtil.getAttrByPlayer(PlayerID,"recharge_order");
		if cachedOrder == orderNumber then --订单没有变化的时候才处理
			local status = data and data.status
			
			local success = nil
			if status == "2" then
				success = true;
				if data.count then
					Shopmall:SetStone(PlayerID,nil,1,tonumber(data.count))
				end
			elseif status == "3" or status == "4" then
				success = false;
			elseif status == "7" then
				success = 0
			end
			
			if success ~= nil then
				if success ~= 0 then
					PlayerUtil.setAttrByPlayer(PlayerID,"recharge_order",nil)
				end
				SendToClient(PlayerID,"tzj_recharge_notify",{success=success,tryHint = success==0})
			else
				if isManualConfirm then
					SendToClient(PlayerID,"tzj_recharge_notify",{tryHint = true})
				end
			end
			
		end
	end)
end

---取消充值订单。
function m.Client_CancelOrder(_,data)
	local PlayerID,order = data.PlayerID,data.order
	if PlayerUtil.IsValidPlayer(PlayerID)  then
		if not CanAction(PlayerID,"CancelOrder",3) then
			SendToClient(PlayerID,"tzj_recharge_notify",{busy=true})
			return;
		end
		local cachedOrder = PlayerUtil.getAttrByPlayer(PlayerID,"recharge_order");
		if order == cachedOrder then
			PlayerUtil.setAttrByPlayer(PlayerID,"recharge_order",nil)
		end
		
		SendToClient(PlayerID,"tzj_recharge_canceld",{})
	end
end

function m.Client_RefreshMS(_,keys)
	local PlayerID = keys.PlayerID
	if PlayerUtil.IsValidPlayer(PlayerID) then
		if not CanAction(PlayerID,"refresh",30) then
			SendToClient(PlayerID,"tzj_account_refresh_ms_return",{cooldown=true})
			return
		end
	
		local params = {
			aid = PlayerUtil.GetAccountID(PlayerID)
		}
	
		SrvHttp.load("MagicStone",params,function(srv_data)
			local count = srv_data and srv_data[params.aid]
			if count then
				Shopmall:SetStone(PlayerID,nil,1,tonumber(count))
			end
			SendToClient(PlayerID,"tzj_account_refresh_ms_return",{count=count})
		end)
	end
end

function m.Client_PayPalConfirm(_,keys)
	local PlayerID = keys.PlayerID
	if PlayerUtil.IsValidPlayer(PlayerID) and keys.order then
		if not CanAction(PlayerID,"PayPalConfirm",1) then
			SendToClient(PlayerID,"tzj_recharge_notify",{tryHint = true})
			return;
		end
	
		m.QueryOrderStatus(PlayerID,keys.order,true,true)
	else
		SendToClient(PlayerID,"tzj_recharge_notify",{tryHint = true})
	end
end

RegisterEventListener("tzj_recharge",m.Client_Recharge)
RegisterEventListener("tzj_recharge_cancel",m.Client_CancelOrder)
RegisterEventListener("tzj_account_refresh_ms",m.Client_RefreshMS)
RegisterEventListener("tzj_account_paypal_confirm",m.Client_PayPalConfirm)

return m