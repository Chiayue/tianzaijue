
function smzs( keys )
	local caster = keys.caster
	local ability= keys.ability
	local level =  ability:GetLevel() - 1
	local position = ability:GetCursorPosition()	
	local duration = ability:GetLevelSpecialValueFor("duration", level)
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local i = ability:GetLevelSpecialValueFor("i", level)
	local interval = ability:GetLevelSpecialValueFor("interval", level)
	local unit = CreateUnitByName("shengmingzhishu", position, true, caster, nil, caster:GetTeam())
	unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	unit:SetOwner(caster)
	unit:AddNewModifier(unit, ability, "modifier_kill", { duration = duration })
	unit:GetAbilityByIndex(0):SetLevel(level+1)
	local damage = caster:GetStrength() * i * (1+level)
	local time = 0
	-- 脚下特效
	TimerUtil.createTimerWithDelay(0,function()
		if time <= duration then
			local units = FindAlliesInRadiusExdd(caster,position,radius)
			if units ~= nil then
				for key, unit in pairs(units) do	
					ApplyDamageEx(caster,unit,ability,damage)			
				end
			end
			time = time +interval
			return interval
		end
	end)

	

end