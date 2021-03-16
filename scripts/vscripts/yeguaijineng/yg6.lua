function yg6chongfeng( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability


	local damage = caster:GetBaseMoveSpeed() / 200 * caster:GetAverageTrueAttackDamage(caster)
	
	ApplyDamageEx(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	   		

end
