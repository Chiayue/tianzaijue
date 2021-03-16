LinkLuaModifier("modifier_clinkz_3", "abilities/tower/clinkz/clinkz_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if clinkz_3 == nil then
	clinkz_3 = class({})
end
function clinkz_3:GetManaCost(iLevel)
	if self:GetCaster():HasModifier("modifier_clinkz_2") then
		return 0
	end
	return self.BaseClass.GetManaCost(self, iLevel)
end
function clinkz_3:GetIntrinsicModifierName()
	return "modifier_clinkz_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_clinkz_3 == nil then
	modifier_clinkz_3 = class({}, nil, eom_modifier)
end
function modifier_clinkz_3:IsHidden()
	return true
end
function modifier_clinkz_3:IsDebuff()
	return false
end
function modifier_clinkz_3:IsPurgable()
	return false
end
function modifier_clinkz_3:IsPurgeException()
	return false
end
function modifier_clinkz_3:IsStunDebuff()
	return false
end
function modifier_clinkz_3:AllowIllusionDuplicate()
	return false
end
function modifier_clinkz_3:OnCreated(params)
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
		self.tRecords = {}
	end
end
function modifier_clinkz_3:OnRefresh(params)
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_clinkz_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_clinkz_3:EDeclareFunctions()
	return {
		EMDF_ATTACKT_PROJECTILE,
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_ATTACK_RECORD_DESTROY,
	}
end
function modifier_clinkz_3:GetAttackProjectile(params)
	if params == nil then
		return
	end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() and hAbility:IsOwnersManaEnough() then
		hParent:EmitSound("Hero_Clinkz.SearingArrows")

		if not hParent:AttackFilter(params.record, ATTACK_STATE_SKIPCOOLDOWN) then
			hAbility:UseResources(true, false, true)
		end

		table.insert(self.tRecords, params.record)

		return "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf"
	end
end
function modifier_clinkz_3:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hParent = self:GetParent()
	if TableFindKey(self.tRecords, tAttackInfo.record) ~= nil then
		EmitSoundOnLocationWithCaster(vLocation, "Hero_Clinkz.SearingArrows.Impact", hParent)

		if tAttackInfo.tDamageInfo[DAMAGE_TYPE_PHYSICAL] then
			tAttackInfo.tDamageInfo[DAMAGE_TYPE_PHYSICAL].damage = (tAttackInfo.tDamageInfo[DAMAGE_TYPE_PHYSICAL].damage or 0) + hParent:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.damage*0.01
		end
	end
end
function modifier_clinkz_3:OnCustomAttackRecordDestroy(tAttackInfo)
	ArrayRemove(self.tRecords, tAttackInfo.record)
end