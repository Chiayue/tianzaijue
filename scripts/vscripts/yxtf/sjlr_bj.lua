
function bj( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	if ability:IsCooldownReady() then

		local max =  keys.ability:GetLevelSpecialValueFor("max", keys.ability:GetLevel() - 1)	
		local radius =  keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel() - 1)	
		local units = FindAlliesInRadiusExdd(caster,caster:GetAbsOrigin(),radius)
		local a =1

		if units ~= nil then
			for key, unit in pairs(units) do
				if a<= max  then
					a = a+1
					ability:ApplyDataDrivenModifier(caster,unit,"modifier_yxtfjn_sjlr",{})
					ApplyDamageMf(caster,unit,ability,damage)
					local cooldown = ability:GetCooldown(ability:GetLevel()-1)
					ability:StartCooldown(cooldown)
				end
			end
		end	

		
	end
	




end

function sj( keys )
	local unit = keys.unit
	local attacker = keys.attacker
	local ability = keys.ability
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local gold  = unit:GetMaximumGoldBounty() * i 
	PopupNum:PopupGoldGain(attacker,gold)
	PlayerUtil.ModifyGold(attacker,gold)
end