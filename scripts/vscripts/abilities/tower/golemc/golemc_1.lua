LinkLuaModifier("modifier_golemC_1", "abilities/tower/golemC/golemC_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if golemC_1 == nil then
	golemC_1 = class({}, nil, base_attack)
end
function golemC_1:OnAttackLanded(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	params = GetAttackInfo(params.record, params.attacker)
	if nil == params then return end
	local hTarget = params.target
	self:OnDamage(hTarget, params)
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_golemC_1", { duration = self:GetDuration() })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_golemC_1 == nil then
	modifier_golemC_1 = class({}, nil, BaseModifier)
end
function modifier_golemC_1:IsDebuff()
	return true
end
function modifier_golemC_1:OnCreated(params)
	self.physical_damage = self:GetAbilitySpecialValueFor("physical_damage")
	self.magical_damage = self:GetAbilitySpecialValueFor("magical_damage")
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_golemC_1:OnRefresh(params)
	self.physical_damage = self:GetAbilitySpecialValueFor("physical_damage")
	self.magical_damage = self:GetAbilitySpecialValueFor("magical_damage")
	if IsServer() then
	end
end
function modifier_golemC_1:OnIntervalThink()
	if not IsValid(self:GetCaster()) or not IsValid(self:GetAbility()) then
		self:Destroy()
		return
	end
	local tDamageInfo = {
		attacker = self:GetCaster(),
		victim = self:GetParent(),
		ability = self:GetAbility(),
		damage = self.physical_damage * self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01 + self.magical_damage * self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * 0.01,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(tDamageInfo)
end