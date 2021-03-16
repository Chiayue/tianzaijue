LinkLuaModifier("modifier_magic_shock", "abilities/special_abilities/magic_shock.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if magic_shock == nil then
	magic_shock = class({})
end
function magic_shock:GetIntrinsicModifierName()
	return "modifier_magic_shock"
end
function magic_shock:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsValid(hTarget) then
		local tDamage = {
			ability = self,
			attacker = self:GetCaster(),
			victim = hTarget,
			damage = self:GetAbilityDamage(),
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NO_CUSTOM + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT
		}
		ApplyDamage(tDamage)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_magic_shock == nil then
	modifier_magic_shock = class({}, nil, eom_modifier)
end
function modifier_magic_shock:OnCreated(params)
	self.projectile_speed = self:GetAbilitySpecialValueFor("projectile_speed")
end
function modifier_magic_shock:OnRefresh(params)
	self.projectile_speed = self:GetAbilitySpecialValueFor("projectile_speed")
end
function modifier_magic_shock:OnDestroy()
	if IsServer() then
	end
end
function modifier_magic_shock:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = { self:GetParent() }
	}
end
function modifier_magic_shock:OnTakeDamage(params)
	if params.attacker ~= self:GetParent()
	or params.unit == self:GetParent()
	or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT) == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT then
		return
	end
	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() then
		local hTarget = params.unit
		if IsValid(hTarget) and hTarget:IsAlive() then
			hAbility:StartCooldown(hAbility:GetCooldown(hAbility:GetLevel() - 1))

			local tInfo = {
				Ability = hAbility,
				Source = self:GetParent(),
				EffectName = "particles/units/abilities/magic_shockbolt.vpcf",
				Target = hTarget,
				iMoveSpeed = self.projectile_speed,
				bDodgeable = false,
				bIsAttack = false,
				ExtraData = {
				-- iParticle = iParticle,
				}
			}
			ProjectileManager:CreateTrackingProjectile(tInfo)
		end
	end
end