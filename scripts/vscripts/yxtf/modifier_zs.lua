-----------------------------------------------------------------
modifier_zs = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zs:IsHidden()
	return true
end

function modifier_zs:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}

	return funcs
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_zs:OnCreated( kv )
	-- references
	self.i = self:GetAbility():GetSpecialValueFor( "i" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.particle= "particles/units/heroes/hero_zuus/zuus_static_field.vpcf"
	self.sound = "Hero_Zuus.StaticField"
	if not IsServer() then return end
	-- play effects

end

function modifier_zs:OnRefresh( kv )
	-- references
	self.i = self:GetAbility():GetSpecialValueFor( "i" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end



function modifier_zs:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end
	if params.ability:GetAbilityName() =="ability_hero_2" then return end

	local caster = self:GetParent()
	local point = caster:GetAbsOrigin()
	local units = FindEnemiesInRadiusEx(caster,point,self.radius)
	local zl = caster:GetIntellect()
	if units ~= nil then
		for key,unit in ipairs(units) do
			-- Attaches the particle
			local particle = ParticleManager:CreateParticle(self.particle, PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:SetParticleControl(particle,0,unit:GetAbsOrigin())
			-- Plays the sound on the target
			EmitSoundOn(self.sound, unit)
			-- Deals the damage based on the unit's current health
			local smz = unit:GetHealth()
			damage =  smz * self.i /100 +  zl
			ApplyDamageMf(caster,unit,ability,damage)
		end
	end



end
--------------------------------------------------------------------------------
