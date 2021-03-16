function sszg( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseHeal = keys.ability:GetLevelSpecialValueFor("baseHeal", keys.ability:GetLevel() - 1)	
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel()-1)
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = target:GetAbsOrigin()
	local ll = caster:GetPrimaryStatValue()
	if caster.sszg_baseHeal == nil then
		caster.sszg_baseHeal = 0
	end
	if caster.sszg_heal == nil then
		caster.sszg_heal = 0
	end
	if caster.sszg_multiple == nil then
		caster.sszg_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.sszg_multiple + multiple
	end	  
	local baseHeal2 = baseHeal + caster.sszg_baseHeal
	local heal = (ll * (i+caster.sszg_heal) + baseHeal2 ) * x * multiple
	target:Heal(heal, caster)
	
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,heal)
	local units = FindAlliesInRadiusExdd(target,point,radius)
	if units ~= nil then
	for key, unit in pairs(units) do
		
		ApplyDamageMf(caster,unit,ability,heal)
		
		end
	end	

end


