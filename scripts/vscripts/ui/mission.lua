_G.RenWu={
	getgold={
		{
			level=1,
			condition=1000,
		},
		{
			level=2,
			condition=20000,
		},
		{
			level=3,
			condition=40000,
		},
		{
			level=4,
			condition=80000,
		},
		{
			level=5,
			condition=200000,
		},
	},
	costgold={
		{
			level=1,
			condition=1000,
		},
		{
			level=2,
			condition=20000,
		},
		{
			level=3,
			condition=40000,
		},
		{
			level=4,
			condition=80000,
		},
		{
			level=5,
			condition=200000,
		},
	},
	killmonster={
		{
			level=1,
			condition=10,
		},
		{
			level=2,
			condition=60,
		},
		{
			level=3,
			condition=100,
		},
		{
			level=4,
			condition=250,
		},
		{
			level=5,
			condition=500,
		},
	},
--	deathtime={		--暂时去掉死亡次数的任务
	--	{
---			level=1,
---			condition=1,
--		},
---		{
	--		level=2,
---			condition=3,
--		},
--		{
--			level=3,
--			condition=5,
--		},
--		{
--			level=4,
--			condition=10,
--		},
--		{
--			level=5,
--			condition=20,
--		},
--	},
	bosspoint={
		{
			level=1,
			condition=1,
		},
		{
			level=2,
			condition=10,
		},
		{
			level=3,
			condition=20,
		},
		{
			level=4,
			condition=50,
		},
		{
			level=5,
			condition=100,
		},
	},
	usestonetime={
		{
			level=1,
			condition=1,
		},
		{
			level=2,
			condition=10,
		},
		{
			level=3,
			condition=20,
		},
		{
			level=4,
			condition=40,
		},
		{
			level=5,
			condition=100,
		},
	}
}
if MisSion == nil then
	MisSion = {}
	
