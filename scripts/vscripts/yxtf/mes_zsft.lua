
function zstf( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability:GetLevel() - 1)	
	if ability:IsCooldownReady() then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_yxtfjn_mes_2",{})
		ability:StartCooldown(cooldown)
	end

end




function zsftmxc( keys )
	
	local caster = keys.caster

	local dx = caster:GetModelScale() *1.5


	caster:SetModelScale(dx) 


end

function zsftmxr( keys )
	
	local caster = keys.caster

	local dx = caster:GetModelScale() /1.5


	caster:SetModelScale(dx) 


end



function zsft( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)	
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local point = target:GetAbsOrigin()
	local vPos = caster:GetAbsOrigin()
	local direction = (point-vPos ):Normalized()
	local p1 = ParticleManager:CreateParticle("particles/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(p1, 0, point) -- Origin
	ParticleManager:SetParticleControl(p1, 1, Vector(radius+100,radius,radius)) -- Origin
	ParticleManager:SetParticleControlForward(p1,1,direction)
--	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "", hCaster:GetOrigin(), true )
-- 	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius,1,1)  )
 	ParticleManager:ReleaseParticleIndex(p1)
 	StartSoundEventFromPosition("Hero_Mars.Shield.Cast",point)--这个是双头龙液体火命中敌人的声音
	local damage = caster:GetAverageTrueAttackDamage(caster) * i
 	local units = FindAlliesInRadiusExdd(caster,point,radius)
	for key, unit in pairs(units) do
		ApplyDamageEx(caster,unit,ability,damage)	
	end
	

end

