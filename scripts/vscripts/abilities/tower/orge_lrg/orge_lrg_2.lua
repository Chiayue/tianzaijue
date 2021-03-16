LinkLuaModifier("modifier_orge_lrg_2_buff", "abilities/tower/orge_lrg/orge_lrg_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orge_lrg_2_debuff", "abilities/tower/orge_lrg/orge_lrg_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if orge_lrg_2 == nil then
	orge_lrg_2 = class({})
end
function orge_lrg_2:Trigger(hTarget, buff_duration)
	if self:GetLevel() <= 0
	or not IsValid(hTarget)
	or not hTarget:IsAlive() then
		return
	end

	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_orge_lrg_2_buff", { duration = buff_duration })
end
---------------------------------------------------------------------
--Modifiers
if modifier_orge_lrg_2_buff == nil then
	modifier_orge_lrg_2_buff = class({}, nil, BaseModifier)
end
function modifier_orge_lrg_2_buff:IsAura()
	return true
end
function modifier_orge_lrg_2_buff:GetAuraRadius()
	return self.radius
end
function modifier_orge_lrg_2_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_orge_lrg_2_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_orge_lrg_2_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_orge_lrg_2_buff:GetModifierAura()
	return "modifier_orge_lrg_2_debuff"
end
function modifier_orge_lrg_2_buff:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.health_bonus = self:GetAbilitySpecialValueFor("health_bonus")
	if IsServer() then
		self.debuff_duration = params.debuff_duration
	else
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticle, 2, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(iParticle, false, false, 0, false, false)
	end
end
function modifier_orge_lrg_2_buff:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.health_bonus = self:GetAbilitySpecialValueFor("health_bonus")
	if IsServer() then
		self.debuff_duration = params.debuff_duration
	end
end
function modifier_orge_lrg_2_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_orge_lrg_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}
end
function modifier_orge_lrg_2_buff:GetModifierExtraHealthBonus()
	return self.health_bonus
end

------------------------------------------------------------------------------
if modifier_orge_lrg_2_debuff == nil then
	modifier_orge_lrg_2_debuff = class({}, nil, BaseModifier)
end
function modifier_orge_lrg_2_debuff:IsDebuff()
	return true
end
function modifier_orge_lrg_2_debuff:OnCreated(params)
	self.move_speed_slow_pct = self:GetAbilitySpecialValueFor("move_speed_slow_pct")
end
function modifier_orge_lrg_2_debuff:OnRefresh(params)
	self.move_speed_slow_pct = self:GetAbilitySpecialValueFor("move_speed_slow_pct")
end
function modifier_orge_lrg_2_debuff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_orge_lrg_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end
function modifier_orge_lrg_2_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.move_speed_slow_pct
end