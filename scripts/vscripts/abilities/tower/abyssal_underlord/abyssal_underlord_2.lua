LinkLuaModifier("modifier_abyssal_underlord_2_thinker", "abilities/tower/abyssal_underlord/abyssal_underlord_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_underlord_2_debuff_aura", "abilities/tower/abyssal_underlord/abyssal_underlord_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_underlord_2_buff", "abilities/tower/abyssal_underlord/abyssal_underlord_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_underlord_2_debuff", "abilities/tower/abyssal_underlord/abyssal_underlord_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if abyssal_underlord_2 == nil then
	local tInitData = {
	}
	abyssal_underlord_2 = class(tInitData, nil, ability_base_ai)
end
function abyssal_underlord_2:GetAOERadius()
	return self:GetSpecialValueFor("range")
end
function abyssal_underlord_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPosition = hCaster:GetAbsOrigin()
	local radius = self:GetSpecialValueFor("radius")
	local interval = self:GetSpecialValueFor("interval")
	-- action
	self.hThinker = CreateModifierThinker(hCaster, self, "modifier_abyssal_underlord_2_thinker", { duration = interval }, vPosition, hCaster:GetTeamNumber(), false)
	self.hThinker:AddNewModifier(hCaster, self, "modifier_abyssal_underlord_2_debuff_aura", { duration = interval })
	-- sound
end


---------------------------------------------------------------------
--Modifiers
if modifier_abyssal_underlord_2_thinker == nil then
	modifier_abyssal_underlord_2_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_abyssal_underlord_2_thinker:IsHidden()
	return true
end
function modifier_abyssal_underlord_2_thinker:IsDebuff()
	return false
end
function modifier_abyssal_underlord_2_thinker:IsPurgable()
	return false
end
function modifier_abyssal_underlord_2_thinker:IsPurgeException()
	return false
end
function modifier_abyssal_underlord_2_thinker:IsStunDebuff()
	return false
end
function modifier_abyssal_underlord_2_thinker:AllowIllusionDuplicate()
	return false
end
function modifier_abyssal_underlord_2_thinker:IsAura()
	return true
end
function modifier_abyssal_underlord_2_thinker:GetAuraRadius()
	return self.range
end
function modifier_abyssal_underlord_2_thinker:GetModifierAura()
	return "modifier_abyssal_underlord_2_buff"
end
function modifier_abyssal_underlord_2_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_abyssal_underlord_2_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end
function modifier_abyssal_underlord_2_thinker:OnCreated(params)
	self.range = self:GetAbilitySpecialValueFor("range")
	if IsServer() then
		self:StartIntervalThink(0)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/abyss/abyssknight_2_particles.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.range, self.range, self.range))
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(self:GetDuration(), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_abyssal_underlord_2_thinker:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local iCount = #tTargets
		for k, hTarget in pairs(tTargets) do
			local hModifier = hTarget:FindModifierByName("modifier_abyssal_underlord_2_buff")
			if IsValid(hModifier) then
				hModifier:SetStackCount(iCount)
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_abyssal_underlord_2_debuff_aura == nil then
	modifier_abyssal_underlord_2_debuff_aura = class({}, nil, eom_modifier)
end
function modifier_abyssal_underlord_2_debuff_aura:IsHidden()
	return true
end
function modifier_abyssal_underlord_2_debuff_aura:IsDebuff()
	return false
end
function modifier_abyssal_underlord_2_debuff_aura:IsPurgable()
	return false
end
function modifier_abyssal_underlord_2_debuff_aura:IsPurgeException()
	return false
end
function modifier_abyssal_underlord_2_debuff_aura:IsStunDebuff()
	return false
end
function modifier_abyssal_underlord_2_debuff_aura:AllowIllusionDuplicate()
	return false
end
function modifier_abyssal_underlord_2_debuff_aura:IsAura()
	return true
end
function modifier_abyssal_underlord_2_debuff_aura:GetAuraRadius()
	return self.range
end
function modifier_abyssal_underlord_2_debuff_aura:GetModifierAura()
	return "modifier_abyssal_underlord_2_debuff"
end
function modifier_abyssal_underlord_2_debuff_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_abyssal_underlord_2_debuff_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end
function modifier_abyssal_underlord_2_debuff_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_abyssal_underlord_2_debuff_aura:OnCreated(params)
	self.range = self:GetAbilitySpecialValueFor("range")
end
---------------------------------------------------------------------
if modifier_abyssal_underlord_2_buff == nil then
	modifier_abyssal_underlord_2_buff = class({}, nil, eom_modifier)
end
function modifier_abyssal_underlord_2_buff:OnCreated(params)
	self.bonus_attack_damage_per_unit = self:GetAbilitySpecialValueFor("bonus_attack_damage_per_unit")
	self.bonus_attack_damage_max = self:GetAbilitySpecialValueFor("bonus_attack_damage_max")
	if IsServer() then
	end
end
function modifier_abyssal_underlord_2_buff:OnRefresh(params)
	self.bonus_attack_damage_per_unit = self:GetAbilitySpecialValueFor("bonus_attack_damage_per_unit")
	self.bonus_attack_damage_max = self:GetAbilitySpecialValueFor("bonus_attack_damage_max")
	if IsServer() then
	end
end
function modifier_abyssal_underlord_2_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_abyssal_underlord_2_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
	}
end
function modifier_abyssal_underlord_2_buff:GetPhysicalAttackBonusPercentage()
	return math.min(self:GetStackCount()*self.bonus_attack_damage_per_unit, self.bonus_attack_damage_max)
end
function modifier_abyssal_underlord_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_abyssal_underlord_2_buff:OnTooltip()
	return self:GetPhysicalAttackBonusPercentage()
end
---------------------------------------------------------------------
if modifier_abyssal_underlord_2_debuff == nil then
	modifier_abyssal_underlord_2_debuff = class({}, nil, eom_modifier)
end
function modifier_abyssal_underlord_2_debuff:IsHidden()
	return true
end
function modifier_abyssal_underlord_2_debuff:IsDebuff()
	return true
end
function modifier_abyssal_underlord_2_debuff:IsPurgable()
	return false
end
function modifier_abyssal_underlord_2_debuff:IsPurgeException()
	return false
end
function modifier_abyssal_underlord_2_debuff:IsStunDebuff()
	return false
end
function modifier_abyssal_underlord_2_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_abyssal_underlord_2_debuff:OnCreated(params)
	self.infected_time_reduce = self:GetAbilitySpecialValueFor("infected_time_reduce")
end
function modifier_abyssal_underlord_2_debuff:OnRefresh(params)
	self.infected_time_reduce = self:GetAbilitySpecialValueFor("infected_time_reduce")
end
