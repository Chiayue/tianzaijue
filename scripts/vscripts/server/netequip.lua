local m = {}
---玩家数据是否初始化完毕
m.PlayerDataInited = false;

---存档装备来源：打怪掉落
m.source_drop = 1
---存档装备来源：开箱子
m.source_box = 2


---玩家数据，key是玩家id，value是一个table，其结构如下：
--{
--	[id] = {
--		name = "xxxxx" --对应的物品道具名（kv里那个）
--		slot = 123 --位置，可能为nil（由于移动装备位置不是实时更新的，所以可能会出现覆盖数据的情况，如果被覆盖了就会出现nil）
--		quality = 123 --品质 
--		grade = 123 --品阶
--		attr = {...} --物品属性
--		score = 123 --装备积分/战斗力
--		
--		acquire_source = 1 --物品来源，对应SrvNetEquip.source_xxx的值
--		acquire_time = 1 --获得该物品的时间
--	},
--	[id] = ...
--	...
--}
local playerData = {}

---将服务端返回的数据简单处理一下，方便在dota端使用
--@param #table data 服务器数据
local function FormatServerData(data)
	--服务端存的是字符串，这里转成数字
	if data.quality then
		data.quality = tonumber(data.quality)
	end
	if data.grade then
		data.grade = tonumber(data.grade)
	end
	if data.score then
		data.score = tonumber(data.score)
	end
	if data.slot then
		data.slot = tonumber(data.slot)
	end
	return data
end

local function CreateRequestParams(aid,mode)
	return {aid=aid,mode=mode}
end

local function GetPlayerData(PlayerID)
	local cache = playerData[PlayerID]
	if not cache then
		cache = {}
		playerData[PlayerID] = cache
	end
	return cache;
end


function m.InitPlayerData(srv_data)
	if srv_data then
		local players = PlayerUtil.GetAllPlayersID(false,true)
		for _, PlayerID in pairs(players) do
			local pd = GetPlayerData(PlayerID)
		
			local data = srv_data[PlayerUtil.GetAccountID(PlayerID)]
			if data then
				local existSlot = {}
				for id, item in pairs(data) do
					local formatted = FormatServerData(item);
					--极端情况下有重复的，清空dota端的slot，重新分配
					if item.slot then
						if not existSlot[item.slot] then
							existSlot[item.slot] = true
						else
							formatted.slot = nil
						end
					end
					pd[id] = formatted
				end
			end
		end
	end
	
	m.PlayerDataInited = true
end

---获得某个玩家的存档装备数据，返回一个数组结构的表。 
--在调用的时候要判断SrvNetEquip.PlayerDataInited是否是true，如果为false则需要延迟获取。
--
--数据结构如下： 
--{ 
--	["xxxxx"] = { --物品唯一id 
--		name = "xxxxx" --对应的物品道具名（kv里那个） 
--		slot = 123 --装备位置，有可能为空（那就是被覆盖了，此时要在背包中重新找位置放置，然后调用SrvNetEquip.UpdateEmptySlot方法，更新一下位置缓存，否则在游戏结束的时候无法记录最新的位置） 
--		quality = 123 --品质  
--		grade = 123 --品阶 
--		score = 123 --战斗力 
--		attr = {...} --物品属性 
--	}, 
--	["xxxxx"] = ... 
--	... 
--} 
function m.GetPlayerData(PlayerID)
	if not m.PlayerDataInited then
		return 
	end

	local data = GetPlayerData(PlayerID);
	if data then
		--返回副本，避免被外部修改
		local result = {}
		for id, value in pairs(data) do
			result[id] = {
				name = value.name,
				slot = value.slot,
				quality = value.quality,
				grade = value.grade,
				score = value.score,
				attr = TableCopy(value.attr)
			}
		end
		return result;
	end
end

