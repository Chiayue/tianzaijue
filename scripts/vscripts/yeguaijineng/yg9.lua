function yg9zj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)*1.5
	
	ApplyDamageEx(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end

function yg9zj2( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetBaseDamageMin() *6
	
	ApplyDamageEx(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end