LinkLuaModifier("modifier_orge_lrg_3", "abilities/tower/orge_lrg/orge_lrg_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orge_lrg_3_effect", "abilities/tower/orge_lrg/orge_lrg_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if orge_lrg_3 == nil then
	orge_lrg_3 = class({})
end
function orge_lrg_3:Trigger(hTarget, buff_duration)
	if self:GetLevel() <= 0
	or not IsValid(hTarget)
	or not hTarget:IsAlive() then
		return
	end

	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_orge_lrg_3", { duration = buff_duration })
end
---------------------------------------------------------------------
--Modifiers
if modifier_orge_lrg_3 == nil then
	modifier_orge_lrg_3 = class({})
end
function modifier_orge_lrg_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	local interval = self:GetAbilitySpecialValueFor("interval")

	if IsServer() then
		self.tDamage = {
			attacker = self:GetParent(),
			damage = self:GetAbility():GetAbilityDamage(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility()
		}

		self:StartIntervalThink(interval)
	end
end
function modifier_orge_lrg_3:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.tDamage.damage = self:GetAbility():GetAbilityDamage()
	end
end
function modifier_orge_lrg_3:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	if IsServer() then
		hParent:AddNewModifier(hParent, hAbility, "modifier_orge_lrg_3_effect", { duration = LOCAL_PARTICLE_MODIFIER_DURATION })

		local tEnemies = Spawner:FindMissingInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, GetPlayerID(hParent))
		for k, hEnemy in pairs(tEnemies) do
			if IsValid(hEnemy) then
				self.tDamage.victim = hEnemy
				ApplyDamage(self.tDamage)
			end
		end
	end
end

------------------------------------------------------------------------------
if modifier_orge_lrg_3_effect == nil then
	modifier_orge_lrg_3_effect = class({}, nil, BaseModifier)
end
function modifier_orge_lrg_3_effect:IsHidden()
	return true
end
function modifier_orge_lrg_3_effect:OnCreated(params)
	local hParent = self:GetParent()
	if IsClient() then
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticle, 2, Vector(self.radius, self.radius, self.radius))
		ParticleManager:ReleaseParticleIndex(iParticle)
	else
		hParent:EmitSound("Hero_Lich.IceAge.Tick")
	end
end
function modifier_orge_lrg_3_effect:OnRefresh(params)
	if IsClient() then
		local hParent = self:GetParent()
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticle, 2, Vector(self.radius, self.radius, self.radius))
		ParticleManager:ReleaseParticleIndex(iParticle)

		hParent:EmitSound("Hero_Lich.IceAge.Tick")
	end
end