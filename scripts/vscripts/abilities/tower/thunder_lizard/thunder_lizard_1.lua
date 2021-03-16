LinkLuaModifier("modifier_thunder_lizard_1", "abilities/tower/thunder_lizard/thunder_lizard_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_thunder_lizard_1_debuff", "abilities/tower/thunder_lizard/thunder_lizard_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if thunder_lizard_1 == nil then
	thunder_lizard_1 = class({})
end
function thunder_lizard_1:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/thunder_lizard/thunder_lizard_1.vpcf", context)
end
function thunder_lizard_1:GetIntrinsicModifierName()
	return "modifier_thunder_lizard_1"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_thunder_lizard_1 == nil then
	modifier_thunder_lizard_1 = class({}, nil, eom_modifier)
end
function modifier_thunder_lizard_1:IsHidden()
	return true
end
function modifier_thunder_lizard_1:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:StartIntervalThink(math.max(self:GetAbility():GetCooldownTimeRemaining(), 0.5))
		end
	end
end
function modifier_thunder_lizard_1:OnIntervalThink()
	local hParent = self:GetParent()
	if not IsValid(hParent) then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
	if not hParent:IsAlive() then return end
	if hParent:PassivesDisabled() then return end

	local hAbility = self:GetAbility()
	local flDuration = self:GetAbility():GetDuration()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
	hParent:DealDamage(tTargets, hAbility, flDamage)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hParent, hAbility, "modifier_thunder_lizard_1_debuff", { duration = flDuration })
		if hParent.ReduceMagicalArmor then
			hParent:ReduceMagicalArmor(hUnit)
		end
	end
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/thunder_lizard/thunder_lizard_1.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 音效
	hParent:EmitSound("Hero_Disruptor.ThunderStrike.Target")
	self:GetAbility():UseResources(false, false, true)
	self:StartIntervalThink(math.max(self:GetAbility():GetCooldownTimeRemaining(), 0.5))
end
function modifier_thunder_lizard_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_thunder_lizard_1:OnInBattle()
	if IsServer() then
		self:GetAbility():UseResources(false, false, true)
		self:StartIntervalThink(self:GetAbility():GetCooldownTimeRemaining())
	end
end
function modifier_thunder_lizard_1:OnBattleEnd()
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------------------------
if modifier_thunder_lizard_1_debuff == nil then
	modifier_thunder_lizard_1_debuff = class({}, nil, eom_modifier)
end
function modifier_thunder_lizard_1_debuff:IsDebuff()
	return true
end
function modifier_thunder_lizard_1_debuff:OnCreated(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_thunder_lizard_1_debuff:OnRefresh(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_thunder_lizard_1_debuff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ARMOR_BONUS,
	}
end
function modifier_thunder_lizard_1_debuff:GetMagicalArmorBonus()
	return -self:GetStackCount() * self.armor_reduce
end
function modifier_thunder_lizard_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_thunder_lizard_1_debuff:OnTooltip()
	return self:GetStackCount() * self.armor_reduce
end