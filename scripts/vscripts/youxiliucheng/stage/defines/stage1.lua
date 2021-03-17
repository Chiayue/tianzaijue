local m = {}
--每两拨进攻怪之间的间隔
m.playernum = 0
m.intervalWave = 8
--每波的时间
m.time = 65
m.reducetime = 0
--进攻怪物数量
m.num=80
--初始波数
m.wave = 0
--当前死了几个生存boss了
m.bossdienum = 0
--每个玩家的当前场上存在的怪物数量 存活数
m.chs = {
	chs1 = 0;
	chs2 = 0;
	chs3=0;
	chs4=0;

}
--boss倒计时
m.bosscountdown = 400
m.reducebosstime = 0
m.countdown = {
	360,
	355,
	350,

	350,
	345,
	345,
	340,

	300,
	295,
	290,
	285,
	280,
	275,
	270,

	265,--15
	263,
	261,
	259,
	257,
	255,
	253,
	250,


	238,--23
	236,
	234,
	232,
	230,
	228,
	226, --29


	216,--30
	214,
	212,
	210,
	208,
	206, --35

	204, --36
	202,
	200,
	198,
	196,
	194,--41



}
--最多刷新几个boss
m.max_boss_count = 4
m.max_boss = {
	4,
	4,
	4,


	5,
	5,
	5,
	5,

	6,
	6,
	6,
	6,
	6,
	6,
	6,

	6,--15
	6,
	6,
	6,
	6,
	6,
	6,
	6,

	6,--23
	6,
	6,
	6,
	6,
	6,
	6,

	6,--30
	6,
	6,
	6,
	6,
	6,


	6,--36
	6,
	6,
	6,
	6,
	6,--41

}
--出现第几个BOSS了
m.bossnum = 0
--玩家信息

m.playerinfo={
	
}

--每个玩家的当前场上默认的最大存活数，可能会受到其他加成
m.zdchs={
	zdchs1 = 35;
	zdchs2 = 35;
	zdchs3 = 35;
	zdchs4 = 35;
}
--怪物允许的最大存活数，由上面四个加起来。
m.maxchs = 0
m.attackboss={
	"npc_dota_endboss_02";
	"npc_boss_02";
	"npc_boss_03";
	"npc_boss_04";
	"npc_boss_05";
	"npc_boss_06";
--	"npc_boss_07";
 -- "npc_boss_08";

}
---游戏是否结束
m.gameFinished = false;

m.jygchance =1
--难度出现精英怪的概率
m.jyg={
	1,
	1,
	2,

	4,
	4,
	5,
	5,

	6,
	7,
	8,
	9,
	10,
	11,
	12,

	13,--15
	14,
	15,
	16,
	17,
	18,
	19,
	20,

	22,--23
	24,
	26,
	28,
	30,
	32,
	34,

	36,
	38,
	40,
	42,
	44,
	46,


	48,
	50,
	52,
	54,
	56,
	58




}
m.gjgchance = 5
--难度出现高级怪的概率
m.gjg={
	2,
	3,
	4,

	6,
	8,
	10,
	12,
	14,

	16,
	18,
	20,
	22,
	24,
	26,

	28,--15
	30,
	32,
	34,
	36,
	38,
	40,
	42,

	44,--23
	46,
	48,
	50,
	52,
	54,
	56,

	58,
	60,
	62,
	64,
	66,
	68,

	70,
	70,
	70,
	70,
	70,
	70,

}
--难度模式
--1  正常
--2  狂暴模式 		每波间隔时间 -30%
--3  奥术模式		所有单位的技能cd-30%
--4  灾难模式		高级怪出怪概率+100%，精英怪的出现概率+50%
--5  地狱模式		怪物的移动速度+30%，攻击速度+40，攻击力+40%
--6  赏金模式		金钱提升+100%，但是死亡会扣掉全部金币
--7  噩梦模式		每分钟给与英雄一个负面 debuff
--8  强袭模式 		BOSS数量+1

m.ndms={
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
}

--保存BOSS卡尔的召唤物
m.kezhw={}
m.player0={}
m.player1={}
m.player2={}
m.player3={}

m.yccs = 1
--所有玩家出怪的血量攻击防御系数,默认系数是1
m.xl=1
m.gj=1
m.fy=1
m.mk=1
m.jq=1
m.jy=1
--每个玩家出怪的血量攻击防御系数,默认系数是1
m.xl1=1
m.gj1=1
m.fy1=1
m.jq1=1
m.jy1=1

