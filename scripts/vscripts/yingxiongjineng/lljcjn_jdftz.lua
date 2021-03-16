function jdftz( keys )
	local caster = keys.caster
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local count = keys.ability:GetLevelSpecialValueFor("count", keys.ability:GetLevel())
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = keys.target_points[1]
	local path = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf"
	local ll = caster:GetStrength()
	local 	damage = ll * i * x




	TimerUtil.createTimer(function()
		if count > 0 then

	local pos = RandomPosInRadius(point,radius)		
	local units = FindAlliesInRadiusExdd(caster,pos,100)
	local pid = CreateParticleEx(path,PATTACH_ABSORIGIN,caster)
	SetParticleControlEx(pid,0,pos)		
	if units ~= nil then
		for key, unit in pairs(units) do
			ApplyDamageEx(caster,unit,ability,damage)
			ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
		end
	end	
	
		count = count - 1
			return 0.05
		end
	end)	

end
