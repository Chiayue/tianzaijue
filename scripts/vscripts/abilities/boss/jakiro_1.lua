LinkLuaModifier("modifier_jakiro_1", "abilities/boss/jakiro_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_1_slow", "abilities/boss/jakiro_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_1_ignite", "abilities/boss/jakiro_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if jakiro_1 == nil then
	jakiro_1 = class({})
end
function jakiro_1:GetIntrinsicModifierName()
	return "modifier_jakiro_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_jakiro_1 == nil then
	modifier_jakiro_1 = class({}, nil, eom_modifier)
end
function modifier_jakiro_1:IsHidden()
	return true
end
function modifier_jakiro_1:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_jakiro_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		-- [MODIFIER_EVENT_ON_ATTACK_START] = { self:GetParent() },
		-- [MODIFIER_EVENT_ON_ATTACK_CANCELLED] = { self:GetParent() },
		-- [MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		-- [MODIFIER_EVENT_ON_ATTACK_FINISHED] = { self:GetParent() },
		[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = {self:GetParent()}
	-- EMDF_DO_ATTACK_BEHAVIOR
	}
end
function modifier_jakiro_1:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
end
function modifier_jakiro_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	if tAttackInfo.attacker:HasModifier("modifier_jakiro_3_ice") then
		-- 冰形态攻击减速
		hTarget:AddNewModifier(tAttackInfo.attacker, self:GetAbility(), "modifier_jakiro_1_slow", { duration = self:GetAbilitySpecialValueFor("slow_duration") * hTarget:GetStatusResistanceFactor() })
	else
		-- 火形态攻击燃烧
		hTarget:AddNewModifier(tAttackInfo.attacker, self:GetAbility(), "modifier_jakiro_1_ignite", { duration = self:GetAbilitySpecialValueFor("ignite_duration") })
	end
end
function modifier_jakiro_1:OnAttack(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end

	if params.attacker == self:GetParent() and
	not params.attacker:PassivesDisabled() and
	not params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) and
	params.attacker:HasModifier("modifier_jakiro_3_ice") then	-- 冰形态分裂攻击
		local tTargets = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, params.attacker:GetBaseAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local attack_split = #self:GetCaster():GetActiveEgg() * 2
		for _, hUnit in pairs(tTargets) do
			if attack_split > 0 then
				local iAttackState = ATTACK_STATE_NOT_USECASTATTACKORB + ATTACK_STATE_NOT_PROCESSPROCS + ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_IGNOREINVIS + ATTACK_STATE_NO_CLEAVE + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOUNTING
				params.attacker:Attack(hUnit, iAttackState)
				attack_split = attack_split - 1
			end
			if attack_split <= 0 then
				break
			end
		end
	end
end
function modifier_jakiro_1:OnAbilityExecuted(params)
	if IsServer() then
		EachUnits(function (hUnit)
			if hUnit:IsAlive() then
				local iAttackState = ATTACK_STATE_NOT_USECASTATTACKORB + ATTACK_STATE_NOT_PROCESSPROCS + ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_IGNOREINVIS + ATTACK_STATE_NO_CLEAVE + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOUNTING
				self:GetParent():Attack(hUnit, iAttackState)
			end
		end, UnitType.Building)
	end
end
function modifier_jakiro_1:OnAttackStart(params)
	if params.attacker == self:GetParent() then
		params.attacker:StartGesture(ACT_DOTA_IDLE)
		params.attacker:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, params.attacker:GetAttackSpeed())
	end
end
function modifier_jakiro_1:OnAttackCancelled(params)
	if params.attacker == self:GetParent() then
		params.attacker:FadeGesture(ACT_DOTA_IDLE)
	end
end
function modifier_jakiro_1:OnAttackFinished(params)
	if params.attacker == self:GetParent() then
		params.attacker:FadeGesture(ACT_DOTA_IDLE)
	end
end
---------------------------------------------------------------------
if modifier_jakiro_1_slow == nil then
	modifier_jakiro_1_slow = class({}, nil, eom_modifier)
end
function modifier_jakiro_1_slow:IsDebuff()
	return true
end
function modifier_jakiro_1_slow:OnCreated(params)
	self.attackspeed_slow = self:GetAbilitySpecialValueFor("attackspeed_slow")
	self.movespeed_slow = self:GetAbilitySpecialValueFor("movespeed_slow")
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	if IsServer() then
		if self:GetStackCount() < self.max_stack then
			self:IncrementStackCount()
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_slowed_cold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_jakiro_1_slow:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_jakiro_1_slow:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS,
		EMDF_MOVEMENT_SPEED_BONUS,
	}
end
function modifier_jakiro_1_slow:GetAttackSpeedBonus()
	return -self.attackspeed_slow * self:GetStackCount()
end
function modifier_jakiro_1_slow:GetMoveSpeedBonus()
	return -self.movespeed_slow * self:GetStackCount()
end
---------------------------------------------------------------------
if modifier_jakiro_1_ignite == nil then
	modifier_jakiro_1_ignite = class({}, nil, eom_modifier)
end
function modifier_jakiro_1_ignite:IsDebuff()
	return true
end
function modifier_jakiro_1_ignite:OnCreated(params)
	self.ignite_damage = self:GetAbilitySpecialValueFor("ignite_damage")
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_jakiro_1_ignite:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		if IsValid(hCaster) and IsValid(hAbility) and type(hCaster.GetActiveEgg) == "function" then
			hCaster:DealDamage(self:GetParent(), hAbility, self.ignite_damage * #hCaster:GetActiveEgg())
		end
	end
end