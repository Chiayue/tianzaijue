
function sy( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevelSpecialValueFor("level", ability:GetLevel() - 1)	
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability:GetLevel() - 1)	
	if ability:IsCooldownReady() then
		local item = CreateItem("item_xhp_wzts_"..level, caster, caster)
		caster:AddItem(item)		
		ability:StartCooldown(cooldown)
	end

end



