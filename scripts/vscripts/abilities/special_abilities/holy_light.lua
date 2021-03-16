LinkLuaModifier("modifier_holy_light", "abilities/special_abilities/holy_light.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if holy_light == nil then
	holy_light = class({})
end
function holy_light:GetIntrinsicModifierName()
	return "modifier_holy_light"
end
---------------------------------------------------------------------
--Modifiers
if modifier_holy_light == nil then
	modifier_holy_light = class({})
end
function modifier_holy_light:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.health = self:GetAbilitySpecialValueFor("health")
	if IsServer() then
	end
	self:StartIntervalThink(1)
end
function modifier_holy_light:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.health = self:GetAbilitySpecialValueFor("health")
	if IsServer() then
	end
	self:StartIntervalThink(1)
end
function modifier_holy_light:OnDestroy()
	self:StartIntervalThink(-1)
	if IsServer() then

	end
end
function modifier_holy_light:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()

		if not IsValid(hAbility)
		or not IsValid(hCaster) then
			self:Destroy()
			return
		end

		if hAbility:IsCooldownReady() then
			local tUnits = FindUnitsInRadius(
			hCaster:GetTeamNumber(),
			hCaster:GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

			local hTarget = RandomValue(tUnits)
			if IsValid(hTarget) and hTarget:IsAlive() then
				StartCooldown(hAbility)
				hTarget:Heal(self.health, self:GetAbility())
				SendOverheadEventMessage(hTarget:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, hTarget, self.health, hCaster:GetPlayerOwner())
			end
		end
	end
end
function modifier_holy_light:DeclareFunctions()
	return {
	}
end