
function swcc( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local point =caster:GetAbsOrigin()
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位
	for key, unit in pairs(units) do
		caster:PerformAttack(unit, true, true, true, false, true, false, true)
	end
end

