---主要用来存储一些玩家的个性化数据。
--比如本局使用了某个宠物，下一局开局直接使用之类的。
--比如玩家进行了某些设置，下次要自动套用之类的
--或者其他任何不需要特殊处理的kv值
local m = {}

local data = {}

local inited = false;

function m.Init(serverData)
	if serverData then
		local players = PlayerUtil.GetAllPlayersID(false,true)
		for _, PlayerID in pairs(players) do
			local aid = PlayerUtil.GetAccountID(PlayerID)
			data[PlayerID] = serverData[aid]
		end
	end
	
	inited = true;
end

---个性化数据是否初试完完毕
function m.HasInited()
	return inited
end

---获得某玩家的个性化数据
--@param #number PlayerID 玩家id
--@param #string key 
function m.GetData(PlayerID,key)
	if not inited then
		return;
	end
	local pd = data[PlayerID]
	return pd and pd[key]
end

---保存某玩家的个性化数据
--@param #number PlayerID 玩家id
--@param #string key 数据的key，使用的时候注意检查一下是否和其他模块冲突了。冲突了会被覆盖掉
--@param #any value 任意值，空值就清空
function m.SetData(PlayerID,key,value)
	if not inited then
		return;
	end
	if PlayerID and type(key) == "string" then
		local pd = data[PlayerID]
		if not pd then
			pd = {}
			data[PlayerID]=pd
		end
		pd[key] = value
	end
end

function m.ToServer()
	local toServer = {}
	for PlayerID, var in pairs(data) do
		local aid = PlayerUtil.GetAccountID(PlayerID)
		if aid then
			toServer[aid] = var
		end
	end
	return toServer
end

return m