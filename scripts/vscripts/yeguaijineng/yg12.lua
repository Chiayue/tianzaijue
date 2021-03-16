function yg12dygj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if EntityIsAlive(caster) then	--如果目标存活，则重新选取目标点
		local damage = caster:GetAverageTrueAttackDamage(caster)*0.5
		ApplyDamageMf(caster,target,ability,damage)
		--显示一个特殊效果
		ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	end
	   		

end