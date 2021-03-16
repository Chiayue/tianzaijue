local m = {}
---所有已被选的英雄，key是英雄名字，value=true代表已经被选了
local allActiveHero = {}
---各个玩家可选的英雄
local playerActiveHero = {}
---英雄选择期间，每个玩家当前随机到的英雄的数据。
--t.name = hero;
--t.primary = 1/2/3
--t.talent = 天赋技能名
local randomHeroes = {}
---记录玩家的刷新使用次数
local playerRefreshTime = {}
---当前是否有玩家正在刷新，同一时刻只有一个，当多个人一起点刷新的时候，
local refreshing = false;
---各个玩家选择的英雄。 {pid = {name=heroName,primary=1/2/3,talent=abilityName}}
local confirmedHero = {}

local setupTotalTime = 60;
if IsInToolsMode() then
	setupTotalTime = 6000000
end
local setupPreTime = 5;
local setupRestTime = nil;
---key是玩家id，value=验证通过的玩家id返回true，没通过的返回false，nil代表数据尚未加载完毕
local validPlayers = {}

---配置各个难度的可选模式，key是难度，value是可能出现的模式
local DifficultyModes = {
	[5] = {1,2},
	[6] = {1,3},
	[7] = {1,4},
	[8] = {1,2},
	[9] = {1,3},
	[10] = {1,4},
	[11] = {1,5},
	[12] = {1,5},
	[13] = {1,6},
	[14] = {1,7},
	[15] = {1,2},
	[16] = {1,2},
	[17] = {1,3},
	[18] = {1,3},
	[19] = {1,4},
	[20] = {1,5},
	[21] = {1,6},
	[22] = {1,7},
	[23] = {1,2},
	[24] = {1,3},
	[25] = {1,4},
	[26] = {1,5},
	[27] = {1,6},
	[28] = {1,7},
	[29] = {1,7},
}
---可选最大难度
local selectableMaxDifficulty = 5

function m.StartSetup(valid)
	if IsCheatMode() and not IsInToolsMode() then
		valid = nil
	end
	
	local authorities = LoadKeyValues("scripts/npc/hero_authority.kv")

	local players = PlayerUtil.GetAllPlayersID(false,true);
	
	for _, PlayerID in pairs(players) do
		local aid = PlayerUtil.GetAccountID(PlayerID);
		if valid and valid[aid] then
			validPlayers[PlayerID] = true;
			
			m.InitPlayerActiveHero(PlayerID,aid,authorities)
			
			playerRefreshTime[PlayerID] = m.GetPlayerRefreshHeroCount(PlayerID);
			m.RandomHeroesForPlayer(PlayerID)
		else
			validPlayers[PlayerID] = false
		end
		
		--更新至客户端
		m.Client_UIInited(nil,{PlayerID=PlayerID})
		m.Client_ForbiddenCheck(nil,{PlayerID=PlayerID})
	end
	
	SetDifficulty(1)
	
	setupRestTime = setupTotalTime
	TimerUtil.createTimer(function()
		if setupRestTime > 0 then
			SendToAllClient("tzj_setup_update_timer",{time=setupRestTime,total=setupTotalTime})
			setupRestTime = setupRestTime - 1;
			return 1;
		else
			m.SetPlayersHero()
		end
	end)
end

function m.InitPlayerActiveHero(PlayerID,aid,authorities)
	local heroes = {}
	playerActiveHero[PlayerID] = heroes
	
	local all = UnitKV.GetAllActiveHeroes()
	local restrict = UnitKV.GetRestrictHeroes()
	
	for heroName, var in pairs(all) do
		if restrict[heroName] then
			local players = authorities[heroName]
			if players and players[aid] then
				table.insert(heroes,heroName)
			end
		else
			table.insert(heroes,heroName)
		end
	end
end

function m.GetPlayerRefreshHeroCount(PlayerID)
	return Shopmall:GetPlayerRefreshTimes(PlayerID) or 0;
