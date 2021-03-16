
function cyjq( keys )
	
	local caster = keys.caster
	local point =caster:GetAbsOrigin()
	local radius = caster:Script_GetAttackRange()
	local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位
	local ability = keys.ability
--	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability:GetLevel() - 1)	
--	if ability:IsCooldownReady() then
		if units then
			caster:PerformAttack(units[1], true, true, true, false, true, false, true)
		--	ability:StartCooldown(cooldown)
		end
--	end

end

