local m = {}
local stages = {
	[1] = require('youxiliucheng.stage.defines.Stage1'),
}
--当前章节（从1开始）
local current = 1

---游戏准备阶段，开启草庙村视野
function m.PreGame()
	
end

---游戏开始，从第一章开始刷怪
function m.StartGame()
	current = 1 
	local stage = stages[current]
	if stage then
		stage.Begin(m.NextStage)
	end
end





---进入下一章，无论当前章节是否结束
function m.NextStage()
	TimerUtil.createTimerWithDelay(120, function()
		current = current + 1
		local stage = stages[current]
		if stage then
			stage.Begin(m.NextStage)
		end
	end)
end


function m.StageTest(stage)
	if IsInToolsMode() then
		current = stage
		local stage = stages[current]
		if stage then
			stage.Begin(m.NextStage)
		end
	end
end

---当前章节实体
function m.Current()
	return stages[current]
end

function m.EnableFastMode()
	local stage = m.Current()
	--没有开始进攻的时候才有效，已经开始进攻了就不改变了
	if stage and stage.EnableFastMode then
		stage.EnableFastMode()
	end
end



--init()
return m