function ggyx_lvlup( keys )
	
	local hero = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i",level)  
	if not hero.cas_table then
		hero.cas_table = {}
	end
	local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
 	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
	netTable["sjjmj"] = netTable["sjjmj"] + i
	SetNetTableValue("UnitAttributes",unitKey,netTable)



end



function fx( keys )
	
	local caster = keys.caster
	local target = keys.target
	if not caster:IsAlive() then
		return nil 
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local point = target:GetAbsOrigin()
	local point2 = caster:GetAbsOrigin()
	local fv = GetForwardVector(point2,point)
	local projectileTable =
	{
		EffectName = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_combo.vpcf",
		Ability = ability,
		vSpawnOrigin = point2,
		vVelocity = fv * 2000,
		fDistance = 2000,
		fStartRadius = 250,
		fEndRadius = 250,
		Source = caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
	}
	ProjectileManager:CreateLinearProjectile( projectileTable )
end
function fxsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("damage", level)	
	local x = 1 + level / 2
	local damage = caster:GetAverageTrueAttackDamage(caster)*damage *x
	ApplyDamageEx(caster,target,ability,damage)


end

function jzhl(keys)
	local caster = keys.caster
	local target = keys.target
	if  caster:IsAlive() then
		caster:PerformAttack(target, true, true, true, false, true, false, true)
	end
end