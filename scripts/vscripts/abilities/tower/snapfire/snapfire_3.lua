LinkLuaModifier("modifier_snapfire_3", "abilities/tower/snapfire/snapfire_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_snapfire_3_attack", "abilities/tower/snapfire/snapfire_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if snapfire_3 == nil then
	snapfire_3 = class({})
end
function snapfire_3:Precache(context)
	-- PrecacheResource("particle", "particles/units/heroes/hero_snapfire/snapfire_3.vpcf", context)
	---TODO:热量特效标记没做
end
function snapfire_3:GetIntrinsicModifierName()
	return "modifier_snapfire_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_snapfire_3 == nil then
	modifier_snapfire_3 = class({}, nil, eom_modifier)
end
function modifier_snapfire_3:IsHidden()
	return false
end
function modifier_snapfire_3:OnCreated(params)
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.bonus_attackrange = self:GetAbilitySpecialValueFor("bonus_attackrange")
	self.knockback_distance = self:GetAbilitySpecialValueFor("knockback_distance")
	self.heat_per_attack = self:GetAbilitySpecialValueFor("heat_per_attack")
	self.max_heat = self:GetAbilitySpecialValueFor("max_heat")
	self.cooldown_rate = self:GetAbilitySpecialValueFor("cooldown_rate")
	if IsServer() then
		self.flHeat = 0			-- 热量
		self.flTick = 0.1		-- 计时器间隔
		self.bCooldown = false	-- 是否处于冷却
		self:SetStackCount(1)	-- 0标记冷却，1标记可用
		self:StartIntervalThink(self.flTick)
	end
end
function modifier_snapfire_3:OnRefresh(params)
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.bonus_attackrange = self:GetAbilitySpecialValueFor("bonus_attackrange")
	self.knockback_distance = self:GetAbilitySpecialValueFor("knockback_distance")
	self.heat_per_attack = self:GetAbilitySpecialValueFor("heat_per_attack")
	self.max_heat = self:GetAbilitySpecialValueFor("max_heat")
	self.cooldown_rate = self:GetAbilitySpecialValueFor("cooldown_rate")
end
function modifier_snapfire_3:OnIntervalThink()
	if self.bCooldown == false then
		self.flHeat = math.max(self.flHeat - self.cooldown_rate * self.flTick, 0)
	else
		if self:GetAbility():IsCooldownReady() then
			self.bCooldown = false
			self:SetStackCount(1)
			self:StartIntervalThink(self.flTick)
		end
	end
end
function modifier_snapfire_3:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_ANIMATION] = { 0 },
		EMDF_ATTACKT_PROJECTILE,
		EMDF_ATTACKT_SPEED_BONUS,
		EMDF_ATTACK_RANGE_BONUS,
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		[EMDF_BONUS_MAXIMUM_ATTACK_SPEED] = 2000
	}
end
function modifier_snapfire_3:OnAttack(params)
	if self:GetParent() == params.attacker and self:GetAbility():IsCooldownReady() then
		self.flHeat = self.flHeat + self.heat_per_attack
		if self.flHeat >= self.max_heat then
			-- self:GetAbility():StartCooldown(self.flHeat / self.cooldown_rate)
			self.flHeat = 0
			self.bCooldown = true
			self:SetStackCount(0)
			self:StartIntervalThink(0)
			self:GetAbility():UseResources(false, false, true)
		end
	end
end
function modifier_snapfire_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	}
end
function modifier_snapfire_3:GetModifierBaseAttackTimeConstant()
	if IsServer() then
		local hParent = self:GetParent()
		if self:GetStackCount() == 1 then
			if hParent.IsCooldownReady == nil or hParent:IsCooldownReady() == false then
				return 1
			end
		end
	else
		if self:GetStackCount() == 1 then
			return 1
		end
	end
end
function modifier_snapfire_3:GetActivityTranslationModifiers()
	if self:GetStackCount() == 1 then
		return "turret"
	end
end
function modifier_snapfire_3:GetAttackProjectile()
	if self:GetStackCount() == 1 then
		return "particles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf"
	else
		return "particles/units/heroes/hero_snapfire/hero_snapfire_base_attack.vpcf"
	end
end
function modifier_snapfire_3:GetAttackSpeedBonus()
	if IsServer() then
		local hParent = self:GetParent()
		if self:GetStackCount() == 1 then
			if hParent.IsCooldownReady == nil or hParent:IsCooldownReady() == false then
				return self.bonus_attackspeed
			end
		end
	else
		if self:GetStackCount() == 1 then
			return self.bonus_attackspeed
		end
	end
end
function modifier_snapfire_3:GetAttackRangeBonus()
	if IsServer() then
		local hParent = self:GetParent()
		if self:GetStackCount() == 1 then
			if hParent.IsCooldownReady == nil or hParent:IsCooldownReady() == false then
				return self.bonus_attackrange
			end
		end
	else
		if self:GetStackCount() == 1 then
			return self.bonus_attackrange
		end
	end
end
function modifier_snapfire_3:GetAttackSpeedBonusMaximum()
	return 2000
end