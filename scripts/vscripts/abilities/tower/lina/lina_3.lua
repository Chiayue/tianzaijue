LinkLuaModifier("modifier_lina_3", "abilities/tower/lina/lina_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if lina_3 == nil then
	lina_3 = class({})
end
function lina_3:GetIntrinsicModifierName()
	return "modifier_lina_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_lina_3 == nil then
	modifier_lina_3 = class({}, nil, eom_modifier)
end
function modifier_lina_3:OnCreated(params)
	self.active_count = self:GetAbilitySpecialValueFor("active_count")
	if IsServer() then
	end
end
function modifier_lina_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_lina_3:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hCaster = tAttackInfo.attacker
	if RollPercentage(30) then
		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(particleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin() + Vector(0, 0, 96), true)
		ParticleManager:SetParticleControlEnt(particleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particleID)

		hCaster:DealDamage(hTarget, self:GetAbility())
	end
end