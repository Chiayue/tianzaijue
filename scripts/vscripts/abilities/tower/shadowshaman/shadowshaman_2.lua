LinkLuaModifier("modifier_shadowshaman_2_debuff", "abilities/tower/shadowshaman/shadowshaman_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if shadowshaman_2 == nil then
	shadowshaman_2 = class({}, nil, ability_base_ai)
end
function shadowshaman_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local info = {
		Target = hTarget,
		Source = hCaster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf",
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
		bDodgeable = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
	hCaster:EmitSound("Hero_Alchemist.UnstableConcoction.Throw")
end
function shadowshaman_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if IsValid(hTarget) then
		hTarget:AddNewModifier(hCaster, self, "modifier_shadowshaman_2_debuff", { duration = self:GetDuration() })
		EmitSoundOnLocationWithCaster(vLocation, "Hero_Alchemist.UnstableConcoction.Stun", hCaster)
	else
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_shadowshaman_2_debuff == nil then
	modifier_shadowshaman_2_debuff = class({}, nil, BaseModifier)
end
function modifier_shadowshaman_2_debuff:IsDebuff()
	return true
end
function modifier_shadowshaman_2_debuff:OnCreated(params)
	self.hp_damage_pct = self:GetAbilitySpecialValueFor("hp_damage_pct")
	self.magic_damage_factor = self:GetAbilitySpecialValueFor("magic_damage_factor")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_shadowshaman_2_debuff:OnRefresh(params)
	self.hp_damage_pct = self:GetAbilitySpecialValueFor("hp_damage_pct")
	self.magic_damage_factor = self:GetAbilitySpecialValueFor("magic_damage_factor")
	if IsServer() then
	end
end
function modifier_shadowshaman_2_debuff:OnIntervalThink()
	local tDamageInfo = {
		attacker = self:GetCaster(),
		victim = self:GetParent(),
		ability = self:GetAbility(),
		damage = self.hp_damage_pct * self:GetParent():GetMaxHealth() * 0.01 + self.magic_damage_factor * 0.01 * self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(tDamageInfo)
end