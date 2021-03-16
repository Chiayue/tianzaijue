

function tykj_bgjhx( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("bgjhx", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	caster:Heal(i,caster)
		

end



