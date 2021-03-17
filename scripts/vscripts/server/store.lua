local m = {}

---商品名称：晶石。用于其他逻辑中增加晶石时使用。
m.NAME_JING = "jing_stone";
---商品名称：PLUS，由于有多种有效期的plus，定义这个唯一名字以进行时间累计
m.NAME_PLUS = "plus";

local formatPLUS = function(itemData)
	--直接购买永久卡（没有购买过其他周期）的时候，失效时间是空的，为了统一外部处理逻辑，这里处理成-1
	if itemData and not itemData.invalid_time then
		itemData.invalid_time = "-1"
	end
end

local fixStackData = function(itemName,data,allData)
	if itemName == "plus" then
		local days = data.stack
		local addData = nil
		--将有效期累计一下，但是本局并不会生效，一切顺利的话，下一局生效
		if (not allData[itemName] or allData[itemName].invalid_time ~= "-1") and days then
			addData = {item=itemName,valid=days}
		end
		return itemName,addData
	elseif Shopmall:IsUnique(itemName) then
		local addData = nil
		if not allData[itemName] then
			addData = {item=itemName}
		end
		return itemName,addData
	end
end

function m.InitPlayerData(storeData,magicStone)
	local unique = storeData and storeData.unique or {}
	local stackable = storeData and storeData.stack or {}
	local currency = storeData and storeData.currency or {}

	
	local updateData = {}
	
	local players = PlayerUtil.GetAllPlayersID(false,true)
	for _, PlayerID in pairs(players) do
		local aid = PlayerUtil.GetAccountID(PlayerID)
		
		--itemName = {got_time,invalid_time,stack}
		local itemData = {}
		
		if unique[aid] then
			for itemName, data in pairs(unique[aid]) do
				--data:{got_time="2020-01-01 15:15:15",invalid_time="2020-01-01 15:15:15",stack=123/nil}
				if itemName == m.NAME_PLUS then
					formatPLUS(data)
				end
				itemData[itemName] = data
			end
		end
		
		if stackable[aid] then
			for itemName, data in pairs(stackable[aid]) do
				local fixed,add = fixStackData(itemName,data,itemData)
				if fixed then
					local fixPlayer = updateData[aid]
					if not fixPlayer then
						fixPlayer = {}
						updateData[aid] = fixPlayer
					end
					
					local remove = fixPlayer.remove
					if not remove then
						remove = {}
						fixPlayer.remove = remove
					end
					table.insert(remove,fixed)
					
					if add then
						local addData = fixPlayer.add
						if not addData then
							addData = {}
							fixPlayer.add = addData
						end
						
						table.insert(addData,add)
						
						--清空stack放入记录，保证本局有数据，虽然数据不准确，但是先有用再说。下局进入就时间就准确了
						if not itemData[itemName] then
							data.stack = nil
							itemData[itemName] = data
						end
					end
				else
					itemData[itemName] = data
				end
			end
		end
		
		--{jing=123,ms=123,tokens = {event=123}}
		local currencyData = {jing=0,ms=0}
		local p_currency = currency[aid]
		if p_currency then
			currencyData.jing = p_currency.jing or 0
			currencyData.tokens = p_currency.tokens or nil
		end
		if magicStone then
			currencyData.ms = magicStone[aid] or 0
		end
		
		Shopmall:SetPlayerdata(PlayerID,{item=itemData,currency=currencyData})
	end
	
	if TableNotEmpty(updateData) then
		SrvHttp.load("tzj_store",{mode=6,data=JSON.encode(updateData)})
	end
end

