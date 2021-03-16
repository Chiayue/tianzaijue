--[[Author: Pizzalol
	Date: 26.01.2016.
	Checks if the target is being siphoned from already]]
function SpiritSiphonCheck( keys )
	local caster = keys.caster
	local target = keys.target
	local modifier = keys.modifier

	-- Stop the caster from casting if the target has the modifier already
	if target:HasModifier(modifier) then
		caster:Interrupt()
	end
end

--[[Author: Pizzalol
	Date: 26.01.2016.
	Checks for leash range, deals damage to the target and heals the caster]]
function SpiritSiphon( keys )
	local caster = keys.caster
	local target = keys.target
	if not caster:IsAlive() then
		if target:HasModifier("modifier_spirit_siphon_datadriven") then
			target:RemoveModifierByName("modifier_spirit_siphon_datadriven")
			return nil
		end
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local bfb = ability:GetLevelSpecialValueFor("bfb", level)
	local i = ability:GetLevelSpecialValueFor("i", level)
	local zl = caster:GetIntellect()
	local damage = (caster:GetMaxHealth()*bfb/100 + i*zl)*(1+level/2) 

	ApplyDamageMf(caster,target,ability,damage)
	caster:Heal(damage*0.01,caster)
end







function xhws1( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local duration = ability:GetLevelSpecialValueFor("duration", level)
	local point =caster:GetAbsOrigin()
	local units = FindAlliesInRadiusExdd(caster,point,radius)
	if units then
		for k,unit in pairs(units) do
			if not unit:HasModifier("modifier_spirit_siphon_datadriven") then 
				ability:ApplyDataDrivenModifier(caster,unit,"modifier_spirit_siphon_datadriven",{duration=duration})
				return nil
			end
		end
		
	end
end