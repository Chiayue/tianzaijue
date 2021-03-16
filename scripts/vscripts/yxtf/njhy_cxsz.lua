function cxsz_lvlup( keys )
	
	local hero = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i",level)  
	if not hero.cas_table then
		hero.cas_table = {}
	end
	local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
 	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
	netTable["sjjmj"] = netTable["sjjmj"] + i
	SetNetTableValue("UnitAttributes",unitKey,netTable)



end



function jl( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local damage = keys.ability:GetLevelSpecialValueFor("damage", level)	
	local radius = keys.ability:GetLevelSpecialValueFor("radius",level)	
	 damage = caster:GetAgility()* damage  *(1+level/5)
	local point = caster:GetAbsOrigin()
	local particle = ParticleManager:CreateParticle("particles/econ/items/naga/naga_ti8_immortal_tail/naga_ti8_immortal_riptide.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, point) -- Origin
	ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius)) -- Origin
	local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位
	if units ~= nil then
	for key, unit in pairs(units) do
			ApplyDamageEx(caster,unit,ability,damage)	
			ability:ApplyDataDrivenModifier(caster,unit,"modifier_yxtfjn_njhy_2",{})
		end
	end	
end

