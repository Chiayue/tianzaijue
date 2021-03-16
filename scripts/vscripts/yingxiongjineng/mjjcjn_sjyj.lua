function sjyj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	local max = keys.ability:GetLevelSpecialValueFor("max", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	
	if caster.sjyj_baseDamage == nil then
		caster.sjyj_baseDamage = 0
	end
	if caster.sjyj_damage == nil then
		caster.sjyj_damage = 0
	end
	if caster.sjyj_max == nil then
		caster.sjyj_max = 0
	end
	if caster.sjyj_interval == nil then
		caster.sjyj_interval = 0
	end
	if caster.sjyj_multiple == nil then
		caster.sjyj_multiple = 0
	end


	ability:ApplyDataDrivenModifier(target,target,"modifier_mjjcjn_sjyj_2",{})
	local cs = max + math.floor(level / 2 + caster.sjyj_max)	
	target:SetModifierStackCount("modifier_mjjcjn_sjyj_2", target, cs)
	

	local mj = caster:GetAgility()
	local baseDamage2 = baseDamage + caster.sjyj_baseDamage
	i = i + caster.sjyj_damage
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.sjyj_multiple + multiple
	end	 
	local damage = (mj * i + baseDamage2 ) * x * multiple

	ApplyDamageEx(caster,target,ability,damage)
	
	local cooldown = ability:GetCooldown(ability:GetLevel()-1)
	cooldown =  cooldown - caster.sjyj_interval 
	if cooldown <= 0.5 then
		cooldown = 0.5
	end
	ability:StartCooldown(cooldown)

end



function sjyj2( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.modifier
	if ability:IsCooldownReady() then
		ability:ApplyDataDrivenModifier(caster,caster,modifier,nil)
	end

end

function sjyj3(keys)
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetCooldown(ability:GetLevel()-1)
	ability:StartCooldown(cooldown)
end