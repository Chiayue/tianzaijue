LinkLuaModifier("modifier_gyro_1", "abilities/tower/gyro/gyro_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyro_1_rocket", "abilities/tower/gyro/gyro_1.lua", LUA_MODIFIER_MOTION_NONE)

if gyro_1 == nil then
	gyro_1 = class({})
end
function gyro_1:GetIntrinsicModifierName()
	return "modifier_gyro_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_gyro_1 == nil then
	modifier_gyro_1 = class({}, nil, eom_modifier)
end
function modifier_gyro_1:IsHidden()
	return true
end
function modifier_gyro_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
	}
end
function modifier_gyro_1:OnAttack(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker ~= self:GetParent() or params.attacker:IsIllusion() then return end
	if self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(false, false, true)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_gyro_1_rocket", nil)
	end
end
---------------------------------------------------------------------
if modifier_gyro_1_rocket == nil then
	modifier_gyro_1_rocket = class({}, nil, eom_modifier)
end
function modifier_gyro_1_rocket:OnCreated(params)
	self.range = self:GetAbilitySpecialValueFor("range")
	self.rockets_per_second = self:GetAbilitySpecialValueFor("rockets_per_second")
	self.poison_chance = self:GetAbilitySpecialValueFor("poison_chance")
	if IsServer() then
		self.iKilled = 0
		self:StartIntervalThink(1 / self.rockets_per_second)
	end
end
function modifier_gyro_1_rocket:OnRefresh(params)
	self.range = self:GetAbilitySpecialValueFor("range")
	self.rockets_per_second = self:GetAbilitySpecialValueFor("rockets_per_second")
	self.poison_chance = self:GetAbilitySpecialValueFor("poison_chance")
	if IsServer() then
		self:StartIntervalThink(1 / self.rockets_per_second)
	end
end
function modifier_gyro_1_rocket:OnIntervalThink()
	local hParent = self:GetParent()
	self:IncrementStackCount()
	local hTarget = hParent:GetAttackTarget()
	if not IsValid(hParent) or not hParent:IsAlive() or hParent:PassivesDisabled() then
		return
	end

	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.range, self:GetAbility())
	if #tTargets > 0 then
		hTarget = tTargets[RandomInt(1, #tTargets)]
	end

	if not IsValid(hTarget) then
		return
	end

	hParent:DealDamage(hTarget, self:GetAbility(), self:GetAbility():GetAbilityDamage())
	if RollPercentage(self.poison_chance) then
		hTarget:AddBuff(hParent, BUFF_TYPE.POISON)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_rocket_barrage.vpcf", PATTACH_CUSTOMORIGIN, hParent)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, RollPercentage(50) and "attach_attack1" or "attach_attack2", hParent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hParent:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Launch")

	if self:GetStackCount() >= self.rockets_per_second then
		self:Destroy()
	end
end