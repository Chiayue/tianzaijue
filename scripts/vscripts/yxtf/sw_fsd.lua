function fsd( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	if target:FindModifierByName("modifier_yxtfjn_shawang_2") then return nil end
	ability:ApplyDataDrivenModifier(caster,target,"modifier_yxtfjn_shawang_2",{})

	
end


function fsd2( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local bfb = ability:GetLevelSpecialValueFor("bfb", level)
	local damage = caster:GetMaxHealth()*bfb/100 *(1+level/2) 
	local point =target:GetAbsOrigin()
	local units = FindAlliesInRadiusExdd(caster,point,radius)
	local particleName = "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf"
	local soundEventName = "Ability.SandKing_CausticFinale"
	
	local fxIndex = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN,target )
	StartSoundEvent( soundEventName, target )
	if units ~= nil then
		for key, unit in pairs(units) do
			if unit ~=target  then
				ability:ApplyDataDrivenModifier(caster,unit,"modifier_yxtfjn_shawang_2",{})
				ApplyDamageMf(caster,unit,ability,damage)	
			end
		end
	end	
	
end