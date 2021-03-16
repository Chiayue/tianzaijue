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

local function EmitSount(soundName,duration)
	if playing then
		StopGlobalSound(playing.name)
		if playing.timer then
			TimerUtil.removeTimer(playing.timer)
		end
	end
	
	EmitGlobalSound(soundName)
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

return m;