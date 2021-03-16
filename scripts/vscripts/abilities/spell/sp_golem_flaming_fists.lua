LinkLuaModifier("modifier_sp_golem_flaming_fists", "abilities/spell/sp_golem_flaming_fists.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_golem_flaming_fists == nil then
	sp_golem_flaming_fists = class({})
end
function sp_golem_flaming_fists:GetIntrinsicModifierName()
	return "modifier_sp_golem_flaming_fists"
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_golem_flaming_fists == nil then
	modifier_sp_golem_flaming_fists = class({}, nil, eom_modifier)
end
function modifier_sp_golem_flaming_fists:IsHidden()
	return true
end
function modifier_sp_golem_flaming_fists:IsDebuff()
	return false
end
function modifier_sp_golem_flaming_fists:IsPurgable()
	return false
end
function modifier_sp_golem_flaming_fists:IsPurgeException()
	return false
end
function modifier_sp_golem_flaming_fists:IsStunDebuff()
	return false
end
function modifier_sp_golem_flaming_fists:AllowIllusionDuplicate()
	return false
end
function modifier_sp_golem_flaming_fists:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_sp_golem_flaming_fists:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_sp_golem_flaming_fists:OnDestroy()
	if IsServer() then
	end
end
function modifier_sp_golem_flaming_fists:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_sp_golem_flaming_fists:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	hParent:DealDamage(tTargets, self:GetAbility())
end