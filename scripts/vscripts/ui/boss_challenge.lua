require("ui.boss_config")

local m = {}

local playerCooldown = {}



local config = {
	suit = {--套装boss
		tz_3_1 = {
			battle_power = 10,
			gold=3000,
			cooldown = 30
		},
		tz_3_2 = {
			battle_power = 15,
			gold=6000,
			cooldown = 30
		},
		tz_3_3 = {
			battle_power = 15,
			gold=12000,
			cooldown = 30
		},
		tz_4_1 = {
			battle_power = 20,
			gold=20000,
			cooldown = 60
		},
		tz_4_2 = {
			battle_power = 25,
			gold=30000,
			cooldown = 60
		},
		tz_4_3 = {
			battle_power = 25,
			gold=40000,
			cooldown = 60
		},
		tz_5_1 = {
			battle_power = 30,
			gold=60000,
			cooldown = 90
		},
		tz_5_2 = {
			battle_power = 30,
			gold=80000,
			cooldown = 90
		},
		tz_5_3 = {
			battle_power = 35,
			gold=100000,
			cooldown = 90
		},
		tz_6_1 = {
			battle_power = 40,
			gold=150000,
			cooldown = 120
		},
		tz_6_2 = {
			battle_power = 40,
			gold=200000,
			cooldown = 120
		},
		tz_6_3 = {
			battle_power = 50,
			gold=250000,
			cooldown = 120
		},
	
	},
	personal = {--个人boss
		gr_1 = {
			battle_power = 40,
			gold=50000,
			cooldown = 120
		};

		gr_2 = {
			battle_power = 50,
			gold=100000,
			cooldown = 180
		};
	
		gr_3 = {
			battle_power = 60,
			gold=200000,
			cooldown = 240
		};
	
		gr_4 = {
			battle_power = 70,
			gold=400000,
			cooldown = 360
		};
	
		gr_5 = {
			battle_power = 80,
			gold=800000,
			cooldown = 420
		}
	};

	team = {--团队boss
		team_1 = {
			battle_power = 40,
			gold=50000,
			cooldown = 120
		};
		team_2 = {
			battle_power = 50,
			gold=100000,
			cooldown = 180
		};
		team_3 = {
			battle_power = 60,
			gold=200000,
			cooldown = 240
		};
		team_4 = {
			battle_power = 70,
			gold=400000,
			cooldown = 360
		};
		team_5 = {
			battle_power = 80,
			gold=800000,
			cooldown = 420
		}
	
	}
}







---客户端事件：
--通知客户端冷却时间：tzj_bc_cooldown  {name="team_1",cd=9}
--客户端点击召唤发送至服务器 ： tzj_bc_summon {name="team_1",PlayerID=0,group="suit/personal/team"}


function m.tzj_bc_summon(_,data)
	if Stage.gameFinished then
		return
	end

	local group = data.group
	local name = data.name
	local playerID = data.PlayerID
	local gold = config[group][name]["gold"]
	local level = config[group][name]["battle_power"]
	local caster = PlayerUtil.GetHero(playerID)
	local xj = PlagueLand:GetNowGold(playerID)
	local level2 = caster:GetLevel()
	if level > level2 then	--如果等级不足
		NotifyUtil.ShowError(playerID,"#level_not")
		return nil
	end
	if gold > xj then  --如果召唤的金额大于玩家的现金
		NotifyUtil.ShowError(playerID,"#money_no")
		return nil 
	end
	gold=-gold
	PlagueLand:ModifyCustomGold(playerID, gold)
	if group == "suit" then
		local name2= string.split(name, "_")
		local pz = tonumber(name2[2])
		local x = tonumber(name2[3])
		local bosspoint = tzbosspoint[pz][x]
		if CallTzBoss(caster,pz,x,bosspoint,playerID) then
			m.AddCooldownTimer(playerID,name,group)
		end
	elseif group == "personal" then
		local name2= string.split(name, "_")
		local x = tonumber(name2[2])
		if CallGrBoss(caster,x,playerID) then
			m.AddCooldownTimer(playerID,name,group)
		end
	elseif group == "team" then
		local name2= string.split(name, "_")
		local x = tonumber(name2[2])
		if CallTeamBoss(caster,x,playerID) then
			m.AddCooldownTimer(playerID,name,group)
		end
	end

end


function m.AddCooldownTimer(PlayerID,name,group)
	local cooldowns = playerCooldown[PlayerID]
	if not cooldowns then
		cooldowns = {}
		playerCooldown[PlayerID] = cooldowns
	end
	cooldowns[name] = config[group][name].cooldown
	TimerUtil.createTimer(function()
		SendToClient(PlayerID,"tzj_bc_cooldown",{name=name,cd=cooldowns[name]})
		cooldowns[name] = cooldowns[name] - 1
		if cooldowns[name] >= 0 then
			return 1
		end
	end)
end


for bossType, data in pairs(config) do
	SetNetTableValue("boss",bossType,data)
end
CustomGameEventManager:RegisterListener( "tzj_bc_summon", m.tzj_bc_summon)
return;