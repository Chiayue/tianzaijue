-----------------------------------------------------------------
modifier_lxk = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lxk:IsHidden()
	return true
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_lxk:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}

	return funcs
end

function modifier_lxk:OnCreated( kv )
	-- references
	--self.i = self:GetAbility():GetSpecialValueFor( "i" )
	--self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	
	self:OnRefresh()
	--self.sound = "Hero_Zuus.StaticField"
	if not IsServer() then return end
	-- play effects

end

function modifier_lxk:OnRefresh( kv )
	-- references
	if IsServer() then
		self.particle= "particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf"
		self.i = self:GetAbility():GetSpecialValueFor( "i" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	end
end



function modifier_lxk:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end
	if params.ability:GetAbilityName() =="ability_hero_2" then return end

	local caster = self:GetParent()
	local point = caster:GetAbsOrigin()
	local units = FindEnemiesInRadiusEx(caster,point,self.radius)
	local damage = caster:GetIntellect() * self.i
	local particle = ParticleManager:CreateParticle(self.particle, PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle,1,caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle,2,Vector(self.radius,0,0))
	if units ~= nil then
		for key,unit in ipairs(units) do

			ApplyDamageMf(caster,unit,params.ability,damage)
		end
	end



end
-----------