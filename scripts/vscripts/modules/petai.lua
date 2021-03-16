local m = {}

function m.Init(pet,owner)
	if pet and owner then
		TimerUtil.CreateTimerWithEntity(pet,function()
	    	local status,msg = pcall(function()
	    		local distance = ( owner:GetAbsOrigin() - pet:GetAbsOrigin() ):Length2D();
				if distance > 400 then
					if distance > 1000 then
						Teleport(pet,RandomPosInRadius(owner:GetAbsOrigin(),100,50))
					else
						pet:MoveToPosition( RandomPosInRadius(owner:GetAbsOrigin(),100,50))
					end
				elseif (pet.checker1 == nil or pet.checker1 > 10) then
					pet:MoveToPosition(RandomPosInRadius(owner:GetAbsOrigin(),350,100))
					pet.checker1 = 0
				end
				pet.checker1 = pet.checker1 + 1
	    	end)
	    	
	    	if not status then
	    		DebugPrint(msg)
	    	end
	    	
			return 1;
	    end)
	end
end

return m