function frdj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local lv = caster:GetLevel()
	local difficulty =  0.9 + GetGameDifficulty() /10
	lv = (i + lv/5) *(1+level/5) * difficulty
	local ll = caster:GetBaseStrength() + lv
--	caster:ModifyStrength(i)
	caster:SetBaseStrength(ll)

	end


function frdjsh( keys )

	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local bfb = keys.ability:GetLevelSpecialValueFor("bfb", level)	
	local radius = keys.ability:GetLevelSpecialValueFor("radius",level)	
	local damage = caster:GetMaxHealth() * bfb  
	local point = caster:GetAbsOrigin()
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, point) -- Origin
	local units = FindAlliesInRadiusExdd(caster,point,radius) --寻找玩家的敌对单位
	if units ~= nil then
	for key, unit in pairs(units) do
			ApplyDamageMf(caster,unit,ability,damage)	
		end
	end	
				
	



end



function stgh( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local lv = caster:GetLevel()
	lv = (i + lv/2) *(1+level/2) 
	local modifier = "modifier_yxtfjn_nz_2"
	if caster:HasModifier(modifier) then
		local cs = caster:GetModifierStackCount(modifier,caster) + lv
		caster:SetModifierStackCount(modifier,caster,cs)
	else	
		ability:ApplyDataDrivenModifier(caster,caster,modifier,{})
		caster:SetModifierStackCount(modifier,caster,lv)
	end






end
