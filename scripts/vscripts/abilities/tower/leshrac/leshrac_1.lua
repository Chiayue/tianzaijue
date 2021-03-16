LinkLuaModifier( "modifier_leshrac_1", "abilities/tower/leshrac/leshrac_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_1_regen", "abilities/tower/leshrac/leshrac_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if leshrac_1 == nil then
	leshrac_1 = class({})
end
function leshrac_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_leshrac_1_regen", {duration = self:GetDuration()})
end
function leshrac_1:GetIntrinsicModifierName()
	return "modifier_leshrac_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_leshrac_1 == nil then
	modifier_leshrac_1 = class({}, nil, ModifierHidden)
end
function modifier_leshrac_1:OnCreated(params)
	self.distance = self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), nil)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_leshrac_1:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility())
		if IsValid(tTargets[1]) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, tTargets[1], self:GetAbility())
		end
	end
end
---------------------------------------------------------------------
if modifier_leshrac_1_regen == nil then
	modifier_leshrac_1_regen = class({}, nil, ModifierPositiveBuff)
end
function modifier_leshrac_1_regen:OnCreated(params)
	self.heal_pct = self:GetAbilitySpecialValueFor("heal_pct")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/leshrac/leshrac_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_leshrac_1_regen:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end
function modifier_leshrac_1_regen:GetModifierHealthRegenPercentage()
	return self.heal_pct
end