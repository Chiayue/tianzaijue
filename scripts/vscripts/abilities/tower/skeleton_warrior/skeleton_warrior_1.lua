LinkLuaModifier("modifier_skeleton_warrior_1", "abilities/tower/skeleton_warrior/skeleton_warrior_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if skeleton_warrior_1 == nil then
	skeleton_warrior_1 = class({}, nil, ability_base_ai)
end
function skeleton_warrior_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self, FIND_ANY_ORDER)
	for _, hUnit in pairs(tTargets) do
		local iParticleID = ParticleManager:CreateParticle("particles/econ/events/ti10/hero_levelup_ti10_flash_playerglow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hUnit:AddNewModifier(hCaster, self, "modifier_skeleton_warrior_1", nil)
	end

	hCaster:EmitSound("DOTA_Item.Buckler.Activate")
end
---------------------------------------------------------------------
--Modifiers
if modifier_skeleton_warrior_1 == nil then
	modifier_skeleton_warrior_1 = class({}, nil, eom_modifier)
end
function modifier_skeleton_warrior_1:IsHidden()
	return false
end
function modifier_skeleton_warrior_1:IsDebuff()
	return false
end
function modifier_skeleton_warrior_1:IsPurgable()
	return false
end
function modifier_skeleton_warrior_1:IsPurgeException()
	return false
end
function modifier_skeleton_warrior_1:IsStunDebuff()
	return false
end
function modifier_skeleton_warrior_1:AllowIllusionDuplicate()
	return false
end
function modifier_skeleton_warrior_1:OnCreated(params)
	self.bonus_max_health = self:GetAbilitySpecialValueFor("bonus_max_health")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_skeleton_warrior_1:OnRefresh(params)
	self.bonus_max_health = self:GetAbilitySpecialValueFor("bonus_max_health")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_skeleton_warrior_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_skeleton_warrior_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_skeleton_warrior_1:OnTooltip()
	return self:GetStatusHealthBonus()
end
function modifier_skeleton_warrior_1:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_skeleton_warrior_1:GetStatusHealthBonus()
	return self.bonus_max_health * self:GetStackCount()
end
function modifier_skeleton_warrior_1:OnBattleEnd()
	return self:Destroy()
end