function zxgh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local reduce_armor =ability:GetLevelSpecialValueFor("reduce_armor", level)	
	local reduce_magical =ability:GetLevelSpecialValueFor("reduce_magical", level)	
	local armor = math.floor(target:GetPhysicalArmorBaseValue() * reduce_armor / 100)
	local magical = math.floor(target:GetBaseMagicalResistanceValue() * reduce_magical / 100)
	local modifier = ability:ApplyDataDrivenModifier(caster,target,"modifier_yxtfjn_sgjs",{})
	local modifier2 = ability:ApplyDataDrivenModifier(caster,target,"modifier_yxtfjn_sgjs_2",{})
	modifier:SetStackCount(armor)
	modifier2:SetStackCount(magical)

end



