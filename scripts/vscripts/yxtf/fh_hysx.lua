
function hysx( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)	

	local units = FindAlliesInRadiusExdd(caster,caster:GetAbsOrigin(),radius)
	if units then
		ability:ApplyDataDrivenModifier(caster,units[1],"modifier_yxtfjn_hysx",{})
	end

end


function hysxsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i",level)	
	local damage = ability:GetLevelSpecialValueFor("baseDamage",level)	
	
	damage = (caster:GetStrength() * i  +damage) * (1+level/5)
	ApplyDamageMf(caster,target,ability,damage)

end



