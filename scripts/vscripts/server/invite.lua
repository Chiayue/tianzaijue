local m = {}

local function FormatPlatformReward(reward)
	if reward then
		reward = JSON.decode(reward);
		
		local t = {}
		for key, var in pairs(reward) do
			if key == "jing_stone " then
				t.jing = var.count
			else
				t[key] = var.count
			end
		end
		return t
	end
end

local function FormatBindCountReward(reward)
	if reward then
		reward = JSON.decode(reward);
		
		local t = {}
		for key, var in pairs(reward) do
			t[key] = var.time
		end
		return t
	end
end

function m.Init(data)
	if data then
		local bind = data.bind or {}
		local count = data.count or {}
		local platform = data.platform or {}
		
		local players = PlayerUtil.GetAllPlayersID(false,true)
		for _, PlayerID in pairs(players) do
			local aid = PlayerUtil.GetAccountID(PlayerID)
			
			local pData = {
				bind = bind[aid],
				count = count[aid],
				actived = platform[aid]
			}
			
			if pData.bind and pData.bind.reward then
				pData.bind.reward = FormatPlatformReward(pData.bind.reward)
			end
			
			if pData.count and pData.count.reward then
				pData.count.reward = FormatBindCountReward(pData.count.reward)
			end
			
			if pData.actived then
				for key, var in pairs(pData.actived) do
					if var.reward then
						var.reward = FormatPlatformReward(var.reward)
					end
				end
			end
			
			--初始化玩家数据
			Invite:init(PlayerID,pData)
		end
	end
end

