function yg21smqq( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage =  caster:GetAverageTrueAttackDamage(caster)
	local heal = damage*5
	ApplyDamageMf(caster,target,ability,damage)
	caster:Heal(heal,caster)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end



function yg32smqq( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage =  caster:GetAverageTrueAttackDamage(caster)
	local heal = damage*12.5
	ApplyDamageMf(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end