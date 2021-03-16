LinkLuaModifier("modifier_orge_lrg_1", "abilities/tower/orge_lrg/orge_lrg_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orge_lrg_1_buff", "abilities/tower/orge_lrg/orge_lrg_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orge_lrg_1_debuff", "abilities/tower/orge_lrg/orge_lrg_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if orge_lrg_1 == nil then
	orge_lrg_1 = class({})
end
function orge_lrg_1:GetIntrinsicModifierName()
	return "modifier_orge_lrg_1"
end
function orge_lrg_1:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	local hCaster = self:GetCaster()

	if IsValid(hTarget) then
		local duration = self:GetSpecialValueFor("duration")
		hTarget:AddNewModifier(hCaster, self, "modifier_orge_lrg_1_buff", { duration = duration })

		local hAbility = hCaster:FindAbilityByName("orge_lrg_2")
		if IsValid(hAbility) and hAbility.Trigger then
			hAbility:Trigger(hTarget, duration)
		end

		hAbility = hCaster:FindAbilityByName("orge_lrg_3")
		if IsValid(hAbility) and hAbility.Trigger then
			hAbility:Trigger(hTarget, duration)
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_orge_lrg_1 == nil then
	modifier_orge_lrg_1 = class({})
end
function modifier_orge_lrg_1:IsHidden()
	return true
end
function modifier_orge_lrg_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_orge_lrg_1:OnIntervalThink()
	if GSManager:getStateType() ~= GS_Battle then
		return
	end

	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local radius = self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), self:GetParent())
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local fMaxHealth = -1
		local hTarget = nil
		for k, hUnit in pairs(tTargets) do
			if IsValid(hUnit) then
				local fHealth = hUnit:GetHealth()
				if fHealth > fMaxHealth then
					fMaxHealth = fHealth
					hTarget = hUnit
				end
			end
		end
		if IsValid(hTarget) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = self:GetAbility():entindex(),
				TargetIndex = hTarget:entindex()
			})
		end
	end
end

------------------------------------------------------------------------------
if modifier_orge_lrg_1_buff == nil then
	modifier_orge_lrg_1_buff = class({}, nil, eom_modifier)
end
function modifier_orge_lrg_1_buff:GetEffectName()
	return "particles/units/heroes/hero_lich/lich_frost_armor.vpcf"
end
function modifier_orge_lrg_1_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_orge_lrg_1_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_armor.vpcf"
end
function modifier_orge_lrg_1_buff:StatusEffectPriority()
	return 13
end
function modifier_orge_lrg_1_buff:OnCreated(params)
	self.physical_armor_bonus_pct = self:GetAbilitySpecialValueFor("physical_armor_bonus_pct")
	self.magical_armor_bonus_pct = self:GetAbilitySpecialValueFor("magical_armor_bonus_pct")
	self.debuff_duration = self:GetAbilitySpecialValueFor("debuff_duration")
	if IsServer() then

	end
end
function modifier_orge_lrg_1_buff:OnRefresh(params)
	self.physical_armor_bonus_pct = self:GetAbilitySpecialValueFor("physical_armor_bonus_pct")
	self.magical_armor_bonus_pct = self:GetAbilitySpecialValueFor("magical_armor_bonus_pct")
	self.debuff_duration = self:GetAbilitySpecialValueFor("debuff_duration")
	if IsServer() then
	end
end
function modifier_orge_lrg_1_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_orge_lrg_1_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE] = self.physical_armor_bonus_pct,
		[EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE] = self.magical_armor_bonus_pct,
		[MODIFIER_EVENT_ON_ATTACKED] = {nil, self:GetParent() }
	}
end
function modifier_orge_lrg_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end
function modifier_orge_lrg_1_buff:GetPhysicalArmorBonusPercentage()
	return self.physical_armor_bonus_pct
end
function modifier_orge_lrg_1_buff:GetMagicalArmorBonusPercentage()
	return self.magical_armor_bonus_pct
end
function modifier_orge_lrg_1_buff:OnTooltip()
	return self.physical_armor_bonus_pct
end
function modifier_orge_lrg_1_buff:OnTooltip2()
	return self.magical_armor_bonus_pct
end
function modifier_orge_lrg_1_buff:OnAttacked(params)
	if params.target ~= self:GetParent()
	or not params.attacker:IsAlive() then
		return
	end

	local fDuration = GetStatusDebuffDuration(self.debuff_duration, params.attacker, self:GetParent())
	if 0 < fDuration then
		params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_orge_lrg_1_debuff", { duration = fDuration })
	end
end

------------------------------------------------------------------------------
if modifier_orge_lrg_1_debuff == nil then
	modifier_orge_lrg_1_debuff = class({}, nil, eom_modifier)
end
function modifier_orge_lrg_1_debuff:IsDebuff()
	return true
end
function modifier_orge_lrg_1_debuff:OnCreated(params)
	self.attack_speed_reduce_pct = self:GetAbilitySpecialValueFor("attack_speed_reduce_pct")
end
function modifier_orge_lrg_1_debuff:OnRefresh(params)
	self.attack_speed_reduce_pct = self:GetAbilitySpecialValueFor("attack_speed_reduce_pct")
end
function modifier_orge_lrg_1_debuff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_orge_lrg_1_debuff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = -self.attack_speed_reduce_pct
	}
end
function modifier_orge_lrg_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_orge_lrg_1_debuff:GetAttackSpeedPercentage()
	return -self.attack_speed_reduce_pct
end
function modifier_orge_lrg_1_debuff:OnTooltip()
	return self.attack_speed_reduce_pct
end