LinkLuaModifier("modifier_chaos_knight_1", "abilities/tower/chaos_knight/chaos_knight_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if chaos_knight_1 == nil then
	chaos_knight_1 = class({})
end
function chaos_knight_1:GetIntrinsicModifierName()
	return "modifier_chaos_knight_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_chaos_knight_1 == nil then
	modifier_chaos_knight_1 = class({}, nil, eom_modifier)
end
function modifier_chaos_knight_1:IsHidden()
	return true
end
function modifier_chaos_knight_1:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.crit_mult_min = self:GetAbilitySpecialValueFor("crit_mult_min")
	self.crit_mult_max = self:GetAbilitySpecialValueFor("crit_mult_max")
	self.lifesteal_pct = self:GetAbilitySpecialValueFor("lifesteal_pct")
end
function modifier_chaos_knight_1:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.crit_mult_min = self:GetAbilitySpecialValueFor("crit_mult_min")
	self.crit_mult_max = self:GetAbilitySpecialValueFor("crit_mult_max")
	self.lifesteal_pct = self:GetAbilitySpecialValueFor("lifesteal_pct")
end
function modifier_chaos_knight_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_chaos_knight_1:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
		EMDF_ATTACK_HELF_BONUS_PERCENTAGE,
		EMDF_EVENT_ON_ATTACK_RECORD_CREATE
	}
end
function modifier_chaos_knight_1:OnCustomAttackRecordCreate(tAttackInfo)
	if tAttackInfo.target == nil or tAttackInfo.target:GetClassname() == "dota_item_drop" then return end
	if tAttackInfo.attacker ~= self:GetParent() then return end

	self.record = tAttackInfo.record
end
function modifier_chaos_knight_1:GetAttackCritBonus()
	return RandomInt(self.crit_mult_min, self.crit_mult_max), self.chance
end
function modifier_chaos_knight_1:GetAttackHealBonusPercentage()
	if self.record and IsAttackCrit(self.record) then
		return self.lifesteal_pct
	end
end