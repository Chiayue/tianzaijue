LinkLuaModifier("modifier_sp_golem_permanent_immolation", "abilities/spell/sp_golem_permanent_immolation.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_golem_permanent_immolation == nil then
	sp_golem_permanent_immolation = class({})
end
function sp_golem_permanent_immolation:GetIntrinsicModifierName()
	return "modifier_sp_golem_permanent_immolation"
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_golem_permanent_immolation == nil then
	modifier_sp_golem_permanent_immolation = class({}, nil, eom_modifier)
end
function modifier_sp_golem_permanent_immolation:IsHidden()
	return true
end
function modifier_sp_golem_permanent_immolation:IsDebuff()
	return false
end
function modifier_sp_golem_permanent_immolation:IsPurgable()
	return false
end
function modifier_sp_golem_permanent_immolation:IsPurgeException()
	return false
end
function modifier_sp_golem_permanent_immolation:IsStunDebuff()
	return false
end
function modifier_sp_golem_permanent_immolation:AllowIllusionDuplicate()
	return false
end
function modifier_sp_golem_permanent_immolation:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_sp_golem_permanent_immolation:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_sp_golem_permanent_immolation:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		hParent:DealDamage(tTargets, self:GetAbility())
	end
end