-----购买商品
----@param #number PlayerID 玩家id
----@param #string itemName 商品名称
----@param #number price 商品价格
----@param #number currency 货币类型：1=仙石，2=晶石
----@param #number validDays 有效天数，可为空，不为空的话则必须大于0
----@param #number count 购买的数量，可为空。如果不为空，则认为是消耗品，此时必须大于0
----@param #function callback 服务器响应后的回调函数，不可为空。
---- 不同状态下，调用callback的时候会传入不同的参数：
---- 购买成功，会传入三个参数：success(boolean)，item（table:{got_time,invalid_time,stack}，该物品最新数据）,money（对应货币的余额）
---- 购买失败，会传入三个参数：success(boolean)，errorCode(number，错误代码，1=扣款失败，2=未知错误),money（number，对应货币的余额，仅当错误代码是1的时候返回）
--function m.BuyItem(PlayerID,itemName,price,currency,validDays,count,callback)
--	local aid = PlayerUtil.GetAccountID(PlayerID)
--	if aid and itemName and type(callback) == "function" then
--		if price < 0 
--			or (currency ~= 1 and currency ~= 2)
--			or (validDays and validDays < 0)
--			or (count and count < 0) then
--			DebugPrint("[Store.BuyItem] params invalid")
--			return;
--		end
--		
--		local params = {};
--		params.mode = 1
--		params.aid = aid;
--		params.item = itemName;
--		params.price = price;
--		params.currency = currency
--		params.valid = validDays
--		if count then
--			params.consumable = 1
--			params.stack = count
--		end
--		
--		PlayerUtil.LockAction(PlayerID,"store_buy",function()
--			SrvHttp.load("tzj_store",params,function(srv_data)
--				--先清空掉锁，避免后面出错了清空不掉
--				PlayerUtil.UnlockAction(PlayerID,"store_buy")
--				
--				if srv_data then
--					if srv_data.error then
--						local money = nil
--						local error = 2
--						if srv_data.error == "2" then
--							money = srv_data.money
--							error = 1
--						end
--						callback(false,error,money)
--					else
--						callback(true,srv_data[itemName],srv_data.money)
--					end
--				else
--					callback(false,2)
--					DebugPrint("[Store.BuyItem] Server response nothing");
--				end
--			
--			end)
--		end)
--	else
--		DebugPrint("[Store.BuyItem] params invalid")
--	end
--end

