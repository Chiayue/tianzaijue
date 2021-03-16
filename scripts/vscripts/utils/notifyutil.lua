local m = {}

---黑底，边距=（5 30），圆角7。使用这个样式的话，不要用拼接的方式显示内容，否则内容会断开（有border-radius导致的）
m.STYLE_BlackBack = {["background-color"] = "black",["padding"] = "5px 30px",["border-radius"]="7px"};

---黑底，颜色透明(0.9)，边距=（5 30），圆角7。使用这个样式的话，不要用拼接的方式显示内容，否则内容会断开（有border-radius导致的）
m.STYLE_BlackBack_Alpha = {["background-color"] = "rgba(0,0,0,0.9)",["padding"] = "5px 30px",["border-radius"]="7px"};

---由于同时会有多个逻辑在判断游戏结束，并向客户端发送游戏失败倒计时。
--所以要保证，只有第一个开始倒计时的（这里让所有倒计时都是一样的时长，否则计时可能会有跳动，看起来比较诡异）来源才会向客户端同步，
--因为这个肯定是剩余时间最少的，这个失败了，其他的也没有判断的必要了
local gameOverHintSource = nil;

---发送顶端提示消息
--@param #number PlayerID 接收消息的玩家id，为空，则发送给所有人
--@param #string text 消息文本 ，支持"#xxx" 的国际化形式
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #boolean continue 表示是否要把当前这条信息和上一条拼接成一条信息来显示
--@param #table styles CSS样式，可以给消息Label额外加样式，比如{["background-color"]="rgba(128,0,0, 0.6)"}
--@param #table keyValue 如果text中含有格式化字符串（{s:xxx}，仅支持字符串），则传入这个值即可，key就是对应的key，value是显示值
function m.Top(PlayerID,text,duration,color,continue,styles,keyValue)
	local msg = {["text"]=text,["duration"]=duration,["style"]={["color"]=color},["continue"]=continue or false,fmtKV = keyValue}
	
	if type(styles) == "table" then
		for key, var in pairs(styles) do
			msg.style[key] = var
		end
	end
	
	if PlayerID and PlayerResource:IsValidPlayer(PlayerID)  then
		Notifications:Top(PlayerID,msg);
	else
		Notifications:TopToAll(msg)
	end
end

---发送顶端提示消息
--@param #number PlayerID 接收消息的玩家id，为空，则发送给所有人
--@param #string text 消息文本 ，支持"#xxx" 的国际化形式
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #table keyValue 如果text中含有格式化字符串（{s:xxx}，仅支持字符串），则传入这个值即可，key就是对应的key，value是显示值
function m.Top2(PlayerID,text,duration,color,keyValue)
	m.Top(PlayerID,text,duration,color,nil,nil,keyValue)
end

---向所有玩家发送顶端提示消息
--@param #string text 消息文本 ，支持"#xxx" 的国际化形式
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #table keyValue 如果text中含有格式化字符串（{s:xxx}，仅支持字符串），则传入这个值即可，key就是对应的key，value是显示值
function m.Top2All(text,duration,color,keyValue)
	m.Top(nil,text,duration,color,nil,nil,keyValue)
end

---发送唯一性顶部消息，重复显示的时候只会显示一条，不支持拼接
--@param #number PlayerID 接收消息的玩家id，为空，则发送给所有人
--@param #string text 消息文本 ，支持"#xxx" 的国际化形式
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #table styles CSS样式，可以给消息Label额外加样式，比如{["background-color"]="rgba(128,0,0, 0.6)"}
--@param #table keyValue 如果text中含有格式化字符串（{s:xxx}，仅支持字符串），则传入这个值即可，key就是对应的key，value是显示值
function m.TopUnique(PlayerID,text,duration,color,styles,keyValue)
	if text then
		local msg = {["text"]=text,["duration"]=duration,["style"]={["color"]=color},fmtKV = keyValue}
		
		if type(styles) == "table" then
			for key, var in pairs(styles) do
				msg.style[key] = var
			end
		end
		
		m.ClearTop(PlayerID,text)
		
		if PlayerID and PlayerResource:IsValidPlayer(PlayerID) then
			Notifications:Top(PlayerID,msg);
		else
			Notifications:TopToAll(msg)
		end
	end
