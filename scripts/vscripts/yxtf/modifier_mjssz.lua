-----------------------------------------------------------------
modifier_mjssz = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mjssz:IsHidden()
	return true
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mjssz:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

function modifier_mjssz:OnCreated( kv )
	-- references
	
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.particle= "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_loadout.vpcf"
	--self.sound = "Hero_Zuus.StaticField"
	if not IsServer() then return end
	-- play effects

end

function modifier_mjssz:OnRefresh( kv )
	-- references
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
end



function modifier_mjssz:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end
	if params.ability:GetAbilityName() =="ability_hero_2" then return end
	if RollPercent(self.chance)  then
		local caster = self:GetParent()
		local point = caster:GetAbsOrigin()
		local particle = ParticleManager:CreateParticle(self.particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle,0,caster:GetAbsOrigin())
		caster:AddNewModifier( caster, nil, "modifier_mjssz2", {} )
	end



end
-----------