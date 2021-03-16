--[[
	CHANGELIST
	09.01.2015 - Standized the variables
]]

--[[
	Author: kritth
	Date: 7.1.2015.
	Increasing stack after each hit
]]
function fury_swipes_attack( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "modifier_fury_swipes_target_datadriven"
	local damageType = ability:GetAbilityDamageType()

	
	-- Necessary value from KV
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local i = ability:GetLevelSpecialValueFor( "i", ability:GetLevel() - 1 )
	local max = ability:GetLevelSpecialValueFor( "max", ability:GetLevel() - 1 )

	-- Check if unit already have stack
	if target:HasModifier( modifierName ) then
		local current_stack = target:GetModifierStackCount( modifierName, ability )
		
		-- Deal damage
		local mj = caster:GetAgility()
		local damage = mj * i*current_stack
		ApplyDamageEx(caster,target,ability,damage)

		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		if current_stack < max then
			target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
		end
	else
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, 1 )
		
		-- Deal damage
		local mj = caster:GetAgility()
		local damage = mj * i 
		ApplyDamageEx(caster,target,ability,damage)
	end
end
