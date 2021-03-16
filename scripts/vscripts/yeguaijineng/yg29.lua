function yg29jdsw(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]

	local damage = caster:GetAverageTrueAttackDamage(caster) *2 

	
	local i = 0
	local p1 = ParticleManager:CreateParticle("particles/econ/items/viper/viper_immortal_tail_ti8/viper_immortal_ti8_nethertoxin.vpcf",PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl( p1, 0, point )
	TimerUtil.createTimer(function()
		i = i+1
		if i > 10 then
			ParticleManager:DestroyParticle(p1,false)
			return nil	
		end	
		
		local units = FindEnemiesInRadiusEx(TEAM_ENEMY,point,500)
		for key, unit in pairs(units) do
			ApplyDamageMf(caster,unit,ability,damage)
			if EntityIsAlive(caster) then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_yg29_1", {})
			end
		end
		return 1
	end	)
end



function yg29zibao( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	
	
	local point = caster:GetAbsOrigin()

	local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf",PATTACH_CUSTOMORIGIN,caster)
    ParticleManager:SetParticleControl( p1, 0, point )

	--print_r(keys)

	local units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
	if units ~= nil then
	local damage = caster:GetAverageTrueAttackDamage(caster)* 10
	for key, unit in pairs(units) do
		ApplyDamageMf(caster,unit,ability,damage)
		ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	--	ApplyDamageEx(caster,unit,ability,damage)
	--	ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
		

		end
	end	
	

end


function yg29dxgj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage =  caster:GetAverageTrueAttackDamage(caster) * 1.2
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end


