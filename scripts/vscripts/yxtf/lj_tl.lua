
function tl( keys )
	local caster = keys.caster
	local ability= keys.ability
	local lv = caster:GetLevel()
	local level =  ability:GetLevel() - 1
	local gold = ability:GetLevelSpecialValueFor("gold", level) 
	gold = gold * lv * (1+level/5)
	

	PopupNum:PopupGoldGain(caster,gold)
	PlayerUtil.ModifyGold(caster,gold)

end


function tlgj( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local playerID = caster:GetPlayerOwnerID()
	local xj = PlagueLand:GetNowGold(playerID)
	local level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("damage", level)	/100
	local x = 1 + level / 10
	damage = xj*damage *x
	ApplyDamageEx(caster,target,ability,damage)
end