end

function m.RandomHeroesForPlayer(PlayerID)
	local actived = playerActiveHero[PlayerID]
	if not validPlayers[PlayerID] or not actived then
		return;
	end
	--恢复之前随机过的英雄为可被随机
	if randomHeroes[PlayerID] then
		for _, hero in pairs(randomHeroes[PlayerID]) do
			allActiveHero[hero.name] = nil;
		end
	end
	
	--不会刷到别人已经刷到的英雄
	local validHeroes = {}
	for _, heroName in pairs(actived) do
		if not allActiveHero[heroName] then
			table.insert(validHeroes,heroName)
		end
	end
	
	local data = {}
	for var=1, 3 do
		if #validHeroes == 0 then
			break;
		end
		local hero = table.remove(validHeroes,RandomInt(1,#validHeroes));
		
		--不被其他人随机到
		allActiveHero[hero] = true;
		
		--本人不会再次随机到该英雄
		for idx, heroName in pairs(actived) do
			if heroName == hero then
				table.remove(actived,idx)
				break;
			end
		end
		
		local t = {}
		t.name = hero;
		t.primary = UnitKV.GetHeroPrimaryAttribute(hero)
		t.talent = UnitKV.GetHeroTalent(hero)
		
		table.insert(data,t)
	end
	
	randomHeroes[PlayerID] = data
	
	return data
end

function m.SetupFinishedCheck()
	local allConfirmed = true;
	local players = PlayerUtil.GetAllPlayersID(false,true);
	for _, PlayerID in pairs(players) do
		if not confirmedHero[PlayerID] then
			allConfirmed = false;
			break;
		end
	end
	
	if allConfirmed then
		if setupRestTime and setupRestTime > setupPreTime then
			setupRestTime = setupPreTime;
		end
	end
end

function m.SetPlayersHero()
	local players = PlayerUtil.GetAllPlayersID(false,true);
	
	for _, PlayerID in pairs(players) do
		local player = PlayerUtil.GetPlayer(PlayerID,true)
		if player then
			local heroName = nil
			local hero = confirmedHero[PlayerID]
			if hero then
				heroName = hero.name
			else
				--没有选择，在随机到的英雄里随机一个
				local random = randomHeroes[PlayerID]
				if random then
					heroName = random[RandomInt(1,#random)].name
				end
			end
			
			if heroName then
				player:SetSelectedHero(heroName)
			end
		end
	end
	
	randomHeroes = nil;
	allActiveHero = nil;
	playerActiveHero = nil;
	playerRefreshTime = nil;
	confirmedHero = nil;
	setupRestTime = nil
end


---界面加载完毕后，才从服务端加载数据。 主要解决断线重连的情况和由于服务器和客户端延迟导致客户端无法及时处理事件的问题
function m.Client_UIInited(_,keys)
	local PlayerID = keys.PlayerID
	if PlayerUtil.IsValidPlayer(PlayerID) and playerRefreshTime then
		local data = {}
		
		data.valid = validPlayers[PlayerID]
		data.server = SrvHttp.server_state
		
		if data.valid then
			data.confirm = confirmedHero
			data.canRefresh = playerRefreshTime[PlayerID]
			
			if randomHeroes and randomHeroes[PlayerID] then
				data.heroes = randomHeroes[PlayerID]
			end
			
			--已解锁难度，默认只有难1，并且已经选中。这里只返回房主解锁的高级难度（如果有的话）
			local achvs = SrvAchv.GetPlayerDataForType(PlayerUtil.GetHostPlayerID(),SrvAchv.achv_type_6)
			if achvs then
				local max = 0
				for key, var in pairs(achvs) do
					local difficulty = Split(key,"_")
					if #difficulty > 1 and tonumber(difficulty[2]) > max then
						max = tonumber(difficulty[2])
					end
				end
				
				if max >= selectableMaxDifficulty then
					selectableMaxDifficulty = max + 1
				end
			end
			
			local difficulties = {}
			for var=1, selectableMaxDifficulty do
				table.insert(difficulties,var)
			end
			
			data.difficulty = difficulties;
		end
		
		SendToClient(PlayerID,"tzj_setup_ui_inited_response",data)
	end
end

function m.Client_RefreshHeroes(_,keys)
	local PlayerID = keys.PlayerID
	if PlayerUtil.IsValidPlayer(PlayerID) and playerRefreshTime and playerRefreshTime[PlayerID] > 0 then
		playerRefreshTime[PlayerID] = playerRefreshTime[PlayerID] - 1;
		local data = m.RandomHeroesForPlayer(PlayerID)
		if data then
			SendToClient(PlayerID,"tzj_setup_update_hero_list",{heroes=data,canRefresh=playerRefreshTime[PlayerID]})
		end
	end
end

function m.Client_ConfirmHero(_,keys)
	local PlayerID = keys.PlayerID
	local heroName = keys.name
	if PlayerUtil.IsValidPlayer(PlayerID) and not confirmedHero[PlayerID] then
		local selectable = false;
		if randomHeroes[PlayerID] then
			for _, hero in pairs(randomHeroes[PlayerID]) do
				if hero.name == heroName then
					selectable = true;
					break;
				end
			end
		end
		if not selectable then
			return;
		end
	
		confirmedHero[PlayerID] = {name=heroName,primary=UnitKV.GetHeroPrimaryAttribute(heroName),talent=UnitKV.GetHeroTalent(heroName)}
		SendToAllClient("tzj_setup_confirm_hero_response",confirmedHero)
		
		m.SetupFinishedCheck();
	end
end


function m.Client_SelectDifficultyMode(_,keys)
	local PlayerID = keys.PlayerID
	if PlayerID == PlayerUtil.GetHostPlayerID() then
		local difficulty = keys.difficulty
		local mode = keys.mode
		
		if difficulty > selectableMaxDifficulty then
			return;
		end
		
		SetDifficulty(difficulty)
		--选择了模式则使用该模式，否则模式默认为1：正常模式
		if mode then
			SetDifficultyMode(mode)
		else
			SetDifficultyMode(1)
		end
		
		--向其他人同步选择结果
		SendToAllClient("tzj_setup_update_difficulty_mode",{mode=mode,difficulty=difficulty})
	end
end

function m.Client_SyncDifficultyAndMode(_,keys)
	local PlayerID = keys.PlayerID
	local data = {
		difficulty = GetGameDifficulty()
	}
	
	--该难度有模式的话，才发送模式信息
	if DifficultyModes[data.difficulty] then
		data.mode = GetGameDifficultyModel()
	end
	
	SendToClient(PlayerID,"tzj_setup_update_difficulty_mode",data)
end


function m.Client_ForbiddenCheck(_,keys)
	local PlayerID = keys.PlayerID
	if PlayerUtil.IsValidPlayer(PlayerID) and validPlayers[PlayerID] == false then
		SendToClient(PlayerID,"tzj_forbidden_show_up",{server=SrvHttp.server_state})
	end
end



local init = function()
	RegisterEventListener("tzj_setup_ui_inited",m.Client_UIInited)
	RegisterEventListener("tzj_setup_refresh_hero_list",m.Client_RefreshHeroes)
	RegisterEventListener("tzj_setup_confirm_hero",m.Client_ConfirmHero)
	RegisterEventListener("tzj_setup_select_difficulty_mode",m.Client_SelectDifficultyMode)
	RegisterEventListener("tzj_setup_select_difficulty_mode_init",m.Client_SyncDifficultyAndMode)
	
	RegisterEventListener("tzj_forbidden_init",m.Client_ForbiddenCheck)
	
	SetNetTableValue("config","difficulty_modes",DifficultyModes)
end

init();
return m;