LinkLuaModifier("modifier_lycan_2", "abilities/tower/lycan/lycan_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_2_wolf", "abilities/tower/lycan/lycan_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_2_tear", "abilities/tower/lycan/lycan_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_2_incentive", "abilities/tower/lycan/lycan_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_3_form", "abilities/tower/lycan/lycan_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if lycan_2 == nil then
	lycan_2 = class({})
end
function lycan_2:Spawn()
	self.tWolf = {}
end
function lycan_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local iCount = self:GetSpecialValueFor("wolf_count")
	for i = 1, iCount do
		local hUnit = CreateUnitByName("npc_dota_lycan_wolf", hCaster:GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
		hUnit:FireSummonned(hCaster)
		Attributes:Register(hUnit)
		hUnit:AddNewModifier(hCaster, self, "modifier_lycan_2_wolf", { duration = self:GetDuration() })
		hUnit:AddNewModifier(hCaster, nil, "modifier_building_ai", nil)
		hUnit:SetForwardVector(hCaster:GetForwardVector())
		hUnit:SetHullRadius(16)
		FindClearSpaceForUnit(hUnit, hCaster:GetAbsOrigin(), true)
		table.insert(self.tWolf, hUnit)
		if hCaster:HasModifier("modifier_lycan_3_form") then
			local hModifier = hCaster:FindModifierByName("modifier_lycan_3_form")
			hUnit:AddNewModifier(hCaster, hModifier:GetAbility(), "modifier_lycan_3_form", { duration = hModifier:GetRemainingTime() })
		end
	end
end
function lycan_2:GetIntrinsicModifierName()
	return "modifier_lycan_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_lycan_2 == nil then
	modifier_lycan_2 = class({}, nil, ModifierHidden)
end
function modifier_lycan_2:OnCreated(params)
	self.incentive_duration = self:GetAbilitySpecialValueFor("incentive_duration")
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_lycan_2:OnIntervalThink()
	if self:GetAbility():IsAbilityReady() then
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	end
end
function modifier_lycan_2:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() }
	}
end
function modifier_lycan_2:OnDeath(params)
	if IsValid(params.attacker) and IsValid(self:GetCaster()) and not params.attacker:IsFriendly(self:GetCaster()) then
		for _, hUnit in ipairs(self:GetAbility().tWolf) do
			hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lycan_2_incentive", { duration = self.incentive_duration })
		end
	end
end
---------------------------------------------------------------------
if modifier_lycan_2_wolf == nil then
	modifier_lycan_2_wolf = class({}, nil, eom_modifier)
end
function modifier_lycan_2_wolf:OnCreated(params)
	self.health = self:GetCaster():GetVal(ATTRIBUTE_KIND.StatusHealth) * self:GetAbilitySpecialValueFor("health_pct") * 0.01
	self.attack = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self:GetAbilitySpecialValueFor("attack_pct") * 0.01
	self.tear_duration = self:GetAbilitySpecialValueFor("tear_duration")
	self.incentive_duration = self:GetAbilitySpecialValueFor("incentive_duration")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lycan_2_wolf:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_lycan_2_wolf:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveModifierByName("modifier_building_ai")
		hParent:MakeIllusion()
		hParent:AddNoDraw()
		hParent:ForceKill(false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		if not IsValid(self:GetAbility()) then
			return
		end
		ArrayRemove(self:GetAbility().tWolf, hParent)
	end
end
function modifier_lycan_2_wolf:EDeclareFunctions()
	return {
		[EMDF_STATUS_HEALTH_BONUS] = self.health,
		[EMDF_PHYSICAL_ATTACK_BONUS] = self.attack,
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() },
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() },
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_lycan_2_wolf:GetStatusHealthBonus()
	return self.health
end
function modifier_lycan_2_wolf:GetPhysicalAttackBonus()
	return self.attack
end
function modifier_lycan_2_wolf:OnAttackLanded(params)
	params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lycan_2_tear", { duration = self.tear_duration })
end
function modifier_lycan_2_wolf:OnDeath(params)
	if IsValid(params.attacker) and IsValid(self:GetCaster()) and not params.attacker:IsFriendly(self:GetCaster()) then
		for _, hUnit in ipairs(self:GetAbility().tWolf) do
			hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lycan_2_incentive", { duration = self.incentive_duration })
		end
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lycan_2_incentive", { duration = self.incentive_duration })
		self:GetCaster():EmitSound("Hero_Lycan.Howl")
	end
end
function modifier_lycan_2_wolf:OnBattleEnd()
	self:Destroy()
end
---------------------------------------------------------------------
if modifier_lycan_2_tear == nil then
	modifier_lycan_2_tear = class({}, nil, eom_modifier)
end
function modifier_lycan_2_tear:IsDebuff()
	return true
end
function modifier_lycan_2_tear:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_lycan_2_tear:OnIntervalThink()
	if self:GetCaster() and self:GetAbility() then
		self:GetCaster():DealDamage(self:GetParent(), self:GetAbility())
	end
end
---------------------------------------------------------------------
if modifier_lycan_2_incentive == nil then
	modifier_lycan_2_incentive = class({}, nil, eom_modifier)
end
function modifier_lycan_2_incentive:OnCreated(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	self.attackspeed_pct = self:GetAbilitySpecialValueFor("attackspeed_pct")
	if IsServer() then
	end
end
function modifier_lycan_2_incentive:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.attackspeed_pct,
	}
end
function modifier_lycan_2_incentive:GetAttackCritBonus()
	return self.crit_mult, self.crit_chance
end
function modifier_lycan_2_incentive:GetAttackSpeedPercentage()
	return self.attackspeed_pct
end