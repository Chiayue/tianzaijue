LinkLuaModifier("modifier_split_attack", "abilities/special_abilities/split_attack.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if split_attack == nil then
	split_attack = class({})
end
function split_attack:GetIntrinsicModifierName()
	return "modifier_split_attack"
end
---------------------------------------------------------------------
--Modifiers
if modifier_split_attack == nil then
	modifier_split_attack = class({}, nil, eom_modifier)
end
function modifier_split_attack:OnCreated(params)
	self.extra_attack_count = self:GetAbilitySpecialValueFor("extra_attack_count")
	self.extra_attack_damage_pct = self:GetAbilitySpecialValueFor("extra_attack_damage_pct")
	if IsServer() then
	end
end
function modifier_split_attack:OnRefresh(params)
	self.extra_attack_count = self:GetAbilitySpecialValueFor("extra_attack_count")
	self.extra_attack_damage_pct = self:GetAbilitySpecialValueFor("extra_attack_damage_pct")
	if IsServer() then
	end
end
function modifier_split_attack:OnDestroy()
	if IsServer() then
	end
end
function modifier_split_attack:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_split_attack:OnAttack(params)
	if params.target == nil
	or params.target:GetClassname() == "dota_item_drop" then
		return
	end

	if params.attacker ~= self:GetParent()
	or params.attacker:PassivesDisabled()
	or params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
		return
	end

	local hAttacker = params.attacker
	local fAttackRange = hAttacker:Script_GetAttackRange()
	local tTargets = FindUnitsInRadius(hAttacker:GetTeamNumber(), hAttacker:GetAbsOrigin(), nil, fAttackRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local count = self.extra_attack_count
	for k, hUnit in pairs(tTargets) do
		if IsValid(hUnit) and hUnit ~= params.target and hUnit:IsAlive() then
			local iAttackState = ATTACK_STATE_NOT_USECASTATTACKORB + ATTACK_STATE_NOT_PROCESSPROCS + ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_IGNOREINVIS + ATTACK_STATE_NO_CLEAVE + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOUNTING
			self.iRecord = hAttacker:Attack(hUnit, iAttackState)
			count = count - 1
			if count <= 0 then
				break
			end
		end
	end
end
function modifier_split_attack:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if tAttackInfo.record == self.iRecord then
		self.iRecord = nil
		-- 分裂伤害提高
		for _, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
			tDamageInfo.damage = tDamageInfo.damage * (1 + self.extra_attack_damage_pct * 0.01)
		end
	end
end