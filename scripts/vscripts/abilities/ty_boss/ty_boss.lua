function mwjl( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local reduce_armor =ability:GetLevelSpecialValueFor("reduce_armor", level)	
	local reduce_magical =ability:GetLevelSpecialValueFor("reduce_magical", level)	
	local armor = math.floor(target:GetPhysicalArmorBaseValue() * reduce_armor / 100)
	local magical = math.floor(target:GetMagicalArmorValue() * reduce_magical)
	if magical > 100 then
		magical = 99
	end
	local modifier = ability:ApplyDataDrivenModifier(caster,target,"modifier_ty_boss_4_3",{})
	local modifier2 = ability:ApplyDataDrivenModifier(caster,target,"modifier_ty_boss_4_4",{})
	modifier:SetStackCount(armor)
	modifier2:SetStackCount(magical)

end



function zpsl( event )
	local caster = event.caster
	local target = event.unit
	local modifier = event.modifier
	local ability = event.ability
	local level = ability:GetLevel() - 1

	local souls_gained = 1
	if target:IsRealHero() then
		souls_gained = 5
	end
	local modifier2 = caster:HasModifier(modifier)
	if modifier2 then
		local stacks = caster:GetModifierStackCount(modifier, caster)
		caster:SetModifierStackCount( modifier, ability,stacks+souls_gained )
	else
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		caster:SetModifierStackCount( modifier, ability,souls_gained )
	end

end


function tyzqq( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local units = FindAlliesInRadiusEx(caster,caster:GetAbsOrigin(),1000)

	for k,unit in pairs(units) do
		if not unit.isboss and unit ~= caster then
			local heal = unit:GetMaxHealth()*5
			caster:Heal(heal,caster)
			local armor = math.floor(unit:GetPhysicalArmorBaseValue())*3
			local magical = math.floor(unit:GetBaseMagicalResistanceValue())*0.1
			if caster:HasModifier("modifier_ty_boss_3_3")then
				local stacks = caster:GetModifierStackCount("modifier_ty_boss_3_3", caster)
				caster:SetModifierStackCount( "modifier_ty_boss_3_3", ability,stacks+armor )
			else
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_ty_boss_3_3", {})
				caster:SetModifierStackCount( "modifier_ty_boss_3_3", ability,armor )
			end
			if caster:HasModifier("modifier_ty_boss_3_4")then
				local stacks = caster:GetModifierStackCount("modifier_ty_boss_3_4", caster)+magical
				if stacks>99 then
					stacks = 99
				end
				caster:SetModifierStackCount( "modifier_ty_boss_3_4", ability,stacks )
			else
				if magical>99 then
					magical = 99
				end
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_ty_boss_3_4", {})
				caster:SetModifierStackCount( "modifier_ty_boss_3_4", ability,magical )
			end
			unit:Kill(ability, caster)
			return nil
		end
	end
end