m.xl2=1
m.gj2=1
m.fy2=1
m.jq2=1
m.jy2=1

m.xl3=1
m.gj3=1
m.fy3=1
m.jq3=1
m.jy3=1

m.xl4=1
m.gj4=1
m.fy4=1
m.jq4=1
m.jy4=1


m.playeronline={}

m.event={
	200,
	70,
	25,
	8,
	3,
	1,

}
  m.events={
      sj1={
      	  {jqjc=10},
	      {jyjc=10},
	      {gold=10000},
	      {exp=20000},
	      {sx=100},
	      {ts={1,1}},
	      {gwqd={0.3,0.2}},
	      {gwxl={0.3,0.2}},
	      {gwgj={0.3,0.2}},
	  		},

	  sj2={
      	  {jqjc=15},
	      {jyjc=15},
	      {gold=15000},
	      {exp=30000},
	      {sx=150},
	      {ts={2,1}},
	      {gwqd={0.4,0.25}},
	      {gwxl={0.4,0.25}},
	      {gwgj={0.4,0.25}},
	  	},

	   sj3={
      	  {jqjc=20},
	      {jyjc=20},
	      {gold=20000},
	      {exp=40000},
	      {sx=200},
	      {ts={3,1}},
	      {gwqd={0.5,0.3}},
	      {gwxl={0.5,0.3}},
	      {gwgj={0.5,0.3}},
	  	},

	   sj4={
      	  {jqjc=25},
	      {jyjc=25},
	      {gold=25000},
	      {exp=50000},
	      {sx=250},
	      {ts={4,1}},
	      {bw=1},
	      {gwqd={0.6,0.35}},
	      {gwxl={0.6,0.35}},
	      {gwgj={0.6,0.35}},
	  	},

	   sj5={
      	  {jqjc=30},
	      {jyjc=30},
	      {gold=30000},
	      {exp=60000},
	      {sx=300},
	      {ts={5,1}},
	      {bw=1},
	      {gwqd={0.7,0.4}},
	      {gwxl={0.7,0.4}},
	      {gwgj={0.7,0.4}},
	  	},

	   sj6={
      	  {jqjc=35},
	      {jyjc=35},
	      {gold=35000},
	      {exp=70000},
	      {sx=350},
	      {ts={6,1}},
	      {gwqd={0.8,0.45}},
	      {gwxl={0.8,0.45}},
	      {gwgj={0.8,0.45}},
	  	},
     }


m.qhsdl={
	[5]={1,10},  --每个阶段的第一个难度不掉强化石，但是也不设置为 0，0了
	[6]={5,15},
	[7]={10,20},
	--[7]={15,25},

	[8]={1,4}, 	
	[9]={4,8},
	[10]={8,12},
	[11]={12,16},
	[12]={16,20},
	[13]={20,25},
	[14]={25,35},

	[15]={1,3}, 	
	[16]={3,6},
	[17]={6,9},
	[18]={9,13},
	[19]={13,17},
	[20]={17,22},
	[21]={22,28},
	[22]={28,40},


	[23]={1,5}, 	
	[24]={5,10},
	[25]={10,15},
	[26]={15,20},
	[27]={20,25},
	[28]={25,30},
	[29]={30,40},

	[30]={1,5}, 	
	[31]={5,10},
	[32]={10,15},
	[33]={15,20},
	[34]={20,25},
	[35]={25,40},


	[36]={1,5}, 	
	[37]={5,10},
	[38]={10,15},
	[39]={15,20},
	[40]={20,25},
	[41]={25,40},
}

m.ysdl={
	10,
	20,
	30,

	40,
	50,
	60,
	80, --n7

	100,
	120,
	140,
	160,
	180,
	200,
	250, --14

	270,--
	290,
	310,
	330,
	350,
	370,
	390,
	410, --n22

	430,--n23
	460,
	490,
	520,
	550,
	580,
	600,

	620,--30
	640,
	660,
	680,
	700,
	720,

	740,--36
	760,
	780,
	800,
	820,
	840,
}


---游戏开始
function m.Begin(EndCallback)
	
end

