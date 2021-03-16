LinkLuaModifier("modifier_contract_judge", "abilities/contract/contract_judge.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if contract_judge == nil then
	contract_judge = class({})
end
function contract_judge:GetIntrinsicModifierName()
	return "modifier_contract_judge"
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_judge == nil then
	modifier_contract_judge = class({}, nil, eom_modifier)
end
function modifier_contract_judge:IsHidden()
	return true
end
function modifier_contract_judge:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.health_lost_factor = self:GetAbilitySpecialValueFor("health_lost_factor")
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:StartIntervalThink(self.interval)
		end
	end
end
function modifier_contract_judge:OnRefresh(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.health_lost_factor = self:GetAbilitySpecialValueFor("health_lost_factor")
	if IsServer() then
	end
end
function modifier_contract_judge:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE
	}
end
function modifier_contract_judge:OnInBattle()
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_contract_judge:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAlive() then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		local flDamage = hParent:GetHealthDeficit() * self.health_lost_factor * 0.01
		hParent:DealDamage(tTargets, self:GetAbility(), flDamage)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_decay.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		hParent:EmitSound("Hero_Undying.Decay.Cast.PaleAugur")
	end
end