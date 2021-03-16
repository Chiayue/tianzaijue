function ymjd(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = ability:GetCursorPosition()
	local sh = ability:GetLevelSpecialValueFor("sh", ability:GetLevel())
	local damage = caster:GetAgility() *sh 

	
	local i = 0
	local p1 = ParticleManager:CreateParticle("particles/econ/items/viper/viper_immortal_tail_ti8/viper_immortal_ti8_nethertoxin.vpcf",PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl( p1, 0, point )
	TimerUtil.createTimer(function()
		i = i+1
		if i > 10 then
			ParticleManager:DestroyParticle(p1,false)
			return nil	
		end	
		local units = FindEnemiesInRadiusEx(caster,point,500)
		for key, unit in pairs(units) do
			ApplyDamageEx(caster,unit,ability,damage)
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_yxtfjn_jdsw", {})
		end
		return 1
	end	)
end