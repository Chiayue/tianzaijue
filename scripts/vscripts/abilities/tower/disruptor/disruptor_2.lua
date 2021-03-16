LinkLuaModifier("modifier_disruptor_2", "abilities/tower/disruptor/disruptor_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_disruptor_2_aura", "abilities/tower/disruptor/disruptor_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_disruptor_2_buff", "abilities/tower/disruptor/disruptor_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_disruptor_2_debuff", "abilities/tower/disruptor/disruptor_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if disruptor_2 == nil then
	disruptor_2 = class({})
end
function disruptor_2:GetIntrinsicModifierName()
	return "modifier_disruptor_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_disruptor_2 == nil then
	modifier_disruptor_2 = class({}, nil, ModifierHidden)
end
---------------------------------------------------------------------
if modifier_disruptor_2_aura == nil then
	modifier_disruptor_2_aura = class({}, nil, ParticleModifierThinker)
end
function modifier_disruptor_2_aura:IsAura()
	return true
end
function modifier_disruptor_2_aura:GetAuraRadius()
	return self.radius
end
function modifier_disruptor_2_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_disruptor_2_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_disruptor_2_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_disruptor_2_aura:GetModifierAura()
	return "modifier_disruptor_2_buff"
end
function modifier_disruptor_2_aura:GetAuraEntityReject(hEntity)
	if GetPlayerID(hEntity) ~= GetPlayerID(self:GetCaster()) then
		return true
	end
	return false
end
function modifier_disruptor_2_aura:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
---------------------------------------------------------------------
if modifier_disruptor_2_buff == nil then
	modifier_disruptor_2_buff = class({}, nil, eom_modifier)
end
function modifier_disruptor_2_buff:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.magical_armor = self:GetAbilitySpecialValueFor("magical_armor")
	self.reduce_pct = self:GetAbilitySpecialValueFor("reduce_pct")
	self.armor = self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.magical_armor * 0.01
	if IsServer() then
		self:SetStackCount(self.armor)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_static_storm_bolt_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_disruptor_2_buff:OnRefresh(params)
	self.armor = self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.magical_armor * 0.01
	if IsServer() then
		self:SetStackCount(self.armor)
	end
end
function modifier_disruptor_2_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_disruptor_2_buff:GetMagicalArmorBonus()
	return self:GetStackCount()
end
function modifier_disruptor_2_buff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	-- 进行一次 tAttackInfo的判
	if not tAttackInfo then return end
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_disruptor_2_debuff", { duration = self.duration })
end
function modifier_disruptor_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_disruptor_2_buff:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 2
	if 0 == self.iTooltip then
		return self.armor
	end
	return self.reduce_pct
end
---------------------------------------------------------------------
if modifier_disruptor_2_debuff == nil then
	modifier_disruptor_2_debuff = class({}, nil, eom_modifier)
end
function modifier_disruptor_2_debuff:IsDebuff()
	return true
end
function modifier_disruptor_2_debuff:OnCreated(params)
	self.reduce_pct = self:GetAbilitySpecialValueFor("reduce_pct")
end
function modifier_disruptor_2_debuff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = -self.reduce_pct,
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.reduce_pct
	}
end
function modifier_disruptor_2_debuff:GetAttackSpeedPercentage()
	return -self.reduce_pct
end
function modifier_disruptor_2_debuff:GetMoveSpeedBonusPercentage()
	return -self.reduce_pct
end