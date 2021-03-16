local m = class({})

-- 在控制台区域输出
function m.say(msg)
	GameRules:SendCustomMessage(tostring(msg), 0, 0)
end

-- 模仿官方的错误消息提示
-- 默认为红色，如果需要其他颜色，需要用字符串传递颜色代码
-- 默认为没有魔法的声音，如果需要其他报错声音，需要传递报错声音的字符串
function m.bottom(msg, id, color, sound)
	if id == nil then
		print("sfdadasd")
		CustomGameEventManager:Send_ServerToAllClients(PlayerResource:GetPlayer(id), 'msg_bottom', {
			Message = tostring(msg),
			Color = color,
			Sound = sound,
		})
		return
	end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'msg_bottom', {
		Message = tostring(msg),
		Color = color,
		Sound = sound,
	})

	--CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Remaining", duration=10, mode=0, endfade=false, position=0, warning=5, paused=false, sound=true} )
end

-- 左下角区域的官方消息区域
-- 这个东西并不好用，经常会出错
-- 如果不是有必要的话，还是自定义一个
function m.left(msg, playerId, value, team)
	if team == nil then team = -1 end
	local gameEvent = {
        player_id = playerId,
        int_value = value,
        teamnumber = team,
        message = msg,
    }
    FireGameEvent( "dota_combat_event_message", gameEvent )
end

--_G.msg = m
return m;