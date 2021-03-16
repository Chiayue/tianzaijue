function lr_lvlup( keys )
	
	local hero = keys.caster
	local id = hero:GetPlayerOwnerID()
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("zhw",level)  
	local zhwsh = hero.zhwsh
	if not hero.cas_table then
		hero.cas_table = {}
	end
	local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
 	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
	netTable["zhwsh"] = netTable["zhwsh"] + i
	SetNetTableValue("UnitAttributes",unitKey,netTable)
end