end
--state 0:未完成任务 1:结束任务（时间到自动结束）2：已发放奖励
--now_condition:当前数量
--misstype 任务类型，可以根据任务类型找到对应的文字描述
--rest_time 任务剩余时间
--level 当前任务奖励等级
--next_time 距离下次任务刷新还有多久，一次任务时间结束后才会有值
--first 是否是第一次任务。只有第一次任务有值
function MisSion:SetMisson(iPlayerID)
	local misstypetable={}
	for k,v in pairs(RenWu) do
		table.insert(misstypetable,k)
	end
	local misstype=misstypetable[RandomInt(1,#misstypetable)] --随机任务类型
	local Misson={}
	Misson['misstype']=misstype
	Misson['state']=0
	Misson['level']=0
	Misson['now_condition']=0
	Misson['rest_time']= 120--120  --两分钟时间限制
	--判断是否是第一次任务
	local missions = MisSion.PlayerMisson[iPlayerID];
	if missions and missions[1].state == nil then
		Misson.first = true;
	end
	MisSion.PlayerMisson[iPlayerID]= {Misson} --同时只会存在一个任务
end

function MisSion:Init()
	ListenToGameEvent( "entity_killed",Dynamic_Wrap(  MisSion,"OnKilled"), self )
	CustomNetTables:SetTableValue( "player_misson", "player_misson", RenWu )
end
--初始化任务 每3分钟添加一个新任务 2分钟任务限制
function MisSion:InitMission(firstDelay)
	
	MisSion.PlayerMisson={}
	EachPlayer(function(n, iPlayerID)
		MisSion.PlayerMisson[iPlayerID]={{next_time=firstDelay}}
	end)
	
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("MisSionTime"), function()
		if Stage.gameFinished then
			return
		end
	
		if not GameRules:IsGamePaused() then
			EachPlayer(function(n, iPlayerID)
				local mission = MisSion.PlayerMisson[iPlayerID][1];
				if mission.state and mission.state == 0 then
					if mission.rest_time == 0 then
						mission.state = 1 --时间到了，任务结束
						mission.next_time= 60 --两次任务间隔60秒
						MisSion:checkstate(iPlayerID)
					else
						mission.rest_time = mission.rest_time - 1
					end
				end
				
				if mission.next_time then
					--发布新任务
					if mission.next_time == 0 then
						MisSion:SetMisson(iPlayerID)
					else
						mission.next_time = mission.next_time - 1
					end
				end
								
				MisSion:setnettabledata(iPlayerID)  --每秒刷新一次数据数据表
			end)
		end
		return 1
	end,1)
end
--增加命运石次数，会自动更新任务信息的
--playerid 玩家id
function MisSion:SetStone(playerid,stone)
	if Stage.gameFinished then
		return
	end
	
	if MisSion.PlayerMisson and MisSion.PlayerMisson[playerid] then
		for k,v in pairs(MisSion.PlayerMisson[playerid]) do
			if v['misstype']=='usestonetime' and  v['state']==0 then
				v['now_condition']=v['now_condition']+stone
				MisSion:checkstate(playerid)
			end
		end
	end
end
--增加BOSS点数，会自动更新任务信息的
--playerid 玩家id
function MisSion:SetBossPoint(playerid,point)
	if Stage.gameFinished then
		return
	end
	
	Shopmall:FinishQuest(playerid,"hero_getboss_1",point)
	if MisSion.PlayerMisson and MisSion.PlayerMisson[playerid] then
		for k,v in pairs(MisSion.PlayerMisson[playerid]) do
			if v['misstype']=='bosspoint' and  v['state']==0 then
				v['now_condition']=v['now_condition']+point
				MisSion:checkstate(playerid)
			end
		end
	end
	
end
--增加金币，会自动更新任务信息的
--playerid 玩家id
function MisSion:SetGetGold(playerid,gold)
	if Stage.gameFinished then
		return
	end
	
	if MisSion.PlayerMisson and MisSion.PlayerMisson[playerid] then
		for k,v in pairs(MisSion.PlayerMisson[playerid]) do
			if v['misstype']=='getgold' and  v['state']==0 then
				v['now_condition']=v['now_condition']+gold
				MisSion:checkstate(playerid)
			end
		end
	end
end
--花销，会自动更新任务信息的
--playerid 玩家id
function MisSion:SetCostGold(playerid,gold)
	if Stage.gameFinished then
		return
	end

	if MisSion.PlayerMisson and MisSion.PlayerMisson[playerid] then
		for k,v in pairs(MisSion.PlayerMisson[playerid]) do
			if v['misstype']=='costgold' and  v['state']==0 then
				v['now_condition']=v['now_condition']+gold
				MisSion:checkstate(playerid)
			end
		end
	end
end

function MisSion:OnKilled(keys)
	if Stage.gameFinished then
		return
	end

	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	local playerid=killerEntity:GetPlayerOwnerID()
	if playerid ~=-1 and killedUnit~= killerEntity  then 
		Shopmall:FinishQuest(playerid,"hero_killunit_1",1)---完成通行证击杀小怪数量
		if killedUnit:GetUnitName()=="npc_boss_06" then
			Shopmall:FinishQuestBatch("hero_killboss_1",1,1)
		end
		if killedUnit:GetUnitName()=="npc_boss_03" then
			Shopmall:FinishQuestBatch("hero_killboss_2",1,1)
		end
		if killedUnit:GetUnitName()=="npc_dota_endboss_02" then
			Shopmall:FinishQuestBatch("hero_killboss_3",1,1)
		end
		if killedUnit:GetUnitName()=="npc_boss_04" then
			Shopmall:FinishQuestBatch("hero_killboss_4",1,1)
		end
		if killedUnit:GetUnitName()=="npc_boss_05" then
			Shopmall:FinishQuestBatch("hero_killboss_5",1,1)
		end
		if killedUnit:GetUnitName()=="npc_boss_02" then
			Shopmall:FinishQuestBatch("hero_killboss_6",1,1)
		end
		if MisSion.PlayerMisson and MisSion.PlayerMisson[playerid] then
			for k,v in pairs(MisSion.PlayerMisson[playerid]) do
				if v['misstype']=='killmonster' and  v['state']==0 then
					v['now_condition']=v['now_condition']+1
					MisSion:checkstate(playerid)
				end
			end
		end
	end
	if killedUnit:IsRealHero() then
		local playerid=killedUnit:GetPlayerID()
		if MisSion.PlayerMisson and MisSion.PlayerMisson[playerid] then
			for k,v in pairs(MisSion.PlayerMisson[playerid]) do
				if v['misstype']=='deathtime' and  v['state']==0 then
					v['now_condition']=v['now_condition']+1
					MisSion:checkstate(playerid)
				end
			end
		end
	end
end
function MisSion:checkstate(playerid)
	if Stage.gameFinished then
		return
	end
	
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( playerid )
	for k,v in pairs(MisSion.PlayerMisson[playerid]) do
		if v['state']==1  then
			v['state']=2
			local reward=RandomInt(1,3)
			local wave=Stage.wave --多少波怪
			if v['level']>0 then ---0级无奖励
				if reward==1 then
					v['reward']="Attributes"
					local rewardValue = 0;
					if v['level']==1 then
						rewardValue=RandomInt(20,40)*(0.5+ wave*0.5) 
					elseif v['level']==2 then
						rewardValue=RandomInt(20,40)*(0.5+ wave*0.5)*1.4 
					elseif v['level']==3 then
						rewardValue=RandomInt(20,40)*(0.5+ wave*0.5)*1.8 
					elseif v['level']==4 then
						rewardValue=RandomInt(20,40)*(0.5+ wave*0.5)*2.2
					elseif v['level']==5 then
						rewardValue=RandomInt(20,40)*(0.5+ wave*0.5)*3
					end
					
					rewardValue = math.ceil(rewardValue) * 2--(属性奖励翻倍，貌似有点低)
					v["reward_value"] = rewardValue;
					
					hPlayerHero:GetPrimaryAttribute()
					if hPlayerHero:GetPrimaryAttribute()==2 then
						hPlayerHero:ModifyIntellect(rewardValue)
					end
					if hPlayerHero:GetPrimaryAttribute()==0 then
						hPlayerHero:ModifyStrength(rewardValue)
					end
					if hPlayerHero:GetPrimaryAttribute()==1 then
						hPlayerHero:ModifyAgility(rewardValue)
					end
					NotifyUtil.ShowSysMsg2(playerid,"randomquest_1",{value=rewardValue})
				end
				if reward==2 then
					v['reward']="gold"
					local rewardValue = 0;
					if v['level']==1 then
						rewardValue=RandomInt(ma.gold[wave]*10,ma.gold[wave]*20)*(0.5+wave*0.5)
					elseif v['level']==2 then
						rewardValue=RandomInt(ma.gold[wave]*10,ma.gold[wave]*20)*(0.5+wave*0.5)*1.4
					elseif v['level']==3 then
						rewardValue=RandomInt(ma.gold[wave]*10,ma.gold[wave]*20)*(0.5+wave*0.5)*1.8
					elseif v['level']==4 then
						rewardValue=RandomInt(ma.gold[wave]*10,ma.gold[wave]*20)*(0.5+wave*0.5)*2.2
					elseif v['level']==5 then
						rewardValue=RandomInt(ma.gold[wave]*10,ma.gold[wave]*20)*(0.5+wave*0.5)*3
					end
					
					rewardValue = math.ceil(rewardValue)
					v["reward_value"] = rewardValue;
					NotifyUtil.ShowSysMsg2(playerid,"randomquest_2",{value=rewardValue})
					PlayerUtil.ModifyGold(hPlayerHero,rewardValue)
				end
				if reward==3 then
					v['reward']="item"
					local item = itemgive(playerid,v.level,1)
					if (item) then
						v.reward_value = item:entindex();
					end
					NotifyUtil.ShowSysMsg2(playerid,"randomquest_3",{value="DOTA_Tooltip_ability_"..item:GetAbilityName()})
				end
				----获得宝物
				local random_treasure=0
				local cs = 1
				if v.first then
					random_treasure=100   --第一个任务100%概率给宝物
				elseif  v['level']==1 then
					random_treasure=30
				elseif v['level']==2  then
					random_treasure=50
				elseif v['level']==3   then
					random_treasure=70
				elseif v['level']==4   then
					random_treasure=100
				elseif v['level']==5  then
					cs = 2
					random_treasure=100
				end		
--				v['treasure_value']=""
				for i=1,cs do
					if RollPercentage(random_treasure) then
					v['treasure_value']= 1
					local item = CreateItem("item_bw_1", hPlayerHero, hPlayerHero)
					hPlayerHero:AddItem(item)	
					end
				end
				NotifyUtil.ShowSysMsg2(playerid,"randomquest_4",{value=cs})
			end
		else
			local endconditio=0
			local conditionLevel = RenWu[v["misstype"]]
			if conditionLevel then
				for i,j in pairs(conditionLevel) do
					if v['now_condition']>=j['condition'] and v['now_condition']>= endconditio then
						endconditio=j['condition']
						v['level']=j['level']
					end
				end
			end
			
		end
	end
	
end
function MisSion:setnettabledata(iPlayerID)
	CustomNetTables:SetTableValue( "player_misson", "player_misson_"..iPlayerID,MisSion.PlayerMisson[iPlayerID])
end
MisSion:Init()