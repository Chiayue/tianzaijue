function yg8dxwk( keys )
	
	local caster = keys.caster
	if not caster:IsAlive() or caster then return nil end
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)
	
	ApplyDamageMf(caster,target,ability,damage) 
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end