---激活平台类的邀请码
--@param #number PlayerID 玩家id
--@param #string code 邀请码
--@param #function callback 回调函数：success,arg2
--如果success=true，则arg2是一个表，里面包含相关数据的最新值：邀请码使用结果、晶石总量、商城物品数据等
--如果success=false，则arg2代表错误代码。0=未知错误，1=参数错误（玩家id或者邀请码为空），2=邀请码不存在或已失效，3=已使用过该邀请码
function m.ActivePlatform(PlayerID,code,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if not aid or not code then
		callback(false,1)
	else
		local params = {}
		params.mode = 1;
		params.aid = aid
		params.code = code
		
		PlayerUtil.LockAction(PlayerID,"invite_ap",function()
			SrvHttp.load("tzj_invite",params,function(srv_data)
				--先清空掉锁，避免后面出错了清空不掉
				PlayerUtil.UnlockAction(PlayerID,"invite_ap")
				
				if srv_data then
					if srv_data.result then
						if srv_data.result.reward then
							srv_data.result.reward = FormatPlatformReward(srv_data.result.reward)
						end
						local result = {invite=srv_data.result,jing=srv_data.jing,items=srv_data.items}
						callback(true,result)
					else
						local error = 0
						if srv_data.error == "1" then
							error = 1
						elseif srv_data.error == "2" then
							error = 2
						elseif srv_data.error == "4" then
							error = 3
						end
						callback(false,error)
						DebugPrint("[Invite.ActivePlatform] Server response error:",srv_data.error)
					end
				else
					callback(false,0)
				end
			end)
		end)
	end
end

---绑定玩家
--@param #number PlayerID 玩家ID
--@param #string targetPlayer 要绑定的玩家邀请码 "tzjxxxxxxx"
--@param #table bindReward 绑定成功，给当前玩家发放什么奖励，表结构：
--{
--	itemName = { --商品名称（商城道具），晶石奖励则名称固定为： jing_stone
--		count=0, --数量，不可为空。如果物品不可叠加，则传入0；否则传入相应的数量。
--		valid = 30 --有效天数，可以为空。没有就不传
--	},
--	...
--}
--@param #function callback 回调函数
--成功时回调传入(true,result,target) ，result代表的是奖励的结果，包括邀请码使用记录、最新的晶石总量、商城物品数据等。有target代表绑定的玩家也在本局游戏中，这个target就是该玩家的信息
--失败时回调传入(false,error) error = 0（未知错误），1（参数错误），2（要绑定的玩家不存在，必须是玩过一次游戏的才能被绑定），3（已经绑定了某个玩家了）,4（不能绑定自己）
function m.BindPlayer(PlayerID,targetPlayer,bindReward,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if not aid or not targetPlayer or type(bindReward) ~= "table" then
		callback(false,1)
	else
		local targetID = string.sub(targetPlayer,4)
		
		if aid == targetID then
			callback(false,4)
			return;
		end
	
		local players = PlayerUtil.GetAllPlayersID(false,true)
		local existPlayer = nil
		for _, pid in pairs(players) do
			if targetID == PlayerUtil.GetAccountID(pid) then
				existPlayer = pid
				break;
			end
		end
	
	
		local params = {}
		params.mode = 2;
		params.aid = aid
		params.code = targetID
		params.reward = JSON.encode(bindReward)
		
		
		PlayerUtil.LockAction(PlayerID,"invite_bind",function()
			SrvHttp.load("tzj_invite",params,function(srv_data)
				PlayerUtil.UnlockAction(PlayerID,"invite_bind")
				
				if srv_data then
					if srv_data.result then
						if srv_data.result.reward then
							srv_data.result.reward = JSON.decode(srv_data.result.reward)
						end
						local result = {invite=srv_data.result,jing=srv_data.jing,items=srv_data.items}
						local target = nil
						if existPlayer then
							target = {pid=existPlayer,inviteCount=srv_data.bindCount}
						end
						callback(true,result,target)
					else
						local error = 0
						if srv_data.error == "1" then
							error = 1
						elseif srv_data.error == "2" then
							error = 2
						elseif srv_data.error == "3" then
							error = 3
						elseif srv_data.error == "6" then
							error = 4
						end
						callback(false,error)
						DebugPrint("[Invite.BindPlayer] Server response error:",srv_data.error)
					end
				else
					callback(false,0)
				end
			end)
		end)
	end
end

---获得某个玩家邀请玩家的总数以及奖励领取情况
function m.GetInviteCount(PlayerID,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if not aid then
		callback(false,1)
	else
		local params = {}
		params.mode = 3;
		params.aid = aid
		
		PlayerUtil.LockAction(PlayerID,"invite_count",function()
			SrvHttp.load("tzj_invite",params,function(srv_data)
				PlayerUtil.UnlockAction(PlayerID,"invite_count")
				
				if srv_data then
					local result = srv_data.result
					if result then
						if result == -1 then
							result = {count= 0}
						end
						callback(true,result)
					else
						callback(false,0)
						DebugPrint("[Invite.GetInviteCount] Server response error:",srv_data.error)
					end
				else
					callback(false,0)
				end
			end)
		end)
	end
end

---领取累计邀请奖励
--@param #number PlayerID 玩家ID
--@param #number stage 奖励阶段
--@param #number count 达成该阶段需要邀请的玩家数量
--@param #table reward 奖励信息，表结构：
--{
--	itemName = { --商品名称（商城道具），晶石奖励则名称固定为： jing_stone
--		count=0, --数量，不可为空。如果物品不可叠加，则传入0；否则传入相应的数量。
--		valid = 30 --有效天数，可以为空。没有就不传
--	},
--	...
--}
--@param #function callback 回调函数
--成功时回调传入(true,result) ，result代表的是奖励的结果，包括领取时的服务器时间、最新的晶石总量、商城物品数据等
--失败时回调传入(false,error,arg3) error = 0（未知错误），1（参数错误），
--2（玩家当前邀请的数量尚未达到这个阶段需要的数量--服务器和客户端不同步了，此时arg3就代表服务器记录的邀请总数），
--3（该阶段奖励已经领取过了）
function m.getReward(PlayerID,stage,count,reward,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if not aid or not stage or not count or type(reward) ~= "table" then
		callback(false,1)
	else
		local params = {}
		params.mode = 4;
		params.aid = aid
		params.stage = stage
		params.count = count
		params.reward = JSON.encode(reward)
		
		PlayerUtil.LockAction(PlayerID,"invite_gr",function()
			SrvHttp.load("tzj_invite",params,function(srv_data)
				--先清空掉锁，避免后面出错了清空不掉
				PlayerUtil.UnlockAction(PlayerID,"invite_gr")
				
				if srv_data then
					if srv_data.result then
						local result = {time=srv_data.result,jing=srv_data.jing,items=srv_data.items}
						callback(true,result)
					else
						local error = 0
						local count = nil
						if srv_data.error == "1" then
							error = 1
						elseif srv_data.error == "2" then
							error = 2
							count = srv_data.count
						elseif srv_data.error == "4" then
							error = 3
						end
						callback(false,error,count)
						DebugPrint("[Invite.ActivePlatform] Server response error:",srv_data.error)
					end
				else
					callback(false,0)
				end
			end)
		end)
	end
end

return m;