end

---发送唯一性顶部消息，重复显示的时候只会显示一条，不支持拼接
--@param #number PlayerID 接收消息的玩家id，为空，则发送给所有人
--@param #string text 消息文本 ，支持"#xxx" 的国际化形式
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #table keyValue 如果text中含有格式化字符串（{s:xxx}，仅支持字符串），则传入这个值即可，key就是对应的key，value是显示值
function m.TopUnique2(PlayerID,text,duration,color,keyValue)
	if text then
		local msg = {["text"]=text,["duration"]=duration,["style"]={["color"]=color},fmtKV = keyValue}
		
		m.ClearTop(PlayerID,text)
		
		if PlayerID and PlayerResource:IsValidPlayer(PlayerID) then
			Notifications:Top(PlayerID,msg);
		else
			Notifications:TopToAll(msg)
		end
	end
end

---发送唯一性顶部消息，重复显示的时候只会显示一条，不支持拼接
--@param #string text 消息文本 ，支持"#xxx" 的国际化形式
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #table keyValue 如果text中含有格式化字符串（{s:xxx}，仅支持字符串），则传入这个值即可，key就是对应的key，value是显示值
function m.TopUnique2All(text,duration,color,keyValue)
	if text then
		local msg = {["text"]=text,["duration"]=duration,["style"]={["color"]=color},fmtKV = keyValue}
		Notifications:ClearTopFromAll(text)
		Notifications:TopToAll(msg)
	end
end

---发送顶端拼接形的提示消息
--@param #number PlayerID 接收消息的玩家id，为空，则发送给所有人
--@param #string textGroup {	
--	{xxxx,{}}, --text可以是一个table，则第一个参数是要国际化的字符串，第二个是对应的格式化参数值，可为空。比如 "test_local" "数字增加{s:value}"，则这里就是 {"test_local",{value=123}}
--	xxxx, text也可以是个字符串
--	...
--	}
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #table styles CSS样式，可以给消息Label额外加样式，比如{["background-color"]="rgba(128,0,0, 0.6)"}
function m.TopGroup(PlayerID,textGroup,duration,color,styles)
	if type(textGroup) == "table" and #textGroup > 0 then
		for i, textData in ipairs(textGroup) do
			if i == 1 then
				if type(textData) == "string" then
					m.Top(PlayerID,textData,duration,color,false,styles)
				elseif type(textData) == "table" then
					m.Top(PlayerID,textData[1],duration,color,false,styles,textData[2])
				end
			else
				if type(textData) == "string" then
					m.Top(PlayerID,textData,duration,color,true,styles)
				elseif type(textData) == "table" then
					m.Top(PlayerID,textData[1],duration,color,true,styles,textData[2])
				end
			end
		end
	end
end


---发送底部提示消息
--@param #number PlayerID 接收消息的玩家id，为空，则发送给所有人
--@param #string text 消息文本 ，支持"#xxx" 的国际化形式
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #boolean continue 表示是否要把当前这条信息和上一条拼接成一条信息来显示
--@param #table styles CSS样式，可以给消息Label额外加样式，比如{["background-color"]="rgba(128,0,0, 0.6)"}
function m.Bottom(PlayerID,text,duration,color,continue,styles,keyValue)
	local msg = {["text"]=text,["duration"]=duration,["style"]={["color"]=color},["continue"]=continue or false,fmtKV = keyValue}
	
	if type(styles) == "table" then
		for key, var in pairs(styles) do
			msg.style[key] = var
		end
	end
	
	if PlayerID and PlayerResource:IsValidPlayer(PlayerID) then
		Notifications:Bottom(PlayerID,msg);
	else
		Notifications:BottomToAll(msg)
	end
end

