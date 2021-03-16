function zpsl_lvlup( keys )
	
	local hero = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i",level)  
	if not hero.cas_table then
		hero.cas_table = {}
	end
	local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
 	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
	netTable["nljszjbfb"] = netTable["nljszjbfb"] + i 
	SetNetTableValue("UnitAttributes",unitKey,netTable)



end
