LinkLuaModifier( "modifier_druid_4", "abilities/tower/druid/druid_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_druid_1_boom", "abilities/tower/druid/druid_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if druid_4 == nil then
	druid_4 = class({})
end
function druid_4:GetIntrinsicModifierName()
	return "modifier_druid_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_druid_4 == nil then
	modifier_druid_4 = class({}, nil, eom_modifier)
end
function modifier_druid_4:OnCreated(params)
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
	self.boom_per_mana = self:GetAbilitySpecialValueFor("boom_per_mana")
	self.boom_interval = self:GetAbilitySpecialValueFor("boom_interval")
	self.boom_radius = self:GetAbilitySpecialValueFor("boom_radius")
	if IsServer() then
		self:StartIntervalThink(1)
		self:SetStackCount(0)
	end
end
function modifier_druid_4:Stack(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_druid_4:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.boom_radius, self:GetAbility())
	if hParent:GetManaPercent() == 100 and IsValid(tTargets[1]) then
		hParent:SpendMana(hParent:GetMaxMana(), self:GetAbility())
		hParent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_druid_1_boom", {duration = hParent:GetMaxMana() / self.boom_per_mana * self.boom_interval})
	end
end
function modifier_druid_4:EDeclareFunctions()
	return {
		EMDF_STATUS_MANA_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_MANA_REGEN_BONUS,
	}
end
function modifier_druid_4:GetStatusManaBonus()
	return self.bonus_mana * self:GetStackCount()
end
function modifier_druid_4:GetMagicalAttackBonus()
	return self.bonus_attack * self:GetStackCount()
end
function modifier_druid_4:GetManaRegenBonus()
	return self.bonus_mana_regen * self:GetStackCount()
end
---------------------------------------------------------------------
if modifier_druid_1_boom == nil then
	modifier_druid_1_boom = class({}, nil, ModifierPositiveBuff)
end
function modifier_druid_1_boom:OnCreated(params)
	self.boom_interval = self:GetAbilitySpecialValueFor("boom_interval")
	self.boom_radius = self:GetAbilitySpecialValueFor("boom_radius")
	self.magical_factor = self:GetAbilitySpecialValueFor("magical_factor")
	if IsServer() then
		self:StartIntervalThink(self.boom_interval)
	end
end
function modifier_druid_1_boom:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.boom_radius, self:GetAbility())
	hParent:DealDamage(tTargets, self:GetAbility())
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_mouth", hParent:GetAbsOrigin(), false)
	self:AddParticle(iParticleID, false, false, -1, false, false)
	hParent:EmitSound("Hero_Leshrac.Pulse_Nova_Strike")
end