---发送唯一性底部消息，重复显示的时候只会显示一条，不支持拼接
--@param #number PlayerID 接收消息的玩家id，为空，则发送给所有人
--@param #string text 消息文本 ，支持"#xxx" 的国际化形式
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #table styles CSS样式，可以给消息Label额外加样式，比如{["background-color"]="rgba(128,0,0, 0.6)"}
function m.BottomUnique(PlayerID,text,duration,color,styles,keyValue)
	if text then
		local msg = {["text"]=text,["duration"]=duration,["style"]={["color"]=color},fmtKV = keyValue}
		
		if type(styles) == "table" then
			for key, var in pairs(styles) do
				msg.style[key] = var
			end
		end
		
		m.ClearBottom(PlayerID,text)
		
		if PlayerID and PlayerResource:IsValidPlayer(PlayerID) then
			Notifications:Bottom(PlayerID,msg);
		else
			Notifications:BottomToAll(msg)
		end
	end
end

---将给定的信息拼接显示在底部
--@param #number PlayerID 接收消息的玩家id，为空，则发送给所有人
--@param #table textGroup 所有的消息文本，按照table中的顺序拼接成最终显示的文本（支持 "#xxx" 的国际化形式）
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #table styles CSS样式，可以给消息Label额外加样式，比如{["background-color"]="rgba(128,0,0, 0.6)"}（Error信息的背景色）
function m.BottomGroup(PlayerID,textGroup,duration,color,styles)
	if type(textGroup) == "table" and #textGroup > 0 then
		for i, textData in ipairs(textGroup) do
			if i == 1 then
				if type(textData) == "string" then
					m.Bottom(PlayerID,textData,duration,color,false,styles)
				elseif type(textData) == "table" then
					m.Bottom(PlayerID,textData[1],duration,color,false,styles,textData[2])
				end
			else
				if type(textData) == "string" then
					m.Bottom(PlayerID,textData,duration,color,true,styles)
				elseif type(textData) == "table" then
					m.Bottom(PlayerID,textData[1],duration,color,true,styles,textData[2])
				end
			end
		end
	end
end

---将给定的信息拼接显示在底部，并且显示唯一，<font color="red">以group的第一个文本作为id保证唯一性</font>
--@param #number PlayerID 接收消息的玩家id，为空，则发送给所有人
--@param #table textGroup 所有的消息文本，按照table中的顺序拼接成最终显示的文本（支持 "#xxx" 的国际化形式）
--@param #number duration 消息持续时间
--@param #string color 消息颜色(html标准，颜色名，比如green，yellow等；或者#XXXXXX)
--@param #table styles CSS样式，可以给消息Label额外加样式，比如{["background-color"]="rgba(128,0,0, 0.6)"}（Error信息的背景色）
function m.BottomGroupUnique(PlayerID,textGroup,duration,color,styles)
	if type(textGroup) == "table" and #textGroup > 0 then
		local id = textGroup[1]
		if type(id) == "table" then
			id = id[1]
		end
		m.ClearBottom(PlayerID,id)
	
		for i, textData in ipairs(textGroup) do
			if i == 1 then
				if type(textData) == "string" then
					m.Bottom(PlayerID,textData,duration,color,false,styles)
				elseif type(textData) == "table" then
					m.Bottom(PlayerID,textData[1],duration,color,false,styles,textData[2])
				end
			else
				if type(textData) == "string" then
					m.Bottom(PlayerID,textData,duration,color,true,styles)
				elseif type(textData) == "table" then
					m.Bottom(PlayerID,textData[1],duration,color,true,styles,textData[2])
				end
			end
		end
	end
end

---清除某玩家底部的所有提示信息
--@param #number PlayerID 玩家id，为空则清除所有玩家的
--@param #string text 删除展示内容是这个text的所有的消息，可以是国际化形式 #xxx。注意：如果信息文本是拼接出来的(用continue属性)，则这里只需要传入拼接语句的第一个文本即可
function m.ClearBottom(PlayerID,text)
	if PlayerID and PlayerResource:IsValidPlayer(PlayerID) then
		Notifications:ClearBottom(PlayerID,text)
	else
		Notifications:ClearBottomFromAll(text)
	end
end

---清除某玩家顶部的所有提示信息
--@param #number PlayerID 玩家id，为空则清除所有玩家的
--@param #string text 删除展示内容是这个text的所有的消息，可以是国际化形式 #xxx。注意：如果信息文本是拼接出来的(用continue属性)，则这里只需要传入拼接语句的第一个文本即可
function m.ClearTop(PlayerID,text)
	if PlayerID and PlayerResource:IsValidPlayer(PlayerID) then
		Notifications:ClearTop(PlayerID,text)
	else
		Notifications:ClearTopFromAll(text)
	end
