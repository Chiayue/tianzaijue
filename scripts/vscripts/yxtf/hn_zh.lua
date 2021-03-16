function zh( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	--local duration =  keys.ability:GetLevelSpecialValueFor("duration", keys.ability:GetLevel() - 1)
	local level = ability:GetLevel() - 1
	local zl = caster:GetIntellect()
	local point = caster:GetAbsOrigin()
	local is_ability = false
	for i=0, 4 do
		local current_ability = caster:GetAbilityByIndex(i)
		local name = current_ability:GetAbilityName()
		local name2 = string.sub(name,1,3)
		if name2 ~= "kjn" and  name2 ~= "yxt" and name2 ~= "abi" then
			local cd = current_ability:GetCooldownTimeRemaining()		
			local full_cd = current_ability:GetCooldown(level)		--无法获得经过冷却缩减的技能CD，还是有BUG存在
			if cd > 0 and full_cd - cd < 0.1 then 
				is_ability = true
			end
		end
	end
	if is_ability == true then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_yxtfjn_hn_3", {})  
		local cs = caster:FindModifierByName("modifier_yxtfjn_hn_3"):GetStackCount()
		if cs >= 3 then
		
		else
			cs =cs+1
		end
		caster:SetModifierStackCount("modifier_yxtfjn_hn_3", caster, cs)

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_yxtfjn_hn_2", {}) 
		
		caster:SetModifierStackCount("modifier_yxtfjn_hn_2", caster, cs)
	end
end

