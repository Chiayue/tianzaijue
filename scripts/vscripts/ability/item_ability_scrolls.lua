-- 获取一个空的技能
local function findEmptyAbility(hero)
	local ability
	for i = 0,4 do
		ability = hero:GetAbilityByIndex(i)
		if ability then
			local name = ability:GetAbilityName()
			if name == "kjn_1"
				or name=="kjn_2"
				or name=="kjn_3"
				or name=="kjn_4"
				or name=="kjn_5"
				or name=="kjn_6"
			 then

				return i
			end
		end
	end
	return nil
end

function AddAbility(keys)
	local caster = keys.caster
	if not caster:IsRealHero() then return end
	local playerID = caster:GetPlayerID()
	local ability = keys.ability
	local abilityName = string.sub(ability:GetAbilityName(), 6)

	local playerAbility = caster:FindAbilityByName(abilityName)
	if playerAbility then
		if
		 playerAbility:GetLevel() >= playerAbility:GetMaxLevel() then
			
		NotifyUtil.BottomUnique(playerID,"#ability_high",5,"#FFDB77")
		else
			local charges = ability:GetCurrentCharges() - 1
			if charges <= 0 then
				ability:RemoveSelf()
			else
				ability:SetCurrentCharges(charges)
			end
			NotifyUtil.BottomUnique(playerID,"#ability_ts",6,"#FFDB77")
			playerAbility:UpgradeAbility(true)
		end
	else
		local i = findEmptyAbility(caster)
		if not i then
			NotifyUtil.ShowError(playerID,"#ability_full")
			return
		end
		local emptyAbility =  caster:GetAbilityByIndex(i):GetAbilityName()
		local charges = ability:GetCurrentCharges() - 1
		if charges <= 0 then
			ability:RemoveSelf()
		else
			ability:SetCurrentCharges(charges)
		end
		NotifyUtil.BottomUnique(playerID,"#ability_cg",3,"#FFDB77")
		
		local ability = caster:AddAbility(abilityName)
		ability:SetLevel(1)
		caster:SwapAbilities(abilityName,emptyAbility,true,true)
		caster:RemoveAbility(emptyAbility)
		
		if caster:HasModifier("modifier_bw_all_3") and not ability:IsHidden() and not ability:IsPassive() then
			ability:SetActivated(false)
		end
	end
end

