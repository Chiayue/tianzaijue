LinkLuaModifier("modifier_anti_mage_1", "abilities/tower/anti_mage/anti_mage_1.lua", LUA_MODIFIER_MOTION_NONE)

if anti_mage_1 == nil then
	anti_mage_1 = class({})
end

function anti_mage_1:GetIntrinsicModifierName()
	return "modifier_anti_mage_1"
end

---------------------------------------------------------------------
--Modifiers
if modifier_anti_mage_1 == nil then
	modifier_anti_mage_1 = class({}, nil, eom_modifier)
end
function modifier_anti_mage_1:IsHidden()
	return false
end
function modifier_anti_mage_1:OnCreated(params)
	self.physical2physical = self:GetAbilitySpecialValueFor("physical2physical")
	self.mana_regain = self:GetAbilitySpecialValueFor("mana_regain")
	self.mana_recover_pct = self:GetAbilitySpecialValueFor("mana_recover_pct")
	self.mana_bonus_pct = self:GetAbilitySpecialValueFor("mana_bonus_pct")
	local hParent = self:GetParent()
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
		self.typeDamage = self:GetAbility():GetAbilityDamageType()
	end
end
function modifier_anti_mage_1:OnRefresh(params)
	self.physical2physical = self:GetAbilitySpecialValueFor("physical2physical")
	self.mana_regain = self:GetAbilitySpecialValueFor("mana_regain")
	self.mana_recover_pct = self:GetAbilitySpecialValueFor("mana_recover_pct")
	if IsServer() then
		-- self.GetParent():SetVal()
	end
end
function modifier_anti_mage_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_STATUS_MANA_BONUS,
	}
end

function modifier_anti_mage_1:GetStatusManaBonus()
	return self:GetStackCount() * self.mana_regain
end

---@param tAttackInfo AttackInfo
function modifier_anti_mage_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if nil == hTarget
	or tAttackInfo.attacker ~= self:GetParent()
	or IsAttackMiss(tAttackInfo)
	or self:GetParent():PassivesDisabled()
	then return end

	local hParent = self:GetParent()

	-- 净化
	hTarget:Purge(true, false, false, false, false)

	--回蓝
	self:IncrementStackCount()
	self:GetAbility():Save("iStackCount", self:GetStackCount())
	self:ForceRefresh()

	hParent:GiveMana(self.mana_recover_pct * 0.01 * hParent:GetVal(ATTRIBUTE_KIND.StatusMana))

	local iParticleID = ParticleManager:CreateParticle('particles/generic_gameplay/generic_manaburn.vpcf', PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Antimage.ManaBreak", hParent)

	--附加伤害
	local fDamage = hParent:GetVal(ATTRIBUTE_KIND.StatusMana) * self.mana_bonus_pct * 0.01
	local tDamageInfo = tAttackInfo.tDamageInfo[self.typeDamage]
	if tDamageInfo then
		tDamageInfo.damage = tDamageInfo.damage + fDamage
	end

end