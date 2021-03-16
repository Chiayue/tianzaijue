LinkLuaModifier("modifier_nian_7", "abilities/boss/nian_7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nian_7_knockdown_start", "abilities/boss/nian_7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nian_7_knockdown", "abilities/boss/nian_7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nian_7_knockdown_getup", "abilities/boss/nian_7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nian_7_knockdown_rage", "abilities/boss/nian_7.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if nian_7 == nil then
	nian_7 = class({})
end
function nian_7:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5, 1.5)
	hCaster:GameTimer(0.8, function()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), 2000, self)
		for _, hUnit in ipairs(tTargets) do
			hCaster:DealDamage(hUnit, self)
			hCaster:KnockBack(hCaster:GetAbsOrigin(), hUnit, 1000, 0, 2)
		end
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/nian/nian_7.vpcf", PATTACH_CENTER_FOLLOW, hCaster)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(2000, 2000, 2000))
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(2000, 2000, 2000))
		ParticleManager:SetParticleControl(iParticleID, 15, Vector(255, 204, 95))
		ParticleManager:SetParticleControl(iParticleID, 16, Vector(1, 0, 0))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hCaster:SetMaterialGroup("1")
		hCaster:EmitSound("Hero_Terrorblade.Metamorphosis.Scepter")
	end)
	return true
end
function nian_7:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:FadeGesture(ACT_DOTA_CAST_ABILITY_5)
	hCaster:AddNewModifier(hCaster, self, "modifier_nian_7_knockdown_rage", nil)
end
function nian_7:GetIntrinsicModifierName()
	return "modifier_nian_7"
end
---------------------------------------------------------------------
--Modifiers
if modifier_nian_7 == nil then
	modifier_nian_7 = class({}, nil, eom_modifier)
end
function modifier_nian_7:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	self.knockdown_damage_pct = self:GetAbilitySpecialValueFor("knockdown_damage_pct")
	if IsServer() then
		self.bTrigger = false
	end
end
function modifier_nian_7:OnRefresh(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	self.knockdown_damage_pct = self:GetAbilitySpecialValueFor("knockdown_damage_pct")
	if IsServer() then
	end
end
function modifier_nian_7:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_INCOMING_PERCENTAGE,
	}
end

function modifier_nian_7:GetIncomingPercentage()
	if self.bTrigger == false then
		return -self.damage_reduce_pct
	end
end
function modifier_nian_7:OnTakeDamage(params)
	if self:GetParent():GetHealthPercent() <= self.trigger_pct and self.bTrigger == false then
		self.bTrigger = true
		self:GetParent():InterruptMotionControllers(false)
		self:GetParent():Stop()
		self:GetParent():FadeGesture(ACT_SMALL_FLINCH)
		self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_6)
		self:GetParent():RemoveAllModifiers(1, false, true, true)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_nian_7_knockdown_start", { duration = 1.86 })
	end
end
---------------------------------------------------------------------
if modifier_nian_7_knockdown_start == nil then
	modifier_nian_7_knockdown_start = class({}, nil, eom_modifier)
end
function modifier_nian_7_knockdown_start:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_DIE)
	end
end
function modifier_nian_7_knockdown_start:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_DIE)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_nian_7_knockdown", { duration = self.duration })
	end
end
function modifier_nian_7_knockdown_start:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end
---------------------------------------------------------------------
if modifier_nian_7_knockdown == nil then
	modifier_nian_7_knockdown = class({}, nil, eom_modifier)
end
function modifier_nian_7_knockdown:OnCreated(params)
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_BELLYACHE_LOOP)
	end
end
function modifier_nian_7_knockdown:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_BELLYACHE_LOOP)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_nian_7_knockdown_getup", { duration = 2.34 })
	end
end
function modifier_nian_7_knockdown:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end
---------------------------------------------------------------------
if modifier_nian_7_knockdown_getup == nil then
	modifier_nian_7_knockdown_getup = class({}, nil, eom_modifier)
end
function modifier_nian_7_knockdown_getup:OnCreated(params)
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_BELLYACHE_END)
	end
end
function modifier_nian_7_knockdown_getup:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_BELLYACHE_END)
		self:GetParent()
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	end
end
function modifier_nian_7_knockdown_getup:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_nian_7_knockdown_getup:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -90
	}
end
---------------------------------------------------------------------
if modifier_nian_7_knockdown_rage == nil then
	modifier_nian_7_knockdown_rage = class({}, nil, eom_modifier)
end
function modifier_nian_7_knockdown_rage:OnCreated(params)
	if IsServer() then
	end
end
function modifier_nian_7_knockdown_rage:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = self:GetAbilitySpecialValueFor("attackspeed"),
		[EMDF_INCOMING_PERCENTAGE] = -self:GetAbilitySpecialValueFor("damage_reduce_pct")
	}
end