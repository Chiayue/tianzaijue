LinkLuaModifier("modifier_doomA_1", "abilities/tower/doomA/doomA_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doomA_1_thinker", "abilities/tower/doomA/doomA_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doomA_1_ignite", "abilities/tower/doomA/doomA_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doomA_1_debuff", "abilities/tower/doomA/doomA_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if doomA_1 == nil then
	doomA_1 = class({})
end
function doomA_1:OnSpellStart(vPosition)
	local hCaster = self:GetCaster()
	CreateModifierThinker(hCaster, self, "modifier_doomA_1_debuff", { duration = self:GetSpecialValueFor("delay") }, vPosition, hCaster:GetTeamNumber(), false)
end
function doomA_1:GetIntrinsicModifierName()
	return "modifier_doomA_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_doomA_1 == nil then
	modifier_doomA_1 = class({}, nil, eom_modifier)
end
function modifier_doomA_1:IsHidden()
	return true
end
function modifier_doomA_1:OnCreated(params)
	self.target_hp_damage_pct = self:GetAbilitySpecialValueFor("target_hp_damage_pct")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.self_hp_damage_pct = self:GetAbilitySpecialValueFor("self_hp_damage_pct")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	if IsServer() then
		self.tRecord = {}
	end
end
function modifier_doomA_1:OnRefresh(params)
	self.target_hp_damage_pct = self:GetAbilitySpecialValueFor("target_hp_damage_pct")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.self_hp_damage_pct = self:GetAbilitySpecialValueFor("self_hp_damage_pct")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.delay = self:GetAbilitySpecialValueFor("delay")

end
function modifier_doomA_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
	}
end
function modifier_doomA_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_RECORD_CREATE,
		EMDF_EVENT_ON_ATTACK_RECORD_DESTROY,
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_doomA_1:OnCustomAttackRecordCreate(tAttackInfo)
	if self:GetAbility():IsCooldownReady() then
		local iRecord = DecodeAttackRecord(tAttackInfo.record)
		table.insert(self.tRecord, iRecord)
	end
end
function modifier_doomA_1:OnCustomAttackRecordDestroy(tAttackInfo)
	local iRecord = DecodeAttackRecord(tAttackInfo.record)
	if TableFindKey(self.tRecord, iRecord) then
		ArrayRemove(self.tRecord, iRecord)
	end
end
function modifier_doomA_1:GetActivityTranslationModifiers(params)
	if IsServer() then
		if self:GetAbility():IsCooldownReady() then
			return "infernal_blade"
		end
	end
end
function modifier_doomA_1:GetAttackSound(params)
	if TableFindKey(self.tRecord, params.record) then
		return "Hero_DoomBringer.InfernalBlade.PreAttack"
	end
end
function modifier_doomA_1:OnAttackLanded(params)
	if TableFindKey(self.tRecord, params.record) then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local hTarget = params.target
		hAbility:UseResources(false, false, true)
		hAbility:OnSpellStart(hTarget:GetAbsOrigin())
		-- CreateModifierThinker(hParent, hAbility, "modifier_doomA_1_debuff", {duration = self.delay}, hTarget:GetAbsOrigin(), hParent:GetTeamNumber(), false)
		-- 额外伤害
		-- hParent:DealDamage(hTarget, hAbility, hTarget:GetHealth() * self.target_hp_damage_pct * 0.01)
		-- 晕眩
		hTarget:AddBuff(hParent, BUFF_TYPE.STUN, self.stun_duration)
		-- 特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_ABSORIGIN, hTarget)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- 音效
		hParent:EmitSound("Hero_DoomBringer.InfernalBlade.Target")
	end
end
---------------------------------------------------------------------
if modifier_doomA_1_debuff == nil then
	modifier_doomA_1_debuff = class({}, nil, ParticleModifierThinker)
end
function modifier_doomA_1_debuff:OnCreated(params)
	self.self_hp_damage_pct = self:GetAbilitySpecialValueFor("self_hp_damage_pct")
	self.physical2magical = self:GetAbilitySpecialValueFor("physical2magical")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_doomA_1_debuff:OnDestroy()
	if not IsValid(self:GetCaster()) then
		return
	end
	if IsServer() then
		local hCaster = self:GetCaster()
		local flDamage = hCaster:GetMaxHealth() * self.self_hp_damage_pct * 0.01
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, self:GetParent():GetAbsOrigin(), self.radius, self:GetAbility())
		hCaster:DealDamage(tTargets, self:GetAbility(), flDamage)
		hCaster:EmitSound("Hero_DoomBringer.LvlDeath")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/dooma/dooma_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end