end

---显示错误信息，在底部中间，同时只会存在一个错误提示
--@param #number PlayerID 玩家id，如果为空的话，将会发送给所有玩家
--@param #string text 提示信息的国际化标识
--@param #table keyValue 格式化国际化用的参数。 可为空
function m.ShowError(PlayerID,text,keyValue)
	if type(text) == "string" then
		local data = {msg=text}
		if keyValue ~= nil then
			data.kv = keyValue
		end
	
		if PlayerID and PlayerResource:IsValidPlayer(PlayerID) then
			SendToClient(PlayerID,"custom_show_dota_hud_error",data)
		else
			SendToAllClient("custom_show_dota_hud_error",data)
		end
	end
end

---在左下角显示一条系统信息，固定显示8秒
--@param #number PlayerID 目标玩家id，为空的时候发送给所有玩家
--@param #any textGroup 文本信息。可以是字符串或者一个包含字符串的表，支持国际化形式#xxx。如果为空，则不发送
--@param #number pid 发送消息的玩家id，为空则默认显示系统
--@param #any itemNameOrID 要展示的物品信息（可以是物品名字或者物品ID，装备的动态属性只有传入id才会显示），需要在国际化文本中要显示物品的位置添加一个<Panel>标签。
--比如国际化为 “公共仓库有：{s:name}<Panel>”，则图片就会出现在<Panel>所在的位置，<Panel>位置在哪里都行。 目前仅支持显示一个物品
--@param #table keyValue 如果text中含有格式化字符串（{s:xxx}，仅支持字符串），则传入这个值即可，key就是对应的key，value是显示值
function m.ShowSysMsg(PlayerID,textGroup,pid,itemNameOrID,keyValue)
	if textGroup then
		if type(textGroup) == "string" then
			textGroup = {textGroup}
		end
		
		if PlayerID then
			SendToClient(PlayerID,"show_custom_sys_msg",{msg=textGroup,player=pid,item=itemNameOrID,fmtKV=keyValue})
		else
			SendToAllClient("show_custom_sys_msg",{msg=textGroup,player=pid,item=itemNameOrID,fmtKV=keyValue})
		end
	end
end

---在左下角显示一条系统信息，固定显示8秒
--@param #number PlayerID 目标玩家id，为空的时候发送给所有玩家
--@param #any textGroup 文本信息。可以是字符串或者一个包含字符串的表，支持国际化形式#xxx。如果为空，则不发送
--@param #table keyValue 如果text中含有格式化字符串（{s:xxx}，仅支持字符串），则传入这个值即可，key就是对应的key，value是显示值
function m.ShowSysMsg2(PlayerID,textGroup,keyValue)
	m.ShowSysMsg(PlayerID,textGroup,nil,nil,keyValue)
end

function m.ShowKillHeroMsg(diedHero,killerUnit)
	if diedHero and killerUnit then
		local data = {}
		data.player = PlayerUtil.GetOwnerID(diedHero)
		if killerUnit:IsConsideredHero() and killerUnit:GetUnitLabel() ~= nil and killerUnit:GetUnitLabel() ~= "" then
			data.boss = killerUnit:GetUnitName()
			data.boss_hero = killerUnit:GetUnitLabel()
			data.taunt = RandomInt(1,22)
		else
			data.taunt = RandomInt(1,3)
		end
		SendToAllClient("show_custom_sys_msg_kill_hero",data)
	end
end

---显示游戏结束的提示数字
--@param #number source 引用NotifyUtil.GameOverCheckerXXXXX
--@param #number time 剩余时间，为null的时候，清空显示的数字
function m.ShowGameOverHint(time)
	if time == nil then
		gameOverHintSource = nil
		SendToAllClient("tzj_game_over_hint",{})
		return;
	elseif not gameOverHintSource or gameOverHintSource > time then
		gameOverHintSource = time
		
		SendToAllClient("tzj_game_over_hint",{time=time})
	end
end

return m;