---在服务器中记录一个新的存档装备信息
--@param #number PlayerID 玩家id(0,1,2....)
--@param #number slot 物品在存档背包中的位置（1-N），同一个位置上多次新增的话，会进行覆盖操作。
--@param #string itemName 物品对应的KV名称
--@param #number grade 品阶
--@param #number quality 品质(1,2,....)
--@param #number score 装备战斗力
--@param #table attr 要存储的属性信息
--@param #number source 装备来源。 可引用SrvNetEquip.source_xxx，也可以是其他的来源。可以为空，为空则默认为打怪掉落
--@param #function callback 回调函数，第一个参数代表处理结果，true表示删除成功，false表示失败 
--如果成功了，第二个参数该装备的服务器id 
--如果失败了，第二个参数代表失败代码：-1=服务器未响应，0=未知错误，1=传入的参数非法，2=该位置已有其他装备，但是覆盖失败了
function m.AddEquip(PlayerID,slot,itemName,grade,quality,score,attr,source,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if aid then
		local params = CreateRequestParams(aid,1)
		
		params.src = source or m.source_drop
		params.item = itemName
		params.slot = slot
		params.quality = quality
		params.grade = grade
		params.score = score
		if type(attr) == "table" then
			params.attr = JSON.encode(attr)
		end
		SrvHttp.load("tzj_net_equip",params,function(data)
			if data then
				local item = data.result
				if item then
					local cache = GetPlayerData(PlayerID)
					cache[item.id] = FormatServerData(item)
					callback(true,item.id)
				else
					callback(false,data.error or 0)
				end
			else
				callback(false,-1)
			end
		end)
	end

end

---从服务器上销毁一个存档装备
--@param #number PlayerID 玩家id(0,1,2....)
--@param #string serverID 存档装备的服务器id
--@param #number jing 分解装备返还的晶石数量
--@param #function callback 回调函数，第一个参数代表处理结果，true表示删除成功，false表示失败 
--如果成功了，第二个参数代表玩家现在的晶石总量 
--如果失败了，第二个参数代表失败代码：-1=服务器未响应，0=未知错误，1=传入的参数非法（检查PlayerID和ServerID），2=晶石数量是负数，3=装备不存在，4=晶石增加失败
function m.DestroyEquip(PlayerID,serverID,jing,callback)
	local data = GetPlayerData(PlayerID)
	if not data or type(serverID) ~= "string" or not data[serverID] then
		callback(false,1)
		return;
	end
	
	local aid = PlayerUtil.GetAccountID(PlayerID)
	local params = CreateRequestParams(aid,2)
	params.id = serverID
	params.jing = jing
	
	PlayerUtil.LockAction(PlayerID,"destroy_net_equip",function()
		SrvHttp.load("tzj_net_equip",params,function(data)
			PlayerUtil.UnlockAction(PlayerID,"destroy_net_equip")
		
			if data then
				if data.success then
					local cache = GetPlayerData(PlayerID)
					if cache then
						cache[serverID] = nil
					end
					callback(true,data.jing)
				else
					callback(false,data.error or 0)
				end
			else
				callback(false,-1)
			end
		end)
	end)
	
	
end

---从服务器上批量销毁存档装备
--@param #number PlayerID 玩家id(0,1,2....)
--@param #table serverIDs 存档装备的服务器id组成的table，数组结构
--@param #number jing 分解装备返还的晶石数量
--@param #function callback 回调函数，第一个参数代表处理结果，true表示删除成功，false表示失败 
--如果成功了，第二个参数代表玩家现在的晶石总量 
--如果失败了，第二个参数代表失败代码：-1=服务器未响应，0=未知错误，1=传入的参数非法（检查PlayerID和ServerIDs），2=装备销毁失败（可能是装备不存在），3=晶石增加失败
function m.DestroyEquipBatch(PlayerID,serverIDs,jing,callback)
	local data = GetPlayerData(PlayerID)
	if not data or type(serverIDs) ~= "table" or #serverIDs == 0 then
		callback(false,1)
		return;
	end
	
	local items = nil
	for key, serverID in pairs(serverIDs) do
		if items then
			items = items..","..serverID
		else
			items = serverID
		end
	end
	
	local aid = PlayerUtil.GetAccountID(PlayerID)
	local params = CreateRequestParams(aid,5)
	params.items = items
	params.jing = jing
	
	PlayerUtil.LockAction(PlayerID,"destroy_net_equip",function()
		SrvHttp.load("tzj_net_equip",params,function(data)
			PlayerUtil.UnlockAction(PlayerID,"destroy_net_equip")
			if data then
				if data.success then
					local cache = GetPlayerData(PlayerID)
					if cache then
						for key, serverID in pairs(serverIDs) do
							cache[serverID] = nil
						end
					end
					callback(true,data.jing)
				else
					callback(false,data.error or 0)
				end
			else
				callback(false,-1)
			end
		end)
	end)
	
end

---更新存档装备的存储位置
--@param #number PlayerID 玩家id(0,1,2....)
--@param #string serverID 装备服务器id
--@param #number slot 新的位置（1-N）
function m.UpdateEquipPosition(PlayerID,serverID,slot)
	local data = GetPlayerData(PlayerID)
	if data[serverID] then
		data[serverID].slot = slot
	end
end

---同步装备位置至服务器，用在游戏结束的时候
function m.SyncItemPosition()
	local sendData = {}
	local aids = nil
	for PlayerID, data in pairs(playerData) do
		local aid = PlayerUtil.GetAccountID(PlayerID);
		if aids then
			aids = aids..","..aid
		else
			aids = aid
		end
		--同步所有装备的数据
		local changedItems = {}
		for id, value in pairs(data) do
			changedItems[id] = value.slot;
		end
		sendData[aid] = changedItems
	end
	
	if aids then
		local params = CreateRequestParams(aids,3)
		params.data = JSON.encode(sendData)
		--现在的逻辑不能放在游戏中定时发送，因为更新完位置以后，没有再同步缓存中的initSlot，这个时候如果是服务端更新成功，应该把initSlot改成当前的slot才对
		SrvHttp.load("tzj_net_equip",params,function(srvData)
			if not srvData or srvData.result == nil then
				m.SyncItemPosition()
			end
		end)
	end
end

---更新玩家装备的战斗力
--@param #number PlayerID 玩家id
--@param #table items 要更新的位置和新的战斗力
--结构：
--{
--	["xxxxx"] = 3000,   --serverID=score，key代表服务器上的id，value代表新的战斗力
--	...
--}
--@param #function callback 回调函数，调用参数：success,arg2 
--success=true时，arg2是一个表，代表各个装备的更新结果{serverID=itemData} 
--success=false时，arg2代表失败原因：-1=服务器未响应，100=本地调用传入的参数异常（该玩家没有存档装备或者items为空），0=未知错误，1=服务器返回的参数异常
function m.UpdateItemScore(PlayerID,items,callback)
	local cache = GetPlayerData(PlayerID)
	if not cache or TableLen(items) == 0 then
		callback(false,100)
		return;
	end
	
	local aid = PlayerUtil.GetAccountID(PlayerID)
	local params = CreateRequestParams(aid,4)
	params.items = JSON.encode(items)
	SrvHttp.load("tzj_net_equip",params,function(data)
		if data then
			local result = data.result
			if result then
				--更新一下缓存数据，可能不是全部数据
				local cache = GetPlayerData(PlayerID)
				for key, var in pairs(result) do
					cache[key] = FormatServerData(var)
				end
				callback(true,result)
			else
				callback(false,data.error or 0)
			end
		else
			callback(false,-1)
		end
	end)
	
end

---其他模块增加玩存档装备后，要更新缓存，否则最后保存位置可能出错
function m.UpdateEquipCache(PlayerID,reward)
	if PlayerID and reward then
		local data = GetPlayerData(PlayerID)
		for _, value in pairs(reward) do
			data[value.id] = FormatServerData(value)
		end
	end
end

---有些装备位置会因为网络原因导致游戏结束的时候位置同步失败，再次进入游戏的时候需要重新分配位置。 
--分配完新的位置以后，要更新他们的位置，这样才能在游戏结束后正常保存。 
--
--注意：这个操作也不是同步的，也是在游戏结束的时候才会统一进行更新。
--
--@param #number PlayerID 玩家id
--@param #string itemServerID 装备服务器ID
--@param #number slot 新的位置
function m.UpdateEmptySlot(PlayerID,itemServerID,slot)
	local data = GetPlayerData(PlayerID)
	if data[itemServerID] then
		data[itemServerID].slot = slot
	end
end


---装备强化
--@param #number PlayerID 玩家ID
--@param #string itemServerID 装备服务器ID
--@param #number score 装备新的战斗力
--@param #table attr 装备强化以后新的属性数据
--@param #string stoneName 强化石名称
--@param #number stoneCount 消耗的强化石数量
--@param #boolean success 强化是否成功
--@param #function callback 回调函数，调用参数：success,arg2,arg3
--success=true时，arg2、arg3均为nil
--success=false时，arg2代表失败原因：-1=服务器未响应，100=本地调用传入的参数异常，0=未知错误，1=服务器返回的参数异常，2=该装备在服务器上不存在，3=减少强化石数量失败（如果是数量不足，则arg3就代表实际拥有的强化石数量），4=装备数据更新失败
function m.Enhance(PlayerID,itemServerID,score,attr,stoneName,stoneCount,success,callback)
	local data = GetPlayerData(PlayerID)
	if not data[itemServerID] or type(attr) ~= "table" or type(stoneName) ~= "string" or stoneCount <= 0 then
		callback(false,100)
		return;
	end
	
	local aid = PlayerUtil.GetAccountID(PlayerID)
	local params = CreateRequestParams(aid,6)
	params.item = itemServerID
	params.score = score or 0
	params.attr = JSON.encode(attr)
	params.stone = stoneName
	params.stone_count = stoneCount
	params.success = success
	
	
	PlayerUtil.LockAction(PlayerID,"enhance_net_equip",function()
		SrvHttp.load("tzj_net_equip",params,function(data)
			PlayerUtil.UnlockAction(PlayerID,"enhance_net_equip")
			if data then
				if data.item then
					local cache = GetPlayerData(PlayerID)
					if cache and cache[itemServerID] then
						local item = cache[itemServerID]
						item.score = score
						item.attr = attr
					end
					callback(true)
				else
					callback(false,data.error or 0,data.count)
				end
			else
				callback(false,-1)
			end
		end)
	end)
	
	
end

function m.Client_SavePosition(_,keys)
	local PlayerID = keys.PlayerID
	if playerData[PlayerID] and Stage.gameFinished then
		local mark = PlayerUtil.getAttrByPlayer(PlayerID,"net_equip_save_action")
		local time = GetGameTimeWithoutPause();
		if mark and mark >= time then
			SendToClient(PlayerID,"tzj_net_equip_save_position_return",{busy=true,time=time})
			return;
		else
			time = time + 30
			PlayerUtil.setAttrByPlayer(PlayerID,"net_equip_save_action",time)
		end
	
		local sendData = {}
		local aid = PlayerUtil.GetAccountID(PlayerID);
		
		--同步所有装备的数据
		local changedItems = {}
		for id, value in pairs(playerData[PlayerID]) do
			changedItems[id] = value.slot;
		end
		sendData[aid] = changedItems
		
		local params = CreateRequestParams(aid,3)
		params.data = JSON.encode(sendData)
		SrvHttp.load("tzj_net_equip",params,function(srvData)
			if not srvData or srvData.result == nil then
				SendToClient(PlayerID,"tzj_net_equip_save_position_return",{success=false,time=time})
			else
				SendToClient(PlayerID,"tzj_net_equip_save_position_return",{success=true,time=time})
			end
		end)
	else
		SendToClient(PlayerID,"tzj_net_equip_save_position_return",{success=false})
	end
end

CustomGameEventManager:RegisterListener("tzj_net_equip_save_position",m.Client_SavePosition)
return m;