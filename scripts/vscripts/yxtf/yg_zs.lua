
function zs( keys )
	local caster = keys.caster
	local ability= keys.ability
	local target = keys.attacker
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel())
	local i = ability:GetLevelSpecialValueFor("i", ability:GetLevel())
	local point = caster:GetAbsOrigin()
	local units = FindEnemiesInRadiusEx(caster,point,radius)
	local damage = caster:GetHealth() * i 
	if units ~= nil then
		for key, unit in pairs(units) do		
			local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_dispersion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(p1, 0, point) -- Origin
			ParticleManager:SetParticleControl(p1, 1, unit:GetAbsOrigin()) -- Origin
			ApplyDamageEx(caster,unit,ability,damage)
		end
	end


end


function yg_lvlup( keys )
	
	local hero = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local jsxs2 = ability:GetLevelSpecialValueFor("jsxs2",level)  
	if not hero.cas_table then
		hero.cas_table = {}
	end
	local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
 	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
	netTable["shjm"] = netTable["shjm"] + jsxs2 
	SetNetTableValue("UnitAttributes",unitKey,netTable)



end
