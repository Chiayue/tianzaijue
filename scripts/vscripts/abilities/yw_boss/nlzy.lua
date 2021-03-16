function nlzy(keys)
	
		--For the affected enemy, increment their visible counter modifier's stack count.
		local previous_stack_count = 0
		if keys.target:HasModifier("modifier_yw_boss_nlzy_5") then
			previous_stack_count = keys.target:GetModifierStackCount("modifier_yw_boss_nlzy_5", keys.caster)
			
			--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
			keys.target:RemoveModifierByNameAndCaster("modifier_yw_boss_nlzy_5", keys.caster)
		end
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_yw_boss_nlzy_5", nil)
		keys.target:SetModifierStackCount("modifier_yw_boss_nlzy_5", keys.caster, previous_stack_count + 1)		
		
		--Apply a stat debuff to the target StatLoss number of times.  Attributes bottom out at 0, so we do not need to worry about
		--applying more debuffs than attribute points the target currently has.  This is the way the stock Essence Shift works.
		local i = 0
		local stat_loss_abs = math.abs(keys.StatLoss)
		while i < stat_loss_abs do
			keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_yw_boss_nlzy_3", nil)
			i = i + 1
		end
		
		--For Slark, update his visible counter modifier's stack count and duration, and raise his Agility.  The full amount of Agility is gained
		--even if the target does not have any more attributes to steal.
		previous_stack_count = 0
		if keys.caster:HasModifier("modifier_yw_boss_nlzy_4") then
			previous_stack_count = keys.caster:GetModifierStackCount("modifier_yw_boss_nlzy_4", keys.caster)
			
			--We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
			keys.caster:RemoveModifierByNameAndCaster("modifier_yw_boss_nlzy_4", keys.caster)
		end
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_yw_boss_nlzy_4", nil)
		keys.caster:SetModifierStackCount("modifier_yw_boss_nlzy_4", keys.caster, previous_stack_count + 1)
		
		--Apply an Agility buff for Slark.
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_yw_boss_nlzy_2", nil)
	
end


--[[ ============================================================================================================
	Author: Rook
	Date: January 28, 2015
	Called whenever an Essence Shift debuff on an opponent expires.  Decrements their debuff counter by one.
================================================================================================================= ]]
function nlzy_debuff_destroy(keys)
	if keys.target:HasModifier("modifier_yw_boss_nlzy_5") then
		local previous_stack_count = keys.target:GetModifierStackCount("modifier_yw_boss_nlzy_5", keys.caster)
		if previous_stack_count > 1 then
			keys.target:SetModifierStackCount("modifier_yw_boss_nlzy_5", keys.caster, previous_stack_count - 1)
		else
			keys.target:RemoveModifierByNameAndCaster("modifier_yw_boss_nlzy_5", keys.caster)
		end
	end
end


--[[ ============================================================================================================
	Author: Rook
	Date: January 28, 2015
	Called whenever an Essence Shift buff on Slark expires.  Decrements his buff counter by one.
================================================================================================================= ]]
function nlzy_buff_destroy(keys)
	if keys.caster:HasModifier("modifier_yw_boss_nlzy_4") then
		local previous_stack_count = keys.caster:GetModifierStackCount("modifier_yw_boss_nlzy_4", keys.caster)
		if previous_stack_count > 1 then
			keys.caster:SetModifierStackCount("modifier_yw_boss_nlzy_4", keys.caster, previous_stack_count - 1)
		else
			keys.caster:RemoveModifierByNameAndCaster("modifier_yw_boss_nlzy_4", keys.caster)
		end
	end
end