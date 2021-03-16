LinkLuaModifier("modifier_bounty_hunter_2_thinker", "abilities/tower/bounty_hunter/bounty_hunter_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bounty_hunter_2_buff", "abilities/tower/bounty_hunter/bounty_hunter_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bounty_hunter_2_debuff", "abilities/tower/bounty_hunter/bounty_hunter_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if bounty_hunter_2 == nil then
	bounty_hunter_2 = class({}, nil, ability_base_ai)
end
function bounty_hunter_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function bounty_hunter_2:OnSpellStart()
	local hCaster = self:GetCaster()
	-- 烟雾
	CreateModifierThinker(hCaster, self, "modifier_bounty_hunter_2_thinker", { duration = self:GetDuration() }, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
	-- 添加暴击
	-- hCaster:AddBuff(hCaster, BUFF_TYPE.EVADE, self:GetDuration(), true)
	hCaster:AddNewModifier(hCaster, self, "modifier_bounty_hunter_2_buff", { duration = self:GetDuration() })
	-- sound
	hCaster:EmitSound("Hero_Riki.Smoke_Screen")
end
---------------------------------------------------------------------
--Modifiers
if modifier_bounty_hunter_2_thinker == nil then
	modifier_bounty_hunter_2_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_bounty_hunter_2_thinker:IsAura()
	return true
end
function modifier_bounty_hunter_2_thinker:GetAuraRadius()
	return self.radius
end
function modifier_bounty_hunter_2_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_bounty_hunter_2_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_bounty_hunter_2_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_bounty_hunter_2_thinker:GetModifierAura()
	return "modifier_bounty_hunter_2_debuff"
end
function modifier_bounty_hunter_2_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_smokebomb.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(iParticleID, true, false, -1, false, false)
	end
end
---------------------------------------------------------------------
if modifier_bounty_hunter_2_buff == nil then
	modifier_bounty_hunter_2_buff = class({}, nil, eom_modifier)
end
function modifier_bounty_hunter_2_buff:OnCreated(params)
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
	end
end
function modifier_bounty_hunter_2_buff:OnRefresh(params)
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
	end
end
function modifier_bounty_hunter_2_buff:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
	}
end
function modifier_bounty_hunter_2_buff:GetAttackCritBonus(params)
	return self.crit_mult, 100
end
function modifier_bounty_hunter_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
end
function modifier_bounty_hunter_2_buff:GetModifierInvisibilityLevel()
	return 1
end
---------------------------------------------------------------------
if modifier_bounty_hunter_2_debuff == nil then
	modifier_bounty_hunter_2_debuff = class({}, nil, eom_modifier)
end
-- function modifier_bounty_hunter_2_debuff:IsDebuff()
-- 	return true
-- end
function modifier_bounty_hunter_2_debuff:OnCreated(params)
	self.attack_miss = self:GetAbilitySpecialValueFor("attack_miss")
end
function modifier_bounty_hunter_2_debuff:OnRefresh(params)
	self.attack_miss = self:GetAbilitySpecialValueFor("attack_miss")
end
function modifier_bounty_hunter_2_debuff:EDeclareFunctions()
	return {
		EMDF_ATTACK_MISS_BONUS,
	}
end
function modifier_bounty_hunter_2_debuff:GetAttackMissBonus()
	return 100, self.attack_miss
end