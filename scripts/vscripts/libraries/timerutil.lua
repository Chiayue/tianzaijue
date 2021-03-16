local m = {}

---创建一个立即执行的计时器（依赖于游戏时间），返回计时器名字。
--@param #function func 执行函数
function m.createTimer(func)
  return Timers:CreateTimer(func);
end

---创建一个延迟执行的计时器（依赖于游戏时间），返回计时器名字
--@param #number delay 延迟时间,单位秒
--@param #function func 执行函数
function m.createTimerWithDelay(delay,func)
	return Timers:CreateTimer(delay,func);
end

---创建一个立即执行，且包含上下文的计时器（依赖于游戏时间），返回计时器名字。
--@param #function func 执行函数
--@param #any context 上下文
function m.createTimerWithContext(func,context)
  return Timers:CreateTimer(func,context);
end

---使用Entity的contextthink创建计时器，在游戏暂停的时候不执行函数逻辑
function m.CreateTimerWithEntity(entity,func,delay)
	if EntityNotNull(entity) and type(func) == "function" then
		entity:SetContextThink(DoUniqueString("timer"),function()
			if GameRules:IsGamePaused() then
				return 0.01
			end
		
			local status,nextCall = xpcall(func,function(msg)
				return msg..'\n'..debug.traceback()..'\n'
			end)
			
			if not status then
				DebugPrint(nextCall)
			else
				return nextCall;
			end
		end,delay or 0)
	end
end

--****************************下面是依赖于现实时间的计时器***********************

---创建一个立即执行的计时器（依赖于现实时间），返回计时器名字
--@param #function func 执行函数
function m.createTimerWithRealTime(func)
  return Timers:CreateTimer({
		useGameTime = false,
		callback = func
	});
end

---创建一个延迟执行的计时器（依赖于现实时间），返回计时器名字。时间单位秒
--@param #number delay 延迟时间,单位秒
--@param #function func 执行函数
function m.createTimerWithDelayAndRealTime(delay,func)
	return Timers:CreateTimer({
		useGameTime = false,
		endTime = delay,
		callback = func
	});
end

---根据计时器名字移除计时器
function m.removeTimer(name)
	Timers:RemoveTimer(name)
end

return m;