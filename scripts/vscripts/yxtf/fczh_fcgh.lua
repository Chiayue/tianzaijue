function fcgh_lvlup( keys )
	
	local hero = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i",level)  
	if not hero.cas_table then
		hero.cas_table = {}
	end
	local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
 	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
	netTable["swfhsj"] = netTable["swfhsj"] - i
	SetNetTableValue("UnitAttributes",unitKey,netTable)



end




function fcgh(keys )
	local caster = keys.caster
	local unitdie = keys.unit
	if not unitdie:IsHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = caster:GetLevel() /2 
	local i = ability:GetLevelSpecialValueFor("zjqsx",level)  
	i = (lv + i) * (1+level/5)
	
		local ll = caster:GetBaseStrength() + i 
		caster:SetBaseStrength(ll)
		local mj = caster:GetBaseAgility() + i 
		caster:SetBaseAgility(mj)
		local zl = caster:GetBaseIntellect() + i 
		caster:SetBaseIntellect(zl)
		caster:CalculateStatBonus(true)-- 英雄死亡的时候，刷新属性还没用
	
	
end