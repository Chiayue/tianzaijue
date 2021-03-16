function flsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if target:GetMana() >= 1 then
	local reduce = target:GetMana()*0.1
	target:ReduceMana(reduce)
	local damage = reduce * caster:GetAverageTrueAttackDamage(caster) * 0.05
	
	ApplyDamageEx(caster,target,ability,damage)
	--显示一个特殊效果
	ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,reduce)
	  end

end


