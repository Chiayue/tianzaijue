local m = {}
---记录各个boss的击杀数据，在游戏结束的时候使用
--key是boss的unitName
--value={
--	idx = 1, --第几个boss
--	hero = "xxxx" --对应的英雄名字，用来显示小头像
--	spawn = 121.11 --刷新的游戏时间GameRules:GetGameTime()
--	die = 121.11 --死亡的游戏时间GameRules:GetGameTime()
--	dps = {} --dps数据（各个玩家的总伤害，未排序的）
--	
--}
local allBossData = {}

local SortData = function(data,time)
	local netData = {}
	local totalValue = 0
	for pid, value in pairs(data) do
		totalValue = totalValue + value
		if type(time) == "number" and time > 0 then
			value = math.modf(value / time)
		end
		table.insert(netData,{pid=pid,value=value})
	end
	
	--排序，降序排列
	table.sort(netData,function(v1,v2)
		return v2.value < v1.value
	end)
	
	return netData,totalValue
end

---伤害排序，并同步至客户端
local SyncDPS = function(prefix,bossIndex,data,time)
	if data and bossIndex then
		local netData = SortData(data,time)
		
		--战斗总时长发过去。
		if type(time) == "number" then
			netData.time = time;
		end
		
		SetNetTableValue("PlayerInfo",prefix.."_"..tostring(bossIndex),netData)
	end
end

local ClearDPSAfterDeath = function(prefix,bossIndex)
	--先通知客户端单位已经死亡，延迟一段时间再清空。
	SetNetTableValue("PlayerInfo",prefix.."_"..tostring(bossIndex),{died=1})
	TimerUtil.createTimerWithDelay(3,function()
		SetNetTableValue("PlayerInfo",prefix.."_"..tostring(bossIndex),nil)
	end)
end


---dps定时同步，不实时同步了
local CreateDpsTimer = function(boss)
	boss._dps_timer = 0;
	
	TimerUtil.CreateTimerWithEntity(boss,function()
		--非空判定，死亡了也继续同步一会（不确定死亡了这个contextThink是否还生效，待验证）
		if EntityNotNull(boss) then
			local bossIndex = boss:entindex()
			--死亡后最后再同步一次数据
			if not boss:IsAlive() then
				if boss._dps_timer_died then
					ClearDPSAfterDeath("PlayerDPS",bossIndex)
					ClearDPSAfterDeath("PlayerDPSTotal",bossIndex)
					return;
				else
					boss._dps_timer_died = true;
				end
			end
			
			local data = allBossData[boss:GetUnitName()]
			if data and data.dps then
				SyncDPS("PlayerDPS",bossIndex,data.dps,boss._dps_timer)
				SyncDPS("PlayerDPSTotal",bossIndex,data.dps)
			end
			
			boss._dps_timer = boss._dps_timer + 1
			return 1;
		end
	end)
end

---伤害统计，在第一次受到伤害的时候开始统计，所以秒伤的时间是从第一次受伤到单位死亡。 如果期间脱战了，则仍然会计算时间
function m.DamageStatistic(attacker,boss,damage)
	if attacker and boss then
		local pid = PlayerUtil.GetOwnerID(attacker)
		local data = allBossData[boss:GetUnitName()]
		if pid >= 0 and data then
			if not data.dps then
				data.dps = {}
			end
			local bossData = data.dps
			
			bossData[pid] = (bossData[pid] or 0) + damage
			
			if not boss._dps_timer then
				CreateDpsTimer(boss)
			end
		end
	end
end

---对伤害进行排序，并计算百分比
function m.SortDPSWithPercent(dpsData)
	if dpsData then
		local dpsSort,totalValue = SortData(dpsData)
		
		if totalValue > 0 then
			if #dpsSort == 1 then
				dpsSort[1].percent = "100%"
			else
				for rank, var in ipairs(dpsSort) do
					var.percent = NumberRound(var.value / totalValue * 100).."%"
				end
			end
		end
		return dpsSort
	end
end

---灾厄领主单位被击杀后记录死亡时间和总伤害数据（排序后的）。
--会返回数据供客户端的boss进度界面显示
function m.BossDie(boss)
	if boss and allBossData[boss:GetUnitName()] then
		local data = allBossData[boss:GetUnitName()];
		data.die = GameRules:GetGameTime()
		local sortData = m.SortDPSWithPercent(data.dps)
		
		return {num=data.idx,totalTime = math.floor(data.die - data.spawn),sortData = sortData}
	end
end

function m.BossSpawn(boss,idx)
	if boss then
		local name = boss:GetUnitName();
		
		allBossData[name] = {
			idx = idx,
			hero = boss:GetUnitLabel(),
			spawn = GameRules:GetGameTime()
		}
	end
end

---获得各个已刷新boss的数据，boss名称，对应英雄，第几个刷新的，刷新、死亡时间（没死就没有），各个玩家的总伤害
function m.GetBossData()
	return allBossData
end

return m