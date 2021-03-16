LinkLuaModifier("modifier_silencer_2", "abilities/tower/silencer/silencer_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silencer_2_summon_buff", "abilities/tower/silencer/silencer_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if silencer_2 == nil then
	silencer_2 = class({})
end
function silencer_2:GetIntrinsicModifierName()
	return "modifier_silencer_2"
end
function silencer_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local cost_max_health_pct = self:GetSpecialValueFor("cost_max_health_pct")

	local hUnit = CreateUnitByName('silencer_summon', hCaster:GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
	Attributes:Register(hUnit)
	FindClearSpaceForUnit(hUnit, hCaster:GetAbsOrigin(), true)

	local hAbility = hUnit:FindAbilityByName("silencer_summon_1")
	hAbility:SetLevel(1)

	if hCaster:GetHealth() <= hCaster:GetMaxHealth() * cost_max_health_pct * 0.01 then
		hUnit:AddNewModifier(hCaster, self, "modifier_silencer_2_summon_buff", {})
	end

	ApplyDamage({
		ability = self,
		attacker = hCaster,
		victim = hCaster,
		damage = hCaster:GetMaxHealth() * cost_max_health_pct * 0.01,
		damage_type = DAMAGE_TYPE_PURE
	})
end
---------------------------------------------------------------------
--Modifiers
if modifier_silencer_2 == nil then
	modifier_silencer_2 = class({})
end
function modifier_silencer_2:IsHidden()
	return true
end
function modifier_silencer_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_silencer_2:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self:GetAbility():entindex()
		})
	end
end

------------------------------------------------------------------------------
if modifier_silencer_2_summon_buff == nil then
	modifier_silencer_2_summon_buff = class({}, nil, eom_modifier)
end
function modifier_silencer_2_summon_buff:OnCreated(params)
	self.summon_attack_bonus_pct = self:GetAbilitySpecialValueFor("summon_attack_bonus_pct")
end
function modifier_silencer_2_summon_buff:OnRefresh(params)
	self.summon_attack_bonus_pct = self:GetAbilitySpecialValueFor("summon_attack_bonus_pct")
end
function modifier_silencer_2_summon_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_silencer_2_summon_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.summon_attack_bonus_pct
	}
end
function modifier_silencer_2_summon_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_silencer_2_summon_buff:OnTooltip()
	return self.summon_attack_bonus_pct
end
function modifier_silencer_2_summon_buff:GetPhysicalAttackBonusPercentage()
	return self.summon_attack_bonus_pct
end