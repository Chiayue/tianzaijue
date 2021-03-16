LinkLuaModifier("modifier_vengeful_spirit_1", "abilities/tower/vengeful_spirit/vengeful_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if vengeful_spirit_1 == nil then
	vengeful_spirit_1 = class({})
end
function vengeful_spirit_1:GetIntrinsicModifierName()
	return "modifier_vengeful_spirit_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_vengeful_spirit_1 == nil then
	modifier_vengeful_spirit_1 = class({}, nil, eom_modifier)
end
function modifier_vengeful_spirit_1:IsHidden()
	return true
end
function modifier_vengeful_spirit_1:OnCreated(params)
	self.reduce_health_pct = self:GetAbilitySpecialValueFor("reduce_health_pct")
	self.max_damage = self:GetAbilitySpecialValueFor("max_damage")
	if IsServer() then
	end
end
function modifier_vengeful_spirit_1:OnRefresh(params)
	self.reduce_health_pct = self:GetAbilitySpecialValueFor("reduce_health_pct")
	self.max_damage = self:GetAbilitySpecialValueFor("max_damage")
	if IsServer() then
	end
end
function modifier_vengeful_spirit_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_vengeful_spirit_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_vengeful_spirit_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if nil == hTarget
	or tAttackInfo.attacker ~= self:GetParent()
	or IsAttackMiss(tAttackInfo)
	or self:GetParent():PassivesDisabled()
	then return end

	local hParent = self:GetParent()

	-- 击中额外伤害
	local fReduce = hTarget:GetMaxHealth() - hTarget:GetHealth()
	local fDamage = math.min(fReduce * self.reduce_health_pct * 0.01, self.max_damage)

	--附加伤害
	local tDamageInfo = tAttackInfo.tDamageInfo[self:GetAbility():GetAbilityDamageType()]
	if tDamageInfo then
		tDamageInfo.damage = tDamageInfo.damage + fDamage
	end
end