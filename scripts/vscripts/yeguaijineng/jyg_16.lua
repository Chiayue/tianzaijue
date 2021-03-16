function jyg_16( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local reduce_armor =ability:GetLevelSpecialValueFor("reduce_armor", level)	
	local armor = math.ceil(target:GetPhysicalArmorBaseValue() * reduce_armor / 100)
	local modifier = ability:ApplyDataDrivenModifier(caster,target,"modifier_jyg_16_3",{})
	modifier:SetStackCount(armor)


end



