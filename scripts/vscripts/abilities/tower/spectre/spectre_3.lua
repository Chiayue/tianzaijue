LinkLuaModifier("modifier_spectre_3", "abilities/tower/spectre/spectre_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if spectre_3 == nil then
	spectre_3 = class({})
end
function spectre_3:GetIntrinsicModifierName()
	return "modifier_spectre_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_spectre_3 == nil then
	modifier_spectre_3 = class({}, nil, eom_modifier)
end
function modifier_spectre_3:OnCreated(params)
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	self.health_damage_pct = self:GetAbilitySpecialValueFor("health_damage_pct")
	self.min_radius = self:GetAbilitySpecialValueFor("min_radius")
	self.max_radius = self:GetAbilitySpecialValueFor("max_radius")
	if IsServer() then
	end
end
function modifier_spectre_3:OnRefresh(params)
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	self.health_damage_pct = self:GetAbilitySpecialValueFor("health_damage_pct")
	self.min_radius = self:GetAbilitySpecialValueFor("min_radius")
	self.max_radius = self:GetAbilitySpecialValueFor("max_radius")
	if IsServer() then
	end
end
function modifier_spectre_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_spectre_3:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -self.damage_reduce,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_spectre_3:GetIncomingPercentage()
	return -self.damage_reduce
end
function modifier_spectre_3:OnTakeDamage(params)
	if params.damage > 0 and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		local hParent = self:GetParent()
		local flDamage = self.health_damage_pct * hParent:GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.max_radius, self:GetAbility())
		local n = 0
		for _, hUnit in ipairs(tTargets) do
			local _flDamage = RemapValClamped(CalculateDistance(hParent, hUnit), self.min_radius, self.max_radius, flDamage, 0)
			hParent:DealDamage(hUnit, self:GetAbility(), _flDamage, params.damage_type, params.damage_flags + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS)
			n = n + 1
		end
	end
end
function modifier_spectre_3:IsHidden()
	return true
end