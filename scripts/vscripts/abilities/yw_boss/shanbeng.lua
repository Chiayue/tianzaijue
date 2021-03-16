function sb(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel() - 1)
	local damage = caster:GetBaseDamageMax() *0.5
	local vPos =ability:GetCursorPosition()
	local point = keys.caster:GetAbsOrigin()
	local direction = (vPos-point ):Normalized()
	local duration = 3
	TimerUtil.createTimer(function ()
		if duration > 0 then
			for i=1,4 do
				local avalanche = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN,caster)
				ParticleManager:SetParticleControl(avalanche, 0, vPos)
				ParticleManager:SetParticleControl(avalanche, 1, Vector(radius, 1,250))	
				ParticleManager:SetParticleControlForward( avalanche, 0, direction )
				TimerUtil.createTimerWithDelay(0.2, function()
						ParticleManager:DestroyParticle(avalanche, false)
					--	ParticleManager:ReleaseParticleIndex(avalanche)
					end)
			end
		local units = FindAlliesInRadiusExdd(caster, vPos,radius)
			for key,unit in ipairs(units) do
				ApplyDamageMf(caster,unit,ability,damage)
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_yw_boss_sb", {duration = 0.1})
			end			
			duration = duration - 0.4
			return 0.4
		 end
	end)
end
