


function sd( keys )
	
	local caster = keys.caster
	local ability = keys.ability

	if ability:IsCooldownReady() then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_tidebringer_splash_datadriven",nil)
	end

end


function sd2(keys)
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetCooldown(ability:GetLevel()-1)
	if caster.sd_interval == nil then
		caster.sd_interval = 0
	end
	cooldown =  cooldown - caster.sd_interval 
	if cooldown <= 0.2 then
		cooldown = 0.2
	end
	ability:StartCooldown(cooldown)
end