---购买唯一性道具
--@param #number PlayerID 玩家id
--@param #string itemName 商品名称
--@param #number price 商品价格
--@param #number currency 货币类型：1=仙石，2=晶石
--@param #table reward 附赠商品信息，数组 {
--	{item="xxxxxx",count=nil/123,valid=nil/123},
--	{...},
--	...
--}
--@param #function callback 服务器响应后的回调函数，不可为空。
-- 不同状态下，调用callback的时候会传入不同的参数：
-- 购买成功，会传入三个参数：success(boolean)，item（table:{got_time,invalid_time,stack}，该物品最新数据）,money（对应货币的余额），reward（一个表，对应附赠商品信息）
-- 购买失败，会传入三个参数：success(boolean)，errorCode(number，错误代码，1=扣款失败，2=未知错误),money（number，对应货币的余额，仅当错误代码是1的时候返回）
function m.BuyUniqueItem(PlayerID,itemName,price,currency,reward,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if aid and itemName and type(callback) == "function" and price >= 0 and (currency == 1 or currency == 2) then
		local params = {};
		params.mode = 1
		params.aid = aid;
		params.item = itemName;
		params.price = price;
		params.currency = currency
		if type(reward) == "table" then
			params.reward = JSON.encode(reward)
		end
		
		PlayerUtil.LockAction(PlayerID,"store_buy",function()
			SrvHttp.load("tzj_store",params,function(srv_data)
				--先清空掉锁，避免后面出错了清空不掉
				PlayerUtil.UnlockAction(PlayerID,"store_buy")
				
				if srv_data then
					if srv_data.error then
						local money = nil
						local error = 2
						if srv_data.error == "2" then
							money = srv_data.money
							error = 1
						end
						callback(false,error,money)
					else
						callback(true,srv_data[itemName],srv_data.money,srv_data.reward)
					end
				else
					callback(false,2)
				end
			
			end)
		end)
	else
		callback(false,0)
	end
end

---购买可重复获得道具
--@param #number PlayerID 玩家id
--@param #string itemName 商品名称
--@param #number price 商品价格
--@param #number currency 货币类型：1=仙石，2=晶石
--@param #number count 购买的数量，可为空。如果不为空，则认为是消耗品，此时必须大于0
--@param #function callback 服务器响应后的回调函数，不可为空。
-- 不同状态下，调用callback的时候会传入不同的参数：
-- 购买成功，会传入三个参数：success(boolean)，item（table:{got_time,invalid_time,stack}，该物品最新数据）,money（对应货币的余额）
-- 购买失败，会传入三个参数：success(boolean)，errorCode(number，错误代码，1=扣款失败，2=未知错误),money（number，对应货币的余额，仅当错误代码是1的时候返回）
function m.BuyStackableItem(PlayerID,itemName,price,currency,count,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if aid and itemName and price >= 0 and (currency == 1 or currency == 2) and (count == nil or count > 0) then
		local params = {};
		params.mode = 1
		params.aid = aid;
		params.item = itemName;
		params.price = price;
		params.currency = currency
		
		params.consumable = 1
		params.stack = count or 1
		
		PlayerUtil.LockAction(PlayerID,"store_buy",function()
			SrvHttp.load("tzj_store",params,function(srv_data)
				--先清空掉锁，避免后面出错了清空不掉
				PlayerUtil.UnlockAction(PlayerID,"store_buy")
				
				if srv_data then
					if srv_data.error then
						local money = nil
						local error = 2
						if srv_data.error == "2" then
							money = srv_data.money
							error = 1
						end
						callback(false,error,money)
					else
						callback(true,srv_data[itemName],srv_data.money)
					end
				else
					callback(false,2)
				end
			
			end)
		end)
	else
		callback(false,0)
	end
end


---购买plus
--@param #number PlayerID 玩家id
--@param #number price 商品价格
--@param #number validDays 有效天数，不可为空。 要么为-1，代表永久生效；要么为正数，代表延长天数
--@param #table reward 附赠商品信息，数组 {
--	{item="xxxxxx",count=nil/123,valid=nil/123},
--	{...},
--	...
--}
--@param #function callback 服务器响应后的回调函数，不可为空。
-- 不同状态下，调用callback的时候会传入不同的参数：
-- 购买成功，会传入三个参数：success(boolean)，item（table:{got_time,invalid_time,stack}，该物品最新数据）,money（对应货币的余额），reward（一个表，对应附赠商品信息）
-- 购买失败，会传入三个参数：success(boolean)，errorCode(number，错误代码，1=扣款失败，2=未知错误),money（number，对应货币的余额，仅当错误代码是1的时候返回）
function m.BuyPlus(PlayerID,price,validDays,reward,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if aid and type(callback) == "function" and price >= 0 and validDays and (validDays == -1 or validDays > 0) then
		local params = {};
		params.mode = 1
		params.aid = aid;
		params.item = m.NAME_PLUS;
		params.price = price;
		params.currency = 1
		params.valid = validDays
		if type(reward) == "table" then
			params.reward = JSON.encode(reward)
		end
		
		PlayerUtil.LockAction(PlayerID,"store_buy",function()
			SrvHttp.load("tzj_store",params,function(srv_data)
				--先清空掉锁，避免后面出错了清空不掉
				PlayerUtil.UnlockAction(PlayerID,"store_buy")
				
				if srv_data then
					if srv_data.error then
						local money = nil
						local error = 2
						if srv_data.error == "2" then
							money = srv_data.money
							error = 1
						end
						callback(false,error,money)
					else
						local itemData = srv_data[m.NAME_PLUS];
						formatPLUS(itemData)
						callback(true,itemData,srv_data.money,srv_data.reward)
					end
				else
					callback(false,2)
				end
			end)
		end)
	else
		callback(false,0)
	end
end

---购买通行证
--@param #number PlayerID 玩家id
--@param #number price 商品价格
--@param #number rewardExp 奖励通行证经验
--@param #function callback 服务器响应后的回调函数，不可为空。
-- 不同状态下，调用callback的时候会传入不同的参数：
-- 购买成功，传入以下参数：success(true)，item（table:{got_time,invalid_time,stack}，该物品最新数据）,money（对应货币的余额），battlePass(table)
-- 购买失败，传入以下参数：success(false)，errorCode(number，错误代码),money（number，对应货币的余额，仅当错误代码是3的时候返回）
-- 失败错误代码errorCode：0=未知错误，1=赛季不符（进游戏时的赛季和当前赛季不一致或当前处于赛季间歇期），2=（赛季最后一天不可购买通行证），3=扣款失败
function m.BuyBattlePass(PlayerID,price,rewardExp,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if aid and type(callback) == "function" and price >= 0 then
		local season = SrvBattlePass.GetSeason();
		if not season then
			callback(false,1)
			return;
		end
		
		if not SrvBattlePass.IsBPPurchasble() then
			callback(false,2)
			return;
		end
		
		local params = {};
		params.mode = 5
		params.aid = aid;
		params.season = season
		params.price = price;
		params.exp = rewardExp
		PlayerUtil.LockAction(PlayerID,"store_buy",function()
			SrvHttp.load("tzj_store",params,function(srv_data)
				--先清空掉锁，避免后面出错了清空不掉
				PlayerUtil.UnlockAction(PlayerID,"store_buy")
				
				if srv_data then
					if srv_data.error then
						local money = nil
						local error = 0
						if srv_data.error == "2" then
							error = 1
						elseif srv_data.error == "3" then
							error = 2
						elseif srv_data.error == "4" then
							error = 3
							money = srv_data.money
						end
						callback(false,error,money)
					else
						callback(true,srv_data.item,srv_data.money,srv_data.bp)
					end
				else
					callback(false,2)
					DebugPrint("[Store.BuyItem] Server response nothing");
				end
			
			end)
			
		end)
	else
		DebugPrint("[Store.BuyItem] params invalid")
	end
end



---消耗商品
--@param #number PlayerID 玩家id
--@param #string itemName 商品名称
--@param #number count 要消耗的数量（正数），可为nil，为空则默认为1
--@param #table reward 奖励信息，可为nil。如果消耗了A物品需要奖励B物品，则需要传入这个值。没有的话就传nil。结构：
--{ --整个表是一个数组结构的，每一个元素代表一个奖励的道具。  道具类型目前支持：1=商城道具，2=存档装备
--	{type=1,name="xxxxx",count=123,valid=123} --商城道具的格式，type=1代表这是一个商城道具。name、count、valid和商城直接增加道具时（Store.AddItem）的要求一致
--	{type=2,slot,itemName,grade,quality,score,attr,source} --存档装备格式，type=2代表存档装备，其他属性和NetEquip.AddItem要求一致
--	...
--}
--@param #function callback 回调函数，服务器处理结束后调用。调用时会传入两个参数：success,item。 
-- success(boolean)代表处理是否成功，item(table:{got_time,invalid_time,stack})代表该物品的最新数据（只有处理成功的情况下才有）
function m.ConsumeItem(PlayerID,itemName,count,reward,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if aid and itemName and type(callback) == "function" then
		local params = {};
		params.mode = 2
		params.aid = aid;
		params.item = itemName;
		params.stack = count or 1
		if reward then
			params.reward = JSON.encode(reward)
		end
		PlayerUtil.LockAction(PlayerID,"store_consume",function()
			SrvHttp.load("tzj_store",params,function(srv_data)
				--先清空掉锁，避免后面出错了清空不掉
				PlayerUtil.UnlockAction(PlayerID,"store_consume")
				
				if srv_data then
					if srv_data[itemName] then
						callback(true,srv_data[itemName],srv_data.reward_result)
					else
						callback(false)
						DebugPrint("[Store.ConsumeItem] Server response error:",srv_data.error);
					end
				else
					callback(false)
					DebugPrint("[Store.ConsumeItem] Server response nothing");
				end
				
			end)
		end)
	else
		DebugPrint("[Store.ConsumeItem] params invalid")
	end
end

---直接添加商城道具
--@param #number PlayerID 玩家id
--@param #string itemName 商品名称
--@param #number validDays 有效天数，可为空或者<=0代表永久生效，大于0代表实际生效的天数 
--@param #number count 新增的数量，可为空。如果不为空，则认为是消耗品，此时必须大于0
--@param #function callback 服务器响应后的回调函数，不可为空。调用时会传入两个参数：success,item。 
-- success(boolean)代表处理是否成功，item(table:{got_time,invalid_time,stack})代表该物品的最新数据（只有处理成功的情况下才有）
function m.AddItem(PlayerID,itemName,validDays,count,callback,isGameFinishReward)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if aid and itemName and type(callback) == "function" then
		if count and not IsPositiveNum(count) then
			callback(false, "param [count] is invalid, it must be a positive number")
			return;
		end
		
		if not validDays or validDays <= 0 then
			validDays = -1;
		end
		
		local params = {};
		params.mode = 4
		params.aid = aid;
		params.item = itemName;
		params.valid = validDays
		if count then
			params.consumable = 1
			params.stack = count
		end
		
		PlayerUtil.LockAction(PlayerID,"store_add",function()
			if isGameFinishReward then
				--先清空掉锁，避免后面出错了清空不掉
				PlayerUtil.UnlockAction(PlayerID,"store_add")
			end
		
			SrvHttp.load("tzj_store",params,function(srv_data)
				if not isGameFinishReward then
					--先清空掉锁，避免后面出错了清空不掉
					PlayerUtil.UnlockAction(PlayerID,"store_add")
				end
			
				if srv_data then
					if srv_data[itemName] then
						callback(true,srv_data[itemName])
					else
						callback(false,srv_data.error or 0)
					end
				else
					callback(false)
				end
			end)
		end)
	else
		callback(false, "params are invalid")
	end
end

---给玩家增加晶石
--@param #number PlayerID 玩家id
--@param #number num 要增加的数量，正数
--@param #string reason 增加原因，中文描述也行
--@param #function callback 服务器响应后的回调函数，不可为空。调用时会传入两个参数：success,count。 
-- success(boolean)代表处理是否成功，count(number)代表最新的晶石数量，只有success为true的时候才有
function m.AddJing(PlayerID,num,reason,callback)
	local aid = PlayerUtil.GetAccountID(PlayerID)
	if aid and num and num > 0 and reason and type(callback) == "function" then
		local params = {};
		params.mode = 3
		params.aid = aid;
		params.num = num;
		params.reason = reason
		
		PlayerUtil.LockAction(PlayerID,"store_addJing",function()
			SrvHttp.load("tzj_store",params,function(srv_data)
				--先清空掉锁，避免后面出错了清空不掉
				PlayerUtil.UnlockAction(PlayerID,"store_addJing")
			
				if srv_data then
					if srv_data.count then
						callback(true,srv_data.count)
					else
						callback(false)
						DebugPrint("[Store.BuyItem] Server response error:",srv_data.error);
					end
				else
					callback(false)
					DebugPrint("[Store.BuyItem] Server response nothing");
				end
			end)
		end)
	else
		DebugPrint("[Store.BuyItem] params invalid")
	end
end

---判断某个商品是否永久有效的
--@param #table itemData 商品数据
function m.IsPermanent(itemData)
	return itemData and (not itemData.invalid_time or itemData.invalid_time == "-1")
end

return m;