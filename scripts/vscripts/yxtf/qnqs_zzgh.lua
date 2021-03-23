function zzgh_lvlup( keys )
	
	local hero = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i",level)  
	if not hero.cas_table then
		hero.cas_table = {}
	end
	local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
 	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
	netTable["shjm"] = netTable["shjm"] + i
	SetNetTableValue("UnitAttributes",unitKey,netTable)



end




function qn_sszg( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	if not ability:IsCooldownReady() then
		return nil
	end
	local level = ability:GetLevel() - 1
	local heal = ability:GetLevelSpecialValueFor("heal", level)	
	local radius = ability:GetLevelSpecialValueFor("radius2", level)
	local cooldown = ability:GetCooldown(level)
	local x = 1 + level / 10
	local point = caster:GetAbsOrigin()
	heal = caster:GetStrength()*heal *x
	if heal > 100000000 then
		heal = 100000000
	end
	local units = FindAlliesInRadiusEx(caster,point,radius)
	local particleName = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
	if units ~= nil then
		for key, unit in pairs(units) do
			if unit:IsHero() then
				local fxIndex = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, unit )
				ParticleManager:SetParticleControl( fxIndex, 0, point )
				ParticleManager:SetParticleControl( fxIndex, 1, Vector(100,100,100) )
				caster:Heal(heal, unit)
			end
		end
	end	
	ability:StartCooldown(cooldown)
end


