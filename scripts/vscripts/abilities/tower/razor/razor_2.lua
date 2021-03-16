LinkLuaModifier("modifier_razor_2", "abilities/tower/razor/razor_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_2_buff", "abilities/tower/razor/razor_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_2_debuff", "abilities/tower/razor/razor_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if razor_2 == nil then
	razor_2 = class({})
end
function razor_2:Link(hTarget)
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hTarget, self, "modifier_razor_2_buff", { duration = self:GetSpecialValueFor("duration") + self:GetSpecialValueFor("attack_duration") })
	hTarget:AddNewModifier(hCaster, self, "modifier_razor_2_debuff", { duration = self:GetSpecialValueFor("duration") + self:GetSpecialValueFor("attack_duration") })
end
function razor_2:GetIntrinsicModifierName()
	return "modifier_razor_2"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_razor_2 == nil then
	modifier_razor_2 = class({}, nil, ModifierHidden)
end
function modifier_razor_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_razor_2:OnIntervalThink()
	local hParent = self:GetParent()
	if self:GetAbility():IsCooldownReady() then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		if IsValid(tTargets[1]) then
			self:GetAbility():UseResources(false, false, true)
			self:GetAbility():Link(tTargets[1])
		end
	end
end
---------------------------------------------------------------------
if modifier_razor_2_buff == nil then
	modifier_razor_2_buff = class({}, nil, eom_modifier)
end
function modifier_razor_2_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_razor_2_buff:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.attack_per_sec = self:GetAbilitySpecialValueFor("attack_per_sec")
	self.max_distance = self:GetAbilitySpecialValueFor("max_distance")
	if IsServer() then
		self:StartIntervalThink(1)
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_static", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	end
end
function modifier_razor_2_buff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
	end
end
function modifier_razor_2_buff:OnIntervalThink()
	if not IsValid(self:GetParent()) or
	not self:GetParent():IsAlive() or
	not IsValid(self:GetCaster()) or
	not self:GetCaster():IsAlive() or
	CalculateDistance(self:GetCaster(), self:GetParent()) > self.max_distance then
		self:StartIntervalThink(-1)
		ParticleManager:DestroyParticle(self.iParticleID, false)
		return
	end
	self:IncrementStackCount()
	-- 攻击
	self:GetParent():Attack(self:GetCaster(), ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link_hit.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_static", self:GetParent():GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	if self:GetStackCount() >= self.duration then
		self:StartIntervalThink(-1)
		ParticleManager:DestroyParticle(self.iParticleID, false)
	end
end
function modifier_razor_2_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_razor_2_buff:GetMagicalAttackBonus()
	return self.attack_per_sec * self:GetStackCount()
end
function modifier_razor_2_buff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	if RollPercentage(self.chance) then
		local hAbility = self:GetParent():FindAbilityByName("razor_1")
		hAbility:OnSpellStart(hTarget)
	end
end
function modifier_razor_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_razor_2_buff:OnTooltip()
	return self.attack_per_sec * self:GetStackCount()
end
---------------------------------------------------------------------
if modifier_razor_2_debuff == nil then
	modifier_razor_2_debuff = class({}, nil, eom_modifier)
end
function modifier_razor_2_debuff:IsDebuff()
	return true
end
function modifier_razor_2_debuff:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.attack_per_sec = self:GetAbilitySpecialValueFor("attack_per_sec")
	self.max_distance = self:GetAbilitySpecialValueFor("max_distance")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_razor_2_debuff:OnIntervalThink()
	if not IsValid(self:GetParent()) or
	not self:GetParent():IsAlive() or
	not IsValid(self:GetCaster()) or
	not self:GetCaster():IsAlive() or
	CalculateDistance(self:GetCaster(), self:GetParent()) > self.max_distance then
		self:StartIntervalThink(-1)
		return
	end
	self:IncrementStackCount()
	if self:GetStackCount() >= self.duration then
		self:StartIntervalThink(-1)
	end
end
function modifier_razor_2_debuff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS,
	}
end
function modifier_razor_2_debuff:GetMagicalAttackBonus()
	return -self.attack_per_sec * self:GetStackCount()
end
function modifier_razor_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_razor_2_debuff:OnTooltip()
	return self.attack_per_sec * self:GetStackCount()
end