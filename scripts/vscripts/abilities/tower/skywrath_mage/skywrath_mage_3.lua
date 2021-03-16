LinkLuaModifier("modifier_skywrath_mage_3", "abilities/tower/skywrath_mage/skywrath_mage_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skywrath_mage_3_buff", "abilities/tower/skywrath_mage/skywrath_mage_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if skywrath_mage_3 == nil then
	skywrath_mage_3 = class({})
end
function skywrath_mage_3:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_skywrath_mage_3_buff", { duration = self:GetDuration() })
end
function skywrath_mage_3:GetIntrinsicModifierName()
	return "modifier_skywrath_mage_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_skywrath_mage_3 == nil then
	modifier_skywrath_mage_3 = class({}, nil, BaseModifier)
end
function modifier_skywrath_mage_3:IsHidden()
	return true
end
function modifier_skywrath_mage_3:OnCreated(params)
	self.max_radius = self:GetAbilitySpecialValueFor("max_radius")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_skywrath_mage_3:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self:GetAbility():entindex(),
			})
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_skywrath_mage_3_buff == nil then
	modifier_skywrath_mage_3_buff = class({}, nil, eom_modifier)
end
function modifier_skywrath_mage_3_buff:OnCreated(params)
	self.evade = self:GetAbilitySpecialValueFor("evade")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_skywrath_mage_3_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_skywrath_mage_3_buff:EDeclareFunctions()
	return {
		EMDF_ATTACK_MISS_BONUS,
	}
end
function modifier_skywrath_mage_3_buff:GetAttackMissBonus()
	return 100, 100
end