function zh( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local lv = caster:GetLevel()
	local level = ability:GetLevel() - 1
	local i = ability:GetLevelSpecialValueFor("i", level)
	local difficulty =  0.9 + GetGameDifficulty() /10
	i = (i + lv/5)*(1+level/5) * difficulty
	local ll = caster:GetBaseIntellect() + i
	caster:SetBaseIntellect(ll)

	end