--游戏失败
function m.gamelose( )
	for _, PlayerID in pairs(m.playeronline) do
		m.maxchs = m.maxchs + m.zdchs["zdchs"..PlayerID+1]
	end

	local gamecounttime=5		
	TimerUtil.createTimer(function()
		if m.gameFinished then
			return;
		end
		local  nowchs = #m.kezhw 
		local yjchs = 0  --预警数量
		for _, PlayerID in pairs(m.playeronline) do
			nowchs = nowchs + m.chs["chs"..PlayerID+1]
			yjchs = m.maxchs -10
		end
			if nowchs>yjchs and nowchs<m.maxchs then
				NotifyUtil.TopUnique(nil,"#monster_warning_notice",2,"red",NotifyUtil.STYLE_BlackBack_Alpha)
				--NotifyUtil.ShowSysMsg(nil,"#monster_warning_notice")
			end
			if nowchs>=m.maxchs then
				if gamecounttime<=0 then
					m.PlayerLose();
				else
					--NotifyUtil.TopUnique(nil,"#monster_countdown_notice",8,"red",NotifyUtil.STYLE_BlackBack_Alpha,{locstring_value=gamecounttime})
					NotifyUtil.ShowGameOverHint(gamecounttime)
					NotifyUtil.ShowSysMsg2(nil,"#monster_countdown_notice"..gamecounttime,{locstring_value=gamecounttime})
				end
				gamecounttime=gamecounttime-1
			else
				gamecounttime=10
				NotifyUtil.ShowGameOverHint()
			end	

		return 1 
		
end)	
		

end


---开始刷进攻怪
--总共20波   20*100s =30分钟
function m.StartAttack()
	--开启计时
	m.wave = m.wave + 1
	if Stage.gameFinished then   --如果游戏结束或胜利，则不刷小怪
		return;
	end
	
	m.EachPlayerConfig()
	
	if m.wave <= 30 then
		local wave = m.wave 
		local num = m.num+(m.wave*3) --每多一波，怪物数量+6
		local interval = m.time / num
		shuaguai.spawnAttackEnemy(num,interval,m.wave)	--(第几波，多少只，刷怪点，刷怪间隔)		
		
		local total = m.time + m.intervalWave;
		local countdown = total;
		TimerUtil.createTimer(function()
			CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_attack_timer",{now=Stage.wave,next=countdown,total=total})
			
			if countdown == 0 then
				m.StartAttack();
			else
				countdown = countdown - 1;
				return 1;
			end
		end)
	end
end

---每个玩家每轮都要处理的逻辑
function m.EachPlayerConfig()
	for _, playerID in pairs(Stage.playeronline) do
		--添加玩家的技能书掉落点数
		if PlayerUtil.getAttrByPlayer(playerID,"jnsds") then
			local x = PlayerUtil.getAttrByPlayer(playerID,"jnsds")
			x = x + 1  --每个回合增加1点
			PlayerUtil.setAttrByPlayer(playerID,"jnsds",x)
			if m.playernum == 1 and RollPercent(33) then
				local hero= PlayerUtil.GetHero(playerID)
				local itemname = "item_xhp_wzts_"..RandomInt(2,3)
				hero:AddItemByName(itemname)
			end
		end
		
		m.RandomEvent(playerID)
	end
end

