LinkLuaModifier("modifier_shield", "abilities/special_abilities/shield.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shield_buff", "abilities/special_abilities/shield.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if shield == nil then
	shield = class({})
end
function shield:GetIntrinsicModifierName()
	return "modifier_shield"
end
---------------------------------------------------------------------
--Modifiers
if modifier_shield == nil then
	modifier_shield = class({}, nil, eom_modifier)
end
function modifier_shield:OnCreated(params)
	self.search_radius = self:GetAbilitySpecialValueFor("search_radius")
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:StartIntervalThink(1)
		end
	end
end
function modifier_shield:OnRefresh(params)
	self.search_radius = self:GetAbilitySpecialValueFor("search_radius")
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:StartIntervalThink(1)
		end
	end
end
function modifier_shield:OnDestroy()
	self:StartIntervalThink(-1)
	if IsServer() then
	end
end
function modifier_shield:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()

		if not IsValid(hAbility)
		or not IsValid(hCaster) then
			self:Destroy()
			return
		end

		local hAbility = self:GetAbility()
		if hAbility:IsCooldownReady() then
			local tUnits = FindUnitsInRadius(
			hCaster:GetTeamNumber(),
			hCaster:GetAbsOrigin(),
			nil,
			self.search_radius,
			hAbility:GetAbilityTargetTeam(),
			hAbility:GetAbilityTargetType(),
			hAbility:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false)

			local hTarget = RandomValue(tUnits)
			if IsValid(hTarget) and hTarget:IsAlive() then
				StartCooldown(hAbility)
				hTarget:AddNewModifier(hCaster, hAbility, "modifier_shield_buff", {})
			end
		end
	end
end
function modifier_shield:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_shield:OnInBattle()
	self:StartIntervalThink(1)
end
function modifier_shield:OnBattleEnd()
	self:StartIntervalThink(-1)
	if IsValid(self.hThinker) then
		UTIL_Remove(self.hThinker)
	end
end

------------------------------------------------------------------------------
if modifier_shield_buff == nil then
	modifier_shield_buff = class({}, nil, eom_modifier)
end
function modifier_shield_buff:IsPurgable()
	return true
end
function modifier_shield_buff:IsPurgeException()
	return true
end
function modifier_shield_buff:OnCreated(params)
	self.damage_block = self:GetAbilitySpecialValueFor("damage_block")
	if IsClient() then
		local iParticle = ParticleManager:CreateParticle("particles/units/abilities/shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticle, false, false, 9, false, false)
	end
end
function modifier_shield_buff:OnRefresh(params)
	self.damage_block = self:GetAbilitySpecialValueFor("damage_block")
end
function modifier_shield_buff:OnDestroy()
end
function modifier_shield_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_shield_buff:GetModifierAvoidDamage(params)
	if not IsValid(self:GetAbility()) then
		self:Destroy()
		return 0
	end
	if params.damage >= 1 then
		self.damage_block = self.damage_block - params.damage
		if self.damage_block <= 0 then
			self:Destroy()
			return 0
		end
	end
	return 1
end