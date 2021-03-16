function yg23hunluan( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage =  caster:GetAverageTrueAttackDamage(caster)* 2.5
	
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end