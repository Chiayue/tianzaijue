function zlsw( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel() - 1)
	local duration = keys.ability:GetLevelSpecialValueFor("duration", keys.ability:GetLevel() - 1)
	local interval = keys.ability:GetLevelSpecialValueFor("interval", keys.ability:GetLevel() - 1)
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
    local point = ability:GetCursorPosition()

	local zl = caster:GetIntellect()

	if caster.tgec_baseHeal == nil then
		caster.tgec_baseHeal = 0
	end
	if caster.tgec_heal == nil then
		caster.tgec_heal = 0
	end
	local baseHeal2 = baseHeal + caster.tgec_baseHeal
	heal = (zl * (i+caster.tgec_heal) + baseHeal2 ) * x

   local nowtime=0
	TimerUtil.createTimer(function()
		nowtime=nowtime+1
		if nowtime <= duration then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for i,unit in pairs(units) do	
			unit:Heal(heal, caster)
		
			ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,heal)
		end
		return interval
		end
		return nil
	end)
	

end
