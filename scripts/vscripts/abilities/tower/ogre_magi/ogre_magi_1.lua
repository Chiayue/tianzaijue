LinkLuaModifier("modifier_ogre_magi_1", "abilities/tower/ogre_magi/ogre_magi_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if ogre_magi_1 == nil then
	ogre_magi_1 = class({})
end
function ogre_magi_1:GetIntrinsicModifierName()
	return "modifier_ogre_magi_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_ogre_magi_1 == nil then
	modifier_ogre_magi_1 = class({}, nil, eom_modifier)
end
function modifier_ogre_magi_1:IsHidden()
	return true
end
function modifier_ogre_magi_1:OnCreated(params)
	self.damage_deepen_pct = self:GetAbilitySpecialValueFor("damage_deepen_pct") * 0.01
	self.physical2physical = self:GetAbilitySpecialValueFor("physical2physical") * 0.01
	self.magical2magical = self:GetAbilitySpecialValueFor("magical2magical") * 0.01
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.iDamageType = DAMAGE_TYPE_PHYSICAL
	end
end
function modifier_ogre_magi_1:EDeclareFunctions()
	return {
		-- EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_ATTACKT_ANIMATION,
		[MODIFIER_EVENT_ON_ATTACK_START] = { self:GetParent() },
		[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] = { self:GetParent() },
		[MODIFIER_EVENT_ON_ATTACK_CANCELLED] = { self:GetParent() },
		EMDF_DO_ATTACK_BEHAVIOR,
		EMDF_EVENT_ON_PREPARATION_END
	}
end
function modifier_ogre_magi_1:OnPreparationEnd()
	self:SetStackCount(0)
end
function modifier_ogre_magi_1:GetAttackAnimation(params)
	if self:GetStackCount() > 1 then
		return ACT_DOTA_CAST_ABILITY_1
	end
	return ACT_DOTA_ATTACK
end
function modifier_ogre_magi_1:OnAttackCancelled(params)
	if params.attacker == self:GetParent() then
		self:DecrementStackCount()
	end
end
function modifier_ogre_magi_1:OnAttackStart(params)
	if params.attacker == self:GetParent() then
		local iDamageType = RollPercentage(50) and DAMAGE_TYPE_PHYSICAL or DAMAGE_TYPE_MAGICAL
		if params.attacker:HasModifier("modifier_ogre_magi_2_buff") then
			iDamageType = self.iDamageType
		end
		if iDamageType == self.iDamageType then
			self:IncrementStackCount()
		else
			self:SetStackCount(1)
			self.iDamageType = iDamageType
		end
	end
end
function modifier_ogre_magi_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if not IsValid(tAttackInfo) then end
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local hParent = self:GetParent()

	for _iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		if _iDamageType == DAMAGE_TYPE_PHYSICAL then
			if _iDamageType == self.iDamageType then
				tDamageInfo.damage = tDamageInfo.damage_base * self.physical2physical * (self.damage_deepen_pct * (self:GetStackCount() - 1) + 1)
			else
				tDamageInfo.damage = 0
			end
		elseif _iDamageType == DAMAGE_TYPE_MAGICAL then
			if _iDamageType == self.iDamageType then
				tDamageInfo.damage = tDamageInfo.damage_base * 2 * self.magical2magical * (self.damage_deepen_pct * (self:GetStackCount() - 1) + 1)
			else
				tDamageInfo.damage = 0
			end
		end
	end
end
function modifier_ogre_magi_1:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hParent = self:GetParent()
	local hTarget = tAttackInfo.target

	if self:GetStackCount() > 1 then
		-- 范围伤害
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hTarget:GetAbsOrigin(), self.radius, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			--命中
			EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hUnit, tAttackInfo)
			--伤害
			hAttackAbility:OnDamage(hUnit, tAttackInfo)
		end
		-- 数字特效
		if self.iParticleID ~= nil then
			ParticleManager:DestroyParticle(self.iParticleID, true)
			ParticleManager:ReleaseParticleIndex(self.iParticleID)
			self.iParticleID = nil
		end
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/ogre_magi/ogre_magi_1.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self:GetStackCount(), 0, 0))
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(math.floor(self:GetStackCount() / 10), math.floor(self:GetStackCount() % 10), 0))

		-- particle
		local sParticleName = self.iDamageType == DAMAGE_TYPE_PHYSICAL and "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf" or "particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast.vpcf"
		local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_ABSORIGIN, hTarget)
		ParticleManager:SetParticleControl(iParticleID, 1, hTarget:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- sound
		EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_OgreMagi.Fireblast.Target", hParent)
	else
		--命中
		EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hTarget, tAttackInfo)
		--伤害
		hAttackAbility:OnDamage(hTarget, tAttackInfo)
	end
end
function modifier_ogre_magi_1:OnAttackRecordDestroy(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	params = GetAttackInfo(params.record, hCaster)
	if nil == params then return end
	DelAttackInfo(params.record)
end