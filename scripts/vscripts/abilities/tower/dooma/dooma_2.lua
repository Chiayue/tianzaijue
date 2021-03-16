LinkLuaModifier("modifier_doomA_2_aura", "abilities/tower/doomA/doomA_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doomA_2_buff", "abilities/tower/doomA/doomA_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doomA_2_thinker", "abilities/tower/doomA/doomA_2.lua", LUA_MODIFIER_MOTION_NONE)
if doomA_2 == nil then
	doomA_2 = class({}, nil, ability_base_ai)
end
function doomA_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function doomA_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_doomA_2_aura", { duration = self:GetDuration() })
	hCaster:EmitSound("Hero_EmberSpirit.FireRemnant.Activate")
end
function doomA_2:FireEruption(vPosition)
	local hCaster = self:GetCaster()
	CreateModifierThinker(hCaster, self, "modifier_doomA_2_thinker", { duration = self:GetSpecialValueFor("duration") }, vPosition, hCaster:GetTeamNumber(), false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_doomA_2_aura == nil then
	modifier_doomA_2_aura = class({}, nil, eom_modifier)
end
function modifier_doomA_2_aura:IsHidden()
	return true
end
function modifier_doomA_2_aura:IsAura()
	return true
end
function modifier_doomA_2_aura:GetAuraRadius()
	return self.radius
end
function modifier_doomA_2_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_doomA_2_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_doomA_2_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_doomA_2_aura:GetModifierAura()
	return "modifier_doomA_2_buff"
end
function modifier_doomA_2_aura:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.earth_damage_factor = self:GetAbilitySpecialValueFor("earth_damage_factor")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
		self.flDamage = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.earth_damage_factor * 0.01
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_doomA_2_aura:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.earth_damage_factor = self:GetAbilitySpecialValueFor("earth_damage_factor")
	self.interval = self:GetAbilitySpecialValueFor("interval")
end
function modifier_doomA_2_aura:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	hParent:DealDamage(tTargets, self:GetAbility(), self.flDamage)
end
---------------------------------------------------------------------
if modifier_doomA_2_buff == nil then
	modifier_doomA_2_buff = class({}, nil, eom_modifier)
end
function modifier_doomA_2_buff:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.movespeed_pct = self:GetAbilitySpecialValueFor("movespeed_pct")
	self.damage_interval = self:GetAbilitySpecialValueFor("damage_interval")
	self.count = self:GetAbilitySpecialValueFor("count")
	self.fire_interval = self:GetAbilitySpecialValueFor("fire_interval")
	if IsServer() and self:GetCaster() == self:GetParent() then
		self:StartIntervalThink(self.fire_interval)
	end
end
function modifier_doomA_2_buff:EDeclareFunctions()
	return {
		EMDF_HEALTH_REGEN_BONUS,
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = self.movespeed_pct,
	}
end
function modifier_doomA_2_buff:OnIntervalThink()
	local hParent = self:GetParent()
	-- 炎爆
	hParent:EmitSound("Hero_Nevermore.Raze_Flames")
	for i = 1, RandomInt(1, self.count) do
		self:GetAbility():FireEruption(GetRandomPosition(hParent:GetAbsOrigin(), self.radius))
	end
end
function modifier_doomA_2_buff:GetHealthRegenBonus()
	return self.health_regen_pct * self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
end
function modifier_doomA_2_buff:GetMoveSpeedBonusPercentage()
	return self.movespeed_pct
end
function modifier_doomA_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_doomA_2_buff:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 2
	if 0 == self.iTooltip then
		return self.movespeed_pct
	end
	return self.health_regen_pct
end
---------------------------------------------------------------------
if modifier_doomA_2_thinker == nil then
	modifier_doomA_2_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_doomA_2_thinker:OnCreated(params)
	self.damage_interval = self:GetAbilitySpecialValueFor("damage_interval")
	self.fire_damage_factor = self:GetAbilitySpecialValueFor("fire_damage_factor")
	self.fire_radius = self:GetAbilitySpecialValueFor("fire_radius")
	if IsServer() then
		self.flDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.fire_damage_factor * self.damage_interval * 0.01
		self:StartIntervalThink(self.damage_interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/dooma/dooma_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_doomA_2_thinker:OnIntervalThink()
	if not IsValid(self:GetCaster()) then
		return
	end
	if IsServer() then
		local tTargets = FindUnitsInRadiusWithAbility(self:GetCaster(), self:GetParent():GetAbsOrigin(), self.fire_radius, self:GetAbility())
		self:GetCaster():DealDamage(tTargets, self:GetAbility(), self.flDamage)
	end
end