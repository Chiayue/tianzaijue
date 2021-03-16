-----------------------------------------------------------------
modifier_hdsn = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hdsn:IsHidden()
	return true
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_hdsn:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}

	return funcs
end

function modifier_hdsn:OnCreated( kv )
	-- references
	self:OnRefresh()
	--self.sound = "Hero_Zuus.StaticField"
	if not IsServer() then return end
	-- play effects

end

function modifier_hdsn:OnRefresh( kv )
	-- references
	if IsServer() then
		self.particle= "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_cast_ti6_combined.vpcf"
		self.i = self:GetAbility():GetSpecialValueFor( "i" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	end
end



function modifier_hdsn:OnAbilityExecuted( params )
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
	local particle = ParticleManager:CreateParticle(self.particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle,0,caster:GetAbsOrigin())
	--ParticleManager:SetParticleControl(particle,4,caster:GetAbsOrigin())
	--ParticleManager:SetParticleControl(particle,2,Vector(self.radius,0,0))
	if units ~= nil then
		for key,unit in ipairs(units) do
			if unit.isAttackBoss then 
				AddLuaModifier(caster,unit,"modifier_hdsn_debuff",{duration=self.duration/3},params.ability)
				ApplyDamageMf(caster,unit,params.ability,damage)
			else
				AddLuaModifier(caster,unit,"modifier_hdsn_debuff",{duration=self.duration},params.ability)
				ApplyDamageMf(caster,unit,params.ability,damage)
			end
			
		end
	end



end
-----------