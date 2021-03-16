LinkLuaModifier("modifier_cmd_tinker_0", "abilities/commander/cmd_tinker/cmd_tinker_0.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_tinker_0 == nil then
	cmd_tinker_0 = class({})
end
function cmd_tinker_0:GetIntrinsicModifierName()
	return "modifier_cmd_tinker_0"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_tinker_0 == nil then
	modifier_cmd_tinker_0 = class({}, nil, eom_modifier)
end
function modifier_cmd_tinker_0:OnCreated(params)
	self.aoe_range = self:GetAbilitySpecialValueFor("aoe_range")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	if IsServer() then
	end
end
function modifier_cmd_tinker_0:OnRefresh(params)
	self.aoe_range = self:GetAbilitySpecialValueFor("aoe_range")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	if IsServer() then
	end
end
function modifier_cmd_tinker_0:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_tinker_0:IsHidden()
	return true
end
function modifier_cmd_tinker_0:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_ATTACK_RECORD_CREATE,
		EMDF_ATTACKT_PROJECTILE
	}
end
function modifier_cmd_tinker_0:GetAttackProjectile()
	return 'particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare.vpcf'
end
function modifier_cmd_tinker_0:OnCustomAttackRecordCreate(tAttackInfo)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	local hParent = self:GetParent()
end
function modifier_cmd_tinker_0:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if hCaster then
		local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, self.aoe_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local flDamage = self.damage_factor * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * 0.01
		for _, hTarget in ipairs(targets) do
			local tDamage = {
				ability = hAbility,
				attacker = hCaster,
				victim = hTarget,
				damage = flDamage,
				damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(tDamage)
		end
		if self.iParticleID then
			ParticleManager:DestroyParticle(self.iParticleID, true)
		end
	end
end
-- 暂存特效
-- particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare.vpcf
-- particles/units/heroes/hero_tinker/tinker_base_attack.vpcf
function modifier_cmd_tinker_0:DeclareFunctions()
	return {
	}
end