function jyg_17( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local reduce_magical =ability:GetLevelSpecialValueFor("reduce_magical", level)	
	local magical = math.ceil(target:GetBaseMagicalResistanceValue() * reduce_magical / 100)
	if magical >= 100 then
		magical = 99
	end
	local modifier = ability:ApplyDataDrivenModifier(caster,target,"modifier_jyg_17_4",{})
	modifier:SetStackCount(magical)

end



