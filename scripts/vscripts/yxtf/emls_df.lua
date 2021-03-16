function emls_df( keys )
	
	local hero = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i",level)  
	if not hero.cas_table then
		hero.cas_table = {}
	end
	local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
 	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
	netTable["shhm"] = netTable["shhm"] + i
	SetNetTableValue("UnitAttributes",unitKey,netTable)



end


function ss( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target_location = keys.target_points[1]
	local max_distance = 1500
	local distance = (target_location - caster:GetAbsOrigin()):Length2D()
	if distance >  max_distance then
		distance = max_distance
		target_location = caster:GetAbsOrigin() + (target_location - caster:GetAbsOrigin()):Normalized() * distance
	end
	Teleport(caster,target_location,true)

end



function ewsh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("ii", level)	
	local ll = caster:GetAgility()
	local damage = ll * i 
	ApplyDamageEx(caster,target,ability,damage)
	

end