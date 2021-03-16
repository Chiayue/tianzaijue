--这个模块是用来在npc上面弹出提示信息的。
require('libraries/worldpanels')
local m = {};

---在指定实体头上，向指定玩家弹出提示信息。一个npc头上只会有一个提示框
--@param #table self 
--@param #number playerID 玩家id，显示信息给谁看，多人使用{1,2,3}。全部玩家则传入空
--@param #table entity 实体(或者实体ID)，显示在谁头上。
--@param #string text 显示文本，可以是国际化字符串，比如"#xxx"
--@param #number duration 持续时间
function m:speach(playerID,entity,text,duration)
	if type(text) == "string" then
		text = {msg=text};
	end

	duration = duration or 3

	--有旧的，就使用旧的面板，修改数据和持续时间
	local panels = WorldPanels:getPanelOnEntity(playerID,entity);--获取到的是一个panel的数组
	if panels ~= nil then
		for key, var in pairs(panels) do
			local p = panels[key];
			if p then
				p:SetDataAndDuration(text,duration);
			end
		end
	else
		if playerID ~= nil then
			WorldPanels:CreateWorldPanel(playerID,
				{
					layout = "file://{resources}/layout/custom_game/SpeechBuuble/SpeachBubble.xml",
					entity = entity,
					entityHeight = 250,
					duration = duration,
					data = text
				})
		else
			WorldPanels:CreateWorldPanelForAll(
				{
					layout = "file://{resources}/layout/custom_game/SpeechBuuble/SpeachBubble.xml",
					entity = entity,
					entityHeight = 250,
					duration = duration,
					data = text
				})
		end
	end
end


--清除指定实体上，展示给指定玩家的所有提示信息
function m:delete(playerID,entity)
	WorldPanels:DeleteByPlayerAndEntity(playerID,entity)
end

return m;
