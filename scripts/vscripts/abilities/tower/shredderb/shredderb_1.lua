LinkLuaModifier("modifier_shredderB_1", "abilities/tower/shredderB/shredderB_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shredderB_1_debuff", "abilities/tower/shredderB/shredderB_1.lua", LUA_MODIFIER_MOTION_NONE)

if shredderB_1 == nil then
	shredderB_1 = class({ iBehavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET }, nil, ability_base_ai)
end
function shredderB_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function shredderB_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local ignite_duration = self:GetSpecialValueFor("ignite_duration")
	local ignite_count = self:GetSpecialValueFor("ignite_count")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_shredderB_1_debuff", { self:GetDuration() })
		-- hUnit:AddBuff(hCaster, BUFF_TYPE.IGNITE, ignite_duration, false, { iCount = ignite_count })
		hCaster:DealDamage(hUnit, self)
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_Shredder.WhirlingDeath.Cast")
end
function shredderB_1:GetIntrinsicModifierName()
	return "modifier_shredderB_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_shredderB_1 == nil then
	modifier_shredderB_1 = class({}, nil, eom_modifier)
end
function modifier_shredderB_1:OnCreated(params)
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
end
function modifier_shredderB_1:OnRefresh(params)
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
end
function modifier_shredderB_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_shredderB_1:OnTakeDamage(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if params.damage > 0 and not hAbility:IsCooldownReady() then
		local flCooldown = hAbility:GetCooldownTimeRemaining() - self.cooldown_reduce
		hAbility:EndCooldown()
		hAbility:StartCooldown(flCooldown)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_shredderB_1_debuff == nil then
	modifier_shredderB_1_debuff = class({}, nil, eom_modifier)
end
function modifier_shredderB_1_debuff:IsDebuff()
	return true
end
function modifier_shredderB_1_debuff:OnCreated(params)
	self.attack_reduce_pct = self:GetAbilitySpecialValueFor("attack_reduce_pct")
end
function modifier_shredderB_1_debuff:OnRefresh(params)
	self.attack_reduce_pct = self:GetAbilitySpecialValueFor("attack_reduce_pct")
end
function modifier_shredderB_1_debuff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = -self.attack_reduce_pct,
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = -self.attack_reduce_pct,
	}
end
function modifier_shredderB_1_debuff:GetPhysicalAttackBonusPercentage()
	return -self.attack_reduce_pct
end
function modifier_shredderB_1_debuff:GetMagicalAttackBonusPercentage()
	return -self.attack_reduce_pct
end