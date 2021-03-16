LinkLuaModifier("modifier_faceless_void_1", "abilities/tower/faceless_void/faceless_void_1.lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier( "modifier_faceless_void_1_lock", "abilities/tower/faceless_void/faceless_void_1.lua", LUA_MODIFIER_MOTION_NONE )
if faceless_void_1 == nil then
	faceless_void_1 = class({})
end
function faceless_void_1:TimeLock(hTarget)
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_FacelessVoid.TimeLockImpact")
	hCaster:DealDamage(hTarget, self, self:GetAbilityDamage())
	hTarget:AddBuff(hCaster, BUFF_TYPE.LOCK, self:GetDuration())
	-- hTarget:AddNewModifier(hCaster, self, "modifier_faceless_void_1_lock", {duration = self:GetDuration() * hTarget:GetStatusResistanceFactor()})
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 2, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 技能二
	local hAbility = hCaster:FindAbilityByName("faceless_void_2")
	if IsValid(hAbility) and hAbility:GetLevel() > 0 then
		hAbility:Action(hTarget)
	end
end
function faceless_void_1:GetIntrinsicModifierName()
	return "modifier_faceless_void_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_faceless_void_1 == nil then
	modifier_faceless_void_1 = class({}, nil, eom_modifier)
end
function modifier_faceless_void_1:IsHidden()
	return true
end
function modifier_faceless_void_1:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
		self.records = {}
	end
end
function modifier_faceless_void_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_faceless_void_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local hAbility = self:GetAbility()
	if RollPercentage(self.chance) then
		hAbility:TimeLock(hTarget)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_faceless_void_1_lock == nil then
	modifier_faceless_void_1_lock = class({}, nil, ModifierDebuff)
end
function modifier_faceless_void_1_lock:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end