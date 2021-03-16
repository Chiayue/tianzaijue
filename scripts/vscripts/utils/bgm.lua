---没有很好的禁用dota自带的背景音乐的方式，目前采用的是利用空音乐覆盖掉了相关的sound文件（只game下的）
--但是一旦dota更新了音乐，就要进行相应的同步更新（貌似dota是每年一次？如果是就太好了。。。）
local m = {}

local musics = {
	normal = {
		{"tzj.bgm_normal_1",64},
		{"tzj.bgm_normal_2",64},
		{"tzj.bgm_normal_3",64},
		{"tzj.bgm_normal_4",64}
	},
	normal_final = {"tzj.bgm_normal_final",64},
	boss = {
		{"tzj.bgm_survival_boss_1",72},
		{"tzj.bgm_survival_boss_2",72},
		{"tzj.bgm_survival_boss_3",72},
		{"tzj.bgm_survival_boss_4",72}
	},
	boss_final = {"tzj.bgm_survival_boss_final",96}
}

local playing = nil

local playersCloseBGM = {}

local forcePlay = {
	["tzj.bgm_survival_boss_pre"] = true,
	["dsadowski_01.stinger.dire_win"] = true,
	["valve_ti5.stinger.radiant_lose"] = true,
}

local function EmitForAllPlayer(soundName,stop)
	local players = PlayerUtil.GetAllPlayersID(false,true)
	for _, PlayerID in pairs(players) do
		local player = PlayerResource:GetPlayer(PlayerID)
		if player then
			if stop then
				StopSoundOn(soundName,player)
			elseif not playersCloseBGM[PlayerID] or forcePlay[soundName] then
				EmitSoundOnClient(soundName,player)
			end
		end
	end
end

local function EmitSount(soundName,duration)
	if playing then
		EmitForAllPlayer(playing.name,true)
		if playing.timer then
			TimerUtil.removeTimer(playing.timer)
		end
	end
	
	EmitForAllPlayer(soundName)
	
	local timer = nil
	if duration then
		timer = TimerUtil.createTimerWithDelay(duration,function()
			EmitSount(soundName,duration)
		end)
	end
	playing = {name=soundName,timer=timer}
end

function m.PlayNormal(isFinal,stage)
	if isFinal then
		local music = musics.normal_final
		EmitSount(music[1],music[2])
	else
		local music = musics.normal
		if stage > #music then
			stage = stage % #music
		end
		music = music[stage]
		
		EmitSount(music[1],music[2])
	end
end

function m.PlaySurvivalBoss(isFinal,stage)
	if isFinal then
		local music = musics.boss_final
		EmitSount(music[1],music[2])
	else
		local music = musics.boss
		if stage > #music then
			stage = stage % #music
		end
		music = music[stage]
		
		EmitSount(music[1],music[2])
	end
end

function m.PlaySurvivalBossPre()
	EmitSount("tzj.bgm_survival_boss_pre")
end


function m.PlayWin()
	EmitSount("dsadowski_01.stinger.dire_win")
end

function m.PlayLose()
	EmitSount("valve_ti5.stinger.radiant_lose")
end

function m.Client_ToggleState(_,keys)
	if PlayerUtil.IsValidPlayer(keys.PlayerID) then
		playersCloseBGM[keys.PlayerID] = keys.close
		
		local player = PlayerResource:GetPlayer(keys.PlayerID)
		if player and playing and not forcePlay[playing.name] then
			--下面这个也可以，但是是从头开始播放的，应该是第三个参数设置的问题。暂时不研究了，就直接从头开始
			--player:EmitSoundParams(playing.name,0,1,0)
			if keys.close == 1 then
				StopSoundOn(playing.name,player)
			else
				EmitSoundOnClient(playing.name,player)
			end
		end
	end
end

RegisterEventListener("tzj_toggle_bgm",m.Client_ToggleState)
return m;