--随机事件
function m.RandomEvent(playerID)
	if m.wave % 2 == 1 then  --触发事件
		--	for iii=1,1000 do
		local weight = Weightsgetvalue_one(m.event) --看看每个玩家触发的事件
		--	if weight == 1 then
		local r = RandomInt(1,#m.events["sj"..weight])
		local eventData = m.events["sj"..weight][r]
		if not eventData then
			return;
		end
		
		for eventType, config in pairs(eventData) do
			if eventType == "jqjc" then
				local hero= PlayerUtil.GetHero(playerID)
				local unitKey = tostring(EntityHelper.getEntityIndex(hero))
				if not hero.cas_table then
					hero.cas_table = {}
				end
				local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
				netTable["jqjc"] = netTable["jqjc"] +config
				SetNetTableValue("UnitAttributes",unitKey,netTable)
				
				TimerUtil.createTimerWithDelay(120,function()
					local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
					netTable["jqjc"] = netTable["jqjc"] - config
					SetNetTableValue("UnitAttributes",unitKey,netTable)
				end)
				
				SendToClient(playerID,"tzj_wave_random_event",{event="gold_ratio",info="events1",kv={value=config},cooldown=GetGameTimeWithoutPause()+120})
			elseif eventType == "jyjc" then
				local hero= PlayerUtil.GetHero(playerID)
				local unitKey = tostring(EntityHelper.getEntityIndex(hero))
				if not hero.cas_table then
					hero.cas_table = {}
				end
				local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
				netTable["jyjc"] = netTable["jyjc"] + config
				SetNetTableValue("UnitAttributes",unitKey,netTable)
				TimerUtil.createTimerWithDelay(120,function()
					local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
					netTable["jyjc"] = netTable["jyjc"] - config
					SetNetTableValue("UnitAttributes",unitKey,netTable)
				end)
				SendToClient(playerID,"tzj_wave_random_event",{event="exp_ratio",info="events2",kv={value=config},cooldown=GetGameTimeWithoutPause()+120})
			elseif eventType == "gold" then
				local hero= PlayerUtil.GetHero(playerID)
				local gold = config *(0.5+Stage.wave/2)
				PopupNum:PopupGoldGain(hero,gold)
				PlayerUtil.ModifyGold(hero,gold)
				SendToClient(playerID,"tzj_wave_random_event",{event="gold",info="events3",kv={value=gold}})
			elseif eventType == "exp" then
				local hero= PlayerUtil.GetHero(playerID)
				local exp = config *Stage.wave
				hero:AddExperience(exp, DOTA_ModifyXP_Unspecified, false, false)
				SendToClient(playerID,"tzj_wave_random_event",{event="exp",info="events4",kv={value=exp}})
			elseif eventType == "sx" then
				local hero= PlayerUtil.GetHero(playerID)
				local sx = config *(0.5+Stage.wave/2)
				local baseStr = hero:GetBaseStrength()
				local baseAgi = hero:GetBaseAgility()
				local baseInt = hero:GetBaseIntellect()
				local addStr = baseStr + sx
				hero:SetBaseStrength(addStr)
				local addAgi = baseAgi + sx
				hero:SetBaseAgility(addAgi)
				local addInt = baseInt + sx
				hero:SetBaseIntellect(addInt)
				hero:CalculateStatBonus(true)
				
				SendToClient(playerID,"tzj_wave_random_event",{event="all_attr",info="events5",kv={value=sx}})
			elseif eventType == "ts" then
				local hero= PlayerUtil.GetHero(playerID)
				local itemname = "item_xhp_wzts_"..config[1]
				hero:AddItemByName(itemname)
				SendToClient(playerID,"tzj_wave_random_event",{event="ability",info="events6",kv={value=config[1]}})
			elseif eventType == "bw" then
				local hero= PlayerUtil.GetHero(playerID)
				local itemname = "item_bw_1"
				for i=1,config do
					hero:AddItemByName(itemname)
				end
				SendToClient(playerID,"tzj_wave_random_event",{event="treasure",info="events7",kv={value=config}})
			elseif eventType == "gwqd" then
				--触发事件后，所有人的怪物都得到加强
				m.xl=m.xl + config[1]
				m.gj=m.gj + config[1]
				m.fy=m.fy + config[1]
				m.jq=m.jq + config[2]
				m.jy=m.jy + config[2]
				TimerUtil.createTimerWithDelay(120,function()
					m.xl=m.xl - config[1]
					m.gj=m.gj - config[1]
					m.fy=m.fy - config[1]
					m.jq=m.jq - config[2]
					m.jy=m.jy - config[2]
				end)
				SendToClient(playerID,"tzj_wave_random_event",{event="strong",info="events8",kv={value=math.ceil(config[2]*100)},cooldown=GetGameTimeWithoutPause()+120})
			elseif eventType == "gwxl" then
				--触发事件后，所有人的怪物都得到加强
				m.xl=m.xl + config[1]
				m.fy=m.fy + config[1]
				m.jq=m.jq + config[2]
				m.jy=m.jy + config[2]
				TimerUtil.createTimerWithDelay(120,function()
					m.xl=m.xl - config[1]
					m.fy=m.fy - config[1]
					m.jq=m.jq - config[2]
					m.jy=m.jy - config[2]
				end)
				SendToClient(playerID,"tzj_wave_random_event",{event="strong",info="events9",kv={value=math.ceil(config[2]*100)},cooldown=GetGameTimeWithoutPause()+120})
			elseif eventType == "gwgj" then
				--触发事件后，所有人的怪物都得到加强
				m.gj=m.gj + config[1]
				m.xl=m.xl + config[1]
				m.jq=m.jq + config[2]
				m.jy=m.jy + config[2]
				TimerUtil.createTimerWithDelay(120,function()
					m.gj=m.gj - config[1]
					m.xl=m.xl - config[1]
					m.jq=m.jq - config[2]
					m.jy=m.jy - config[2]
				end)
				SendToClient(playerID,"tzj_wave_random_event",{event="strong",info="events10",kv={value=math.ceil(config[2]*100)},cooldown=GetGameTimeWithoutPause()+120})
			end
		end
	end
end

function m.SpawnAttackBoss()
	if m.bossnum < m.max_boss_count then
		local countdown = m.bosscountdown;
		TimerUtil.createTimer(function()
			if m.gameFinished then
				return;
			end
			CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_boss_timer",{time=countdown})	
			if countdown ==0 then  
				m.bossnum = m.bossnum +1 --第几个BOSS
				local bossName = table.remove( m.attackboss, RandomInt(1,#m.attackboss) ) 	--随机出一个BOSS，出现过的BOSS不会重复
				local boss = shuaguai.SpwanAttackBoss(bossName,m.bossnum)
				
				if boss then
					SurvivalBossDPS.BossSpawn(boss,m.bossnum)
					if m.bossnum == m.max_boss_count then
						boss._IsFinalBoss = true;
					end
					CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_boss_spawn",{id=boss:entindex(),isFinal=boss._IsFinalBoss,num=m.bossnum})	
					m.AttackBossTimer(boss)
					
					bgm.PlaySurvivalBoss(boss._IsFinalBoss,m.bossnum)
					if Stage.gameFinished then   --如果游戏结束或胜利，则不刷BOSS
						return;
					end
					m.SpawnAttackBoss()
				else
					DebugPrint("[SpawnAttackBoss] Spawn faild.")
				end
			else
				if countdown == 10 then
					NotifyUtil.Top(nil,"#info_survival_boss_coming",6,"red",false,NotifyUtil.STYLE_BlackBack_Alpha)
					bgm.PlaySurvivalBossPre()
				end
			
				countdown = countdown - 1
				return 1
			end
		end)
	end
end

function m.AttackBossTimer(boss)
	local totalTime = 180
	local restTime = totalTime
	TimerUtil.createTimer(function() 
		CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_boss_countdowntime",{countdowntime=restTime,time=totalTime})	
		
		--累计数量导致游戏失败了，此时要杀死boss
		if m.gameFinished then
			if EntityIsAlive(boss) then
				CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_boss_die",{id=boss:entindex()})
				EntityHelper.kill(boss,true)
			end
			return;
		end
		
		--boss死亡，结束计时
		if not EntityIsAlive(boss) then
			TimerUtil.createTimerWithDelay(2,function()
				bgm.PlayNormal(m.bossnum == m.max_boss_count - 1,m.bossnum+1)
			end)
			
			NotifyUtil.ShowGameOverHint()
			--最终boss死亡判定胜利
			if boss._IsFinalBoss then
				m.PlayerWin()
			end
			return 
		end
		
		
		if restTime == 0 then
			CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_boss_die",{id=boss:entindex()})
			EntityHelper.kill(boss,true)
			m.PlayerLose()
		elseif restTime == 60 then
			--1分钟的时候提醒1次，10秒后每秒都提示
			NotifyUtil.Top(nil,"#info_game_over_prompt",8,"red",false,NotifyUtil.STYLE_BlackBack_Alpha,{time=restTime})
		elseif restTime <= 10 then
			NotifyUtil.ShowGameOverHint(restTime)
			NotifyUtil.ShowSysMsg2(nil,"#info_game_over_prompt"..restTime)
		end
		
		if restTime > 0 then
			restTime = restTime - 1
			return 1;
		end
  	end)
end

function m.Yxms(ms)
	if ms == 1 then  --如果是模式1 则不执行任何操作
		return nil 
	end

	if ms == 2 then --狂暴模式，怪物强度+100%，怪物基础经验和基础金钱+100%
		m.xl=m.xl + 1
		m.gj=m.gj + 1
		m.fy=m.fy + 1
		m.jq=m.jq + 0.4
		m.jy=m.jy + 0.4
		return nil
	end

	if ms == 3 then
		local p = Entities:FindByName(nil,"fyd1"):GetAbsOrigin()
		local unit = CreateUnitByName("ndms_3", p, false, nil, nil, TEAM_ENEMY)
		return nil
	end

	if ms == 4 then  --灾难模式，高级怪出怪概率+50%，精英怪的出现概率+50%
		m.jygchance = math.ceil(m.jygchance * 1.5)
		m.gjgchance = math.ceil(m.gjgchance * 2 )
		return nil
	end

	if ms == 5 then
		local p = Entities:FindByName(nil,"fyd1"):GetAbsOrigin()
		local unit = CreateUnitByName("ndms_5", p, false, nil, nil, TEAM_ENEMY)
		return nil
	end

	if ms == 7 then 
		local p = Entities:FindByName(nil,"fyd1"):GetAbsOrigin()
		local unit = CreateUnitByName("ndms_7", p, false, nil, nil, TEAM_ENEMY)
		return nil
	end

end

--根据难度调整高级怪
function m.difficultygjg(difficulty)

	if difficulty >= 7  then
		for i=10,#Ygmz.attackUnits2qz do
			Ygmz.attackUnits2qz[i] = tonumber(Ygmz.attackUnits2qz[i]) + difficulty

		end
	end

end

function m.PlayerWin()
	local onlinePlayers = PlayerUtil.GetAllPlayersID(false,true)
	local error = m.BeforeGameFinished(true,onlinePlayers)
	SrvDataMgr.GameFinished(true,onlinePlayers,error)
	
	m.GameRecord()
	
	--延迟结束
	NotifyUtil.Top(nil,"#info_game_finish_prompt_win",5,"#98FB98",false,NotifyUtil.STYLE_BlackBack_Alpha)
	NotifyUtil.ShowSysMsg2(nil,"#info_game_win")
	TimerUtil.createTimerWithDelay(5,function()
		SendToAllClient("tzj_game_finish",{win=true})
		bgm.PlayWin()
	end)
	
end

function m.PlayerLose()
	local onlinePlayers = PlayerUtil.GetAllPlayersID(false,true)
	local error = m.BeforeGameFinished(false,onlinePlayers)
	SrvDataMgr.GameFinished(false,onlinePlayers,error)
	
	--延迟结束
	NotifyUtil.Top(nil,"#info_game_finish_prompt_lose",5,"red",false,NotifyUtil.STYLE_BlackBack_Alpha)
	NotifyUtil.ShowSysMsg2(nil,"info_game_lose")
	TimerUtil.createTimerWithDelay(5,function()
		SendToAllClient("tzj_game_finish",{win=false})
		bgm.PlayLose()
	end)
	
end
--游戏结束时结算地图经验
function m.finishedexp(playerID, playerWin )
	local difficulty =   GetGameDifficulty()
	local time = math.floor(GetGameTimeWithoutPause()/60)
	local jy = time * (0.9+difficulty/10) 
	--没有计算 月卡的加成  月卡和季卡加成30%,永久卡增加50%
	if playerWin == true then
		jy = jy + difficulty*5
	end
	local jc = Shopmall:GetPlayerPluslevel(playerID)
	if jc then
		if jc == 3 then
			jy = jy * 1.5 
		elseif jc == 1 or jc == 2 then
			jy = jy * 1.3
		end
	end
	
	if Invite:IsSameList(playerID) then
		jy = jy * 1.1
	end
	jy = math.ceil(jy)
	return jy
end
--游戏结束时结算杀怪获得晶石
function m.finishedjing(playerID, playerWin )
	local difficulty =   GetGameDifficulty()
	local xg = PlayerResource:GetKills(playerID)
	local boss = Stage.bossdienum --boss死亡数量
	local js = math.ceil((xg * 0.1 + boss*60)*ba.ndjsjc[difficulty])
	if Invite:IsSameList(playerID) then
		js = js * 1.1
	end
	js = math.ceil(js)
	return js 
end

--游戏结束时统一给存档装备和强化
--只有特殊模式才会掉落强化石
function m.finishedjNetItem(playerID)
	if PlayerUtil.IsPlayerLeaveGame(playerID) then
		return nil
	end

	local hero = PlayerUtil.GetHero(playerID)
	local net_equip = nil
	if hero then
		if hero.netItem and #hero.netItem > 0 then
			net_equip = {}
			for key, item in pairs(hero.netItem) do
				hero:AddItem(item)
				table.insert(net_equip,item:entindex())
			end
		end
	end
	
	return net_equip
end

--游戏结束时统一给存档装备和强化
--只有特殊模式才会掉落强化石
function m.finishedStoreItem(playerID,playerWin,mvpnum)
	if PlayerUtil.IsPlayerLeaveGame(playerID) then
		return nil
	end


	local hero = PlayerUtil.GetHero(playerID)
	local mode = GetGameDifficultyModel()
	local difficulty = GetGameDifficulty()

	local store_items = {}
	if hero then
		local bljc = 1  --mvp爆率加成
		if #m.playeronline >= 2 and playerID == mvpnum then  
			bljc = 1 + (#m.playeronline-1) *0.25 
		end
		if bljc > 1.75 then
			bljc = 1.75
		end
		local we = math.ceil(m.ysdl[difficulty] * bljc)
		if we and playerWin then 
			if we < 100 then
				if RollPercent(we) then
					local bonusItem2 = {name="shopmall_68",count=1}
					table.insert(store_items,bonusItem2)
				end
			else
				local we2 = math.floor(we/100)
				local we3 = we - 100*we2
				if RollPercent(we3) then
					we2 = we2 +1
				end
				local bonusItem2 = {name="shopmall_68",count=we2}
				table.insert(store_items,bonusItem2)
			end
		end

		if mode ~= 1 and playerWin then
			local lv = 2
			if difficulty <=7 and difficulty >=5 then
				lv = 2
			elseif difficulty >=8 and difficulty <=14 then
				lv = 3
			elseif difficulty >=15 and difficulty <=22 then
				lv = 4
			elseif difficulty >=23 and difficulty <=29 then
				lv = 5
			elseif difficulty >=30 and difficulty <=35 then
				lv = 6
			elseif difficulty >=36 and difficulty <=41 then
				lv = 7
			end
			local min = m.qhsdl[difficulty][1]
			local max = m.qhsdl[difficulty][2]
			local num = RandomInt(min,max)   --掉落强化石的数量
			local bonusItem = {name="shopmall_sstone_"..lv,count=num}
			table.insert(store_items,bonusItem)
		end
	end
	
	for idx, sitem in pairs(store_items) do
		TimerUtil.createTimerWithDelay((idx - 1) * 2 ,function()
			SrvStore.AddItem(playerID,sitem.name,nil,sitem.count,function(success,item,money)
		        if success then
		            Shopmall:UpdatePlayerdata( playerID,sitem.name,item['stack'],item['invalid_time'])
		        end
		    end,true)
		end)
	end
	return store_items
end

function m.BeforeGameFinished(playerWin,onlinePlayers)
	local status,error = pcall(function()
		--标记游戏结束，不再出怪了
		m.gameFinished = true
		--两个失败逻辑不同步有时候倒计时会消失不了，这里强制清除
		NotifyUtil.ShowGameOverHint()
		shuaguai.DeletePlayerUnits()
		
		--成就信息
		local achievements = m.Achievements(playerWin)
		if achievements then
			for pid, info in pairs(m.playerinfo) do
				if achievements[pid] then
					info.achv = achievements[pid]
				end
			end
		end
		
		--结算界面的信息
		local boss = {}
		for k,v in pairs(SurvivalBossDPS.GetBossData()) do
			local id = v["idx"]
			boss[id]={}
			boss[id]["name"] = k
			boss[id]["hero"] = v["hero"]
			if v["die"] then
				boss[id]["time"] = v.die - v.spawn
			end
			boss[id]["dps"] = SurvivalBossDPS.SortDPSWithPercent(v["dps"]) 
	
			for pid,info in pairs(m.playerinfo) do
				if(v.dps and v.dps[pid]) then
					info.boss_damage = info.boss_damage + v.dps[pid]
				end
			end
		end
		local mvpsh = 0
		local mvpnum =0
		for pid,info in pairs(m.playerinfo) do
			if info.boss_damage > mvpsh then
				mvpsh = info.boss_damage 
				mvpnum = pid
			end
		end
		for pid,info in pairs(m.playerinfo) do
			info.map_exp = m.finishedexp(pid, playerWin )
			info.jing = m.finishedjing(pid, playerWin )
			info.gold = PlagueLand.playergold[pid].totalgold
			info.store_items = m.finishedStoreItem(pid,playerWin,mvpnum) --发放存档装备现在是游戏结算统一
			info.net_items = m.finishedjNetItem(pid)
			info.achv={}
			local achilist=Sachievement:GetAchiThis( pid)
			if achilist then
				for k,v in pairs(achilist) do
					table.insert(info.achv,v.id)
				end
			end
		end
		local mode = {diff=GetGameDifficulty(),mode=GetGameDifficultyModel(),winner=playerWin and TEAM_PLAYER or TEAM_ENEMY}
		SetNetTableValue("endgame","boss",boss)
		SetNetTableValue("endgame","player",m.playerinfo)
		SetNetTableValue("endgame","mode",mode)
	end)
	
	if not status then
		return error
	end
end


function m.Achievements(playerWin)
	local difficulty = GetGameDifficulty()
	local model=GetGameDifficultyModel()
	
	local players = PlayerUtil.GetAllPlayersID(false,true)
	if playerWin then --通行证通关难度任务
		Shopmall:FinishQuestBatch("difficulty_"..difficulty,1,2)--通关某难度
		Shopmall:FinishQuestBatch("hero_pass_1",1,2)--1力量型--2敏捷--3智力
		Shopmall:FinishQuestBatch("hero_pass_2",1,2)--1力量型--2敏捷--3智力
		Shopmall:FinishQuestBatch("hero_pass_3",1,2)--1力量型--2敏捷--3智力
		if difficulty>=5 then
			Shopmall:FinishQuestBatch("difficulty_"..difficulty.."_"..model,1,2)
		end
		Shopmall:FinishQuestBatch("difficulty_0",1,3)--通关任意难度 并上传数据这个一定要放到最后批量上传，上面的都没上传数据的
	end
	for _, PlayerID in pairs(players) do
		local player = PlayerResource:GetPlayer(PlayerID)
		if player then
			local unit = player:GetAssignedHero()
			if unit then
				if playerWin then
					Sachievement:SetAchiState( unit,"hero_single")
					if difficulty>=5 then
						Sachievement:SetAchiState( unit,"difficulty",difficulty.."_"..model,difficulty) --难度成就
					else
						Sachievement:SetAchiState( unit,"difficulty",difficulty,difficulty) --难度成就
					end
				end
				if unit:GetDeaths()==0 then
					Sachievement:SetAchiState( unit,"hidden",1,1)
				end
				if unit:GetDeaths()>=30 then
					Sachievement:SetAchiState( unit,"hidden",3,unit:GetDeaths())
				end
				if unit:GetDeaths()>=100 then
					Sachievement:SetAchiState( unit,"hidden",4,unit:GetDeaths())  
				end
			end
		end
	end
	
	return nil
end


function m.GameRecord()
	local players = PlayerUtil.GetAllPlayersID()
	if players and #players > 0 then
		local aids = nil
		local damage = {}
		for key, PlayerID in pairs(players) do
			local aid = PlayerUtil.GetAccountID(PlayerID)
			if aids then
				aids = aids..","..aid
			else
				aids = aid
			end
			
			local info = m.playerinfo[PlayerID]
			if info and info.boss_damage then
				damage[aid] = info.boss_damage
			end
		end
		
		
		local params = {}
		params.aid = aids
		params.nd = GetGameDifficulty()
		params.game_mode = GetGameDifficultyModel()
		params.time = math.ceil(GameRules:GetDOTATime(false,false) * 1000)
		if TableNotEmpty(damage) then
			params.damage = JSON.encode(damage)
		end
		SrvHttp.load("tzj_gp",params)
	end
end


function m.Stop()
	TimerUtil.createTimerWithDelay(m.intervalWave,function() 
     	m.StartAttack()
 	 end)
	
end

---每十秒加金币和每十秒加杀敌数
function m.msmjq(hero)
	TimerUtil.createTimer(function()
		--for i=0,3 do
		--	local hero = PlayerUtil.GetHero(i)
			if hero then
				local jqjc = hero.cas_table.jqjc + 100
				local gold = hero.cas_table.msmjq
				gold = math.ceil(gold * jqjc / 100)
				PlayerUtil.ModifyGold(hero,gold)
				if hero.cas_table.msmjsds >0 then
					local unitKey = tostring(EntityHelper.getEntityIndex(hero))
					local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
					netTable["sds"] = netTable["sds"] + hero.cas_table.msmjsds
					SetNetTableValue("UnitAttributes",unitKey,netTable)
				end
			end
	--	end
		return 10   
	end)
end


---每十秒加金币和每十秒加杀敌数
function m.msmtbnettable(hero)
	if EntityNotNull(hero) then
		TimerUtil.CreateTimerWithEntity(hero,function()
			CustomNetTables:SetTableValue("UnitAttributes",tostring(hero:entindex()),hero.cas_table);
			return 0.2
		end)
	end
end

---开始刷 2阶中立怪

function m.attackzlg2()

	TimerUtil.createTimer(function()
	shuaguai.SpawnCreatureZlg2()
	return 60   --中立怪的数量60S刷新一次
	end)

end










---暂停刷进攻怪
--@param #number duration 暂停时长
function m.StopAttack(duration)
	if type(duration) == "number" then
		m.pause = true
		TimerUtil.createTimerWithContext(duration,function()
			m.pause = false
		end)
	end
end

---章节结束
function m.End()
	if type(m.endCall) == "function" then
		m.endCall()
	end
end



return m