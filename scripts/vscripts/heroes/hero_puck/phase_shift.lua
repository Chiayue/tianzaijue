--[[
	Author: Ractidous
	Date: 29.01.2015.
	Hide caster's model.
]]
function HideCaster( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius",level)
	local point = caster:GetAbsOrigin()
	local units = FindAlliesInRadiusExdd(caster,point,radius)

	local sl = 0
	for key, unit in pairs(units) do
		if sl < 6 then
			if  caster:IsAlive() then
				sl = sl +1
				caster:PerformAttack(unit, true, true, true, false, true, false, true)
			end
		else
			return nil 
		end
	end

	caster:AddNoDraw()
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Show caster's model.
]]
function ShowCaster( event )
	event.caster:RemoveNoDraw()
end

--[[
	Author: Ractidous
	Date: 13.02.2015.
	Stop a sound on the target unit.
]]
function StopSound( event )
	StopSoundEvent( event.sound_name, event.target )
end



function HideCaster2( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius",level)
	local point = caster:GetAbsOrigin()
	local units = FindAlliesInRadiusExdd(caster,point,radius)

	local sl = 0
	for key, unit in pairs(units) do
		if sl < 6 then
			if  caster:IsAlive() then
				sl = sl +1
				caster:PerformAttack(unit, true, true, true, false, true, false, true)
			end
		else
			return nil 
		end
	end
end