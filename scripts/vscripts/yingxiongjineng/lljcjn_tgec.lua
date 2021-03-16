function tgec( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseHeal = keys.ability:GetLevelSpecialValueFor("baseHeal", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10

	local ll = caster:GetStrength()

	if caster.tgec_baseHeal == nil then
		caster.tgec_baseHeal = 0
	end
	if caster.tgec_heal == nil then
		caster.tgec_heal = 0
	end
	local baseHeal2 = baseHeal + caster.tgec_baseHeal
	heal = (ll * (i+caster.tgec_heal) + baseHeal2 ) * x


		
		target:Heal(heal, caster)
		
		ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,heal)
		


end


function addtgec( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = keys.ability:GetLevelSpecialValueFor("duration", keys.ability:GetLevel() - 1)	
	if caster.tgec_duration == nil then
		caster.tgec_duration = 0
	end
	duration = duration +  caster.tgec_duration
	ability:ApplyDataDrivenModifier(caster, target, "modifier_repel_datadriven", {duration=